function out = preprocess_board(image, points, cache, id)
    % Disabilita la cache se non viene fornita dal chiamante.
    if nargin < 3
        cache = create_cache(false);
        id = NaN;
    end
    
    % Project Board
    projected = cache(["02.projected", id], "jpg", @project_board, image, points, 'inner');
    
    % CLAHE - Contrast Limited Adaptive Histogram Equalization
    equalized = cache(["03.equalized", id], "jpg", @adapthisteq, projected, 'NumTiles', [4 4]);
    
    out = lazy.gather(equalized);
end
