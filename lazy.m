classdef (Sealed) lazy < handle
    properties (Access = private)
        Fn
        Args
        
        Triggered
        Result
    end
    
    methods (Static)
        function out = unwrap(L)
            if isa(L, 'lazy')
                out = L.result();
            elseif iscell(L)
                out = cellfun(@lazy.unwrap, L, 'UniformOutput', false);
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
        
        function out = result(L)
            if ~L.Triggered
                args = lazy.unwrap(L.Args);
                
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
