function out = extract_piece_features(image)
    out = table;
    
    % Salva in cols l'array colonna contenente le celle.
    cols = im2col(double(image), [64 64], 'distinct');
    board = board_info();
    % Estrai le feature local binary pattern.
    lbp = extractLBPFeatures(image, 'CellSize', [64 64]);
    % Estrai l'istogramma dei gradienti orientati.
    hog = extractHOGFeatures(image, 'CellSize', [16 16], 'BlockSize', [4 4], 'BlockOverlap', [0 0]);
    glcm = blockproc(image, [64 64], @compute_glcm);
    projectionX = blockproc(image, [64 64], @(block) compute_sum(block, 1)); 
    projectionY = blockproc(image, [64 64], @(block) compute_sum(block, 2)); 
    
    out.Mean = mean(cols)';
    out.Stdev = std(cols)';
    out.LBP = reshape(lbp, 59, 64)';
    out.HOG = reshape(hog, 144, 64)';
    out.GLCM = reshape(glcm, [], 64);
    out.ProjectionX = reshape(projectionX, [], 64);
    out.ProjectionY = reshape(projectionY, [], 64);
    out.MeanRatio = compute_mean_ratio(cols, out.Mean')';
    out.IsWhite = [board.IsWhite]';
end


function out = compute_glcm(block)
    % Funzione ausiliaria per calcolare la feature GLCM (texture). 
    % Matrice delle co-occorenze dei livelli di grigio.
    m = graycomatrix(block.data);
    g = m(:)' / sum(m(:));
    out = reshape(g, 1, 1, []);
end

function out = compute_sum(block, dim)
    % Funzione per calcolare le proiezioni orizzontali e verticali.
    s = sum(block.data, dim);
    out = reshape(s, 1, 1, []);
end

function out = compute_mean_ratio(cols, global_mean)
    % Rapporto tra la media della colonna centrale della cella e la cella intera 
    % per distinguere i pezzi bianchi dai pezzi neri.
    mean_center = mean(cols(2001:2032, :));
    out = mean_center ./ global_mean;
end