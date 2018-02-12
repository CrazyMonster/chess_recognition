function out = project_board(image, points, location)
    % Riordina i punti in senso orario.
    convex = convhull(points);
    
    movingPoints = points(convex(1:4), :);
    fixedPoints = [0 0; 1 0; 1 1; 0 1];

    % Costruisci la matrice di trasformazione prospettica.
    tform = fitgeotrans(movingPoints, fixedPoints, 'projective');
    
    % Gestisci sia gli angoli esterni che quelli interni del bordo della 
    % scacchiera.
    if location == 'outer'
        size = [528, 528];
    elseif location == 'inner'
        size = [512, 512];
    end
    
    % Proietta e ritaglia l'immagine.
    warped = imwarp(image, tform, 'OutputView', imref2d(size, [0, 1], [0, 1]));
    
    % Rimuovi il bordo della scacchiera se necessario.
    if location == 'outer'
        out = warped(9:520, 9:520);
    elseif location == 'inner'
        out = warped;
    end
end 