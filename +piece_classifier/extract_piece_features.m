function out = extract_piece_features(image)

    out = table;
    
    % Salvo in cols l'array colonna contenente le celle
    cols = im2col(double(image), [64 64], 'distinct');
    board = board_info();
    
    lbp = extractLBPFeatures(image, 'CellSize', [64 64]);
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
    m = graycomatrix(block.data);
    g = m(:)' / sum(m(:));
    out = reshape(g, 1, 1, []);
end

function out = compute_sum(block, dim)
    s = sum(block.data, dim);
    out = reshape(s, 1, 1, []);
end

function out = compute_mean_ratio(cols, global_mean)
    mean_center = mean(cols(2001:2032, :));
    out = mean_center ./ global_mean;
end