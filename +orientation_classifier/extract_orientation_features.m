function out = extract_orientation_features(image)
    cols = im2col(double(image), [64 64], 'distinct');
    hog = extractHOGFeatures(image, 'CellSize', [32 32], 'NumBins', 9, 'BlockSize', [2 2], 'BlockOverlap', [0 0]);
    projections = blockproc(image, [64 64], @compute_sum); 
    
    out = table;
    
    out.Mean = mean(cols)';
    out.Stdev = std(cols)';
    out.HOG = reshape(hog, 36, 64)';
    out.ProjectionX = reshape(projections(:, :, 1:64), [], 64);
    out.ProjectionY = reshape(projections(:, :, 65:128), [], 64);
end

function out = compute_sum(block)
    sX = sum(block.data, 1);
    sY = sum(block.data, 2);
    
    out(1, 1, 1:64) = reshape(sX, 1, 1, []);
    out(1, 1, 65:128) = reshape(sY, 1, 1, []);
end