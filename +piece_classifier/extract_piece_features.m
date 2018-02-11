function out = extract_piece_features(image)

    out = table;
    
    % salvo in cols l'array colonna contenete le celle
    cols = im2col(double(image), [64 64], 'distinct');
    
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
