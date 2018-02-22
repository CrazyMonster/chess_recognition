function [out, tform] = preprocess_board(image, points, location, cache, id)
    % Disabilita la cache se non viene fornita dal chiamante.
    if nargin < 4
        cache = create_cache(false);
        id = NaN;
    end
    
    % Costruisci la matrice di trasformazione prospettica.
    tform = projective_tform(points);
    
    % Proietta la scacchiera.
    projected = cache(["02.projected", id], "jpg", @project_board, image, tform, location);
    
    % CLAHE - Contrast Limited Adaptive Histogram Equalization
    equalized = cache(["03.equalized", id], "jpg", @adapthisteq, projected, 'NumTiles', [4 4]);
    
    out = lazy.gather(equalized);
end
