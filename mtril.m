function out = mtril(size, k)
%MTRIL ritorna la maschera di una matrice triangolare inferiore di 
%dimensione SIZE.
    
% Source: https://it.mathworks.com/matlabcentral/answers/196637-hi-guys-how-would-one-extract-the-lower-triangle-of-a-matrix-without-using-the-tril-function-and-w#answer_174398

    if numel(size) == 1
        size = [size size];
    end

    if nargin < 2
        k = 0;
    end
    
    a = 1:size(1);
    b = 1:size(2);

    m = rot90(a) + b;

    out = (m - 1 <= size(1) + k);
end