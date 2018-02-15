function out = preprocess_image(image, points, cache, id)
    % Disabilita la cache se non viene fornita dal chiamante.
    if nargin < 3
        cache = create_cache(false);
        id = NaN;
    end
    
    % Grayscale
    gray = cache(["01.gray", id], "jpg", @grayscale, image);
    
    % Project Board
    projected = cache(["02.projected", id], "jpg", @project_board, gray, points, 'inner');
    
    % CLAHE - Contrast Limited Adaptive Histogram Equalization
    equalized = cache(["03.equalized", id], "jpg", @adapthisteq, projected);
    
    out = lazy.gather(equalized);
end

function out = grayscale(image)
    if size(image, 3) == 3
        out = rgb2gray(image);
    else
        out = image;
    end
end