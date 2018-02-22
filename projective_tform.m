function tform = projective_tform(points)
    % Riordina i punti in senso anti-orario.
    convex = convhull(points);
    
    movingPoints = points(convex(1:4), :);
    fixedPoints = [0 0; 1 0; 1 1; 0 1];

    % Costruisci la matrice di trasformazione prospettica.
    tform = fitgeotrans(movingPoints, fixedPoints, 'projective');
end