function C = cartprod(A, B)
%CARTPROD Prodotto cartesiano di due tabelle.
%   C = cartprod(A, B)

    % Ripeti le righe delle tabelle di A e B in modo da generare tutte le
    % possibili coppie.
    m = height(A);
    n = height(B);
    
    [idxA, idxB] = meshgrid(1:m, 1:n);
    
    extendedA = A(idxA, :);
    extendedB = B(idxB, :);
    
    % Rinomina le variabili delle due tabelle in modo che abbiano nomi
    % univoci.
    varA = strcat(extendedA.Properties.VariableNames, ['_' inputname(1)]);
    varB = strcat(extendedB.Properties.VariableNames, ['_' inputname(2)]);
    
    extendedA.Properties.VariableNames = varA;
    extendedB.Properties.VariableNames = varB;
    
    % Crea la tabella finale contenente il prodotto cartesiano.
    C = [extendedA, extendedB];
end