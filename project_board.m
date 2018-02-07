function out = project_board(image, points)
    
    % riordino i punti in senso orario
    convex = convhull(points);
    movingPoints = points(convex(1:4), :);
    
    fixedPoints = [0 0; 1 0; 1 1; 0 1];

    % matrice di trasformazione
    tform = fitgeotrans(movingPoints, fixedPoints, 'projective');
    
    % proietto e ritaglio l'immagine
    warped = imwarp(image, tform, 'OutputView', imref2d([528, 528], [0, 1], [0, 1]));
    
    % rimuovo i bordi della scacchiera
    out = warped(9:520, 9:520);

end 