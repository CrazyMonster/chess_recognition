classdef (Sealed) lazy < handle
    properties (Access = private)
        Fn
        
        Triggered
        Result
    end
    
    methods (Static)
        function out = unwrap(L)
            if isa(L, 'lazy')
                out = L.result;
            else
                out = L;
            end
        end
    end
    
    methods
        function L = lazy(fn)
            L.Fn = fn;
            L.Triggered = false;
        end
        
        function out = result(L)
            if ~L.Triggered
                L.Result = L.Fn();
                L.Triggered = true;
            end
            
            out = L.Result;
        end
    end
end
