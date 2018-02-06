classdef (Sealed) lazy < handle
    properties (Access = private)
        Fn
        Args
        
        Triggered
        Result
    end
    
    methods (Static)
        function out = gather(L)
            if isa(L, 'lazy')
                out = L.result();
            elseif iscell(L)
                out = cellfun(@lazy.gather, L, 'UniformOutput', false);
            else  
                out = L;
            end
        end
    end
    
    methods
        function L = lazy(fn, varargin)
            L.Fn = fn;
            L.Args = varargin;
            
            L.Triggered = false;
        end
    end
        
    methods (Access = private)
        function out = result(L)
            if ~L.Triggered
                args = lazy.gather(L.Args);
                
                L.Result = L.Fn(args{:});
                L.Triggered = true;
                
                % Libera la memoria occupata dal function handle e dagli argomenti.
                L.Fn = [];
                L.Args = [];
            end
            
            out = L.Result;
        end
    end
end
