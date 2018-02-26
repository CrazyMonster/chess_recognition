function out = detect_corners(image)
%DETECT_CORNERS estrae gli angoli della scacchiera da un'immagine di edge.
    
    numpeaks = 4;
    threshold = 0.2;
    neighborhood = [151 9];
    
    % Costruisci la trasformata di Hough dell'immagine di edge.
    [H, T, R] = hough(image);
    
    % Trova i picchi nella matrice di Hough.
    peaks = houghpeaks(H, numpeaks, ...
                       'Threshold', ceil(threshold * max(H(:))), ...
                       'NHoodSize', neighborhood);
    
    % Estrai i parametri delle rette trovate da HOUGHPEAKS.
    theta = T(peaks(:, 2))';
    rho = R(peaks(:, 1))';
    
    % Per qualche strano motivo HOUGH ritorna gli angoli in gradi invece
    % che radianti.
    theta = deg2rad(theta);
    
    % Costruisci la rappresentazione delle rette in coordinate omogenee.
    %
    % cos(theta)x + sin(theta)y - rho = 0;
    % ax + by + c = 0 => [a, b, c];
    lines = [cos(theta), sin(theta), -rho];
    
    % Genera le coppie di rette delle quali calcolare le intersezioni.
    n = size(lines, 1);
    
    [idxA, idxB] = meshgrid(1:n);
    mask = mtril(n, -1);
    
    A = lines(idxA(mask), :);
    B = lines(idxB(mask), :);
    
    % Calcola i punti di intersezione per ogni coppia di rette in 
    % coordinate omogenee con il prodotto vettoriale.
    points = cross(A, B);
    
    % Converti i punti in coordinate cartesiane.
    points = points(:, 1:2) ./ points(:, 3);
    
    % Scarta le intersezioni fuori dai confini dell'immagine.
    in_bounds = (points(:, 1) >= 1 & points(:, 1) <= size(image, 2) & ...
                 points(:, 2) >= 1 & points(:, 2) <= size(image, 1));
             
    out = points(in_bounds, :);
    
    if size(out, 1) ~= 4
        error('Trovati %d punti di intersezione invece che i 4 attesi.', size(out, 1));
    end
end
