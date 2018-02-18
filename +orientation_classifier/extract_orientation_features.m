function out = extract_orientation_features(image)
    cols = im2col(double(image), [64 64], 'distinct');
    hog = extractHOGFeatures(image, 'CellSize', [32 32], 'NumBins', 9, 'BlockSize', [2 2], 'BlockOverlap', [0 0]);
    
    projectionX = blockproc(image, [64 64], @(block) compute_sum(block, 1)); 
    projectionY = blockproc(image, [64 64], @(block) compute_sum(block, 2)); 
    
    out = table;
    
    out.Mean = mean(cols)';
    out.Stdev = std(cols)';
    out.HOG = reshape(hog, 36, 64)';
    out.ProjectionX = reshape(projectionX, [], 64);
    out.ProjectionY = reshape(projectionY, [], 64);
    
end

function out = compute_sum(block, dim)
    s = sum(block.data, dim);
    out = reshape(s, 1, 1, []);
end