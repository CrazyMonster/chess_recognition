function out = extract_orientation_features(image)
    cols = im2col(double(image), [64 64], 'distinct');
    hog = extractHOGFeatures(image, 'CellSize', [32 32], 'NumBins', 6, 'BlockSize', [2 2], 'BlockOverlap', [0 0]);
    
    out = table;
    
    out.Mean = mean(cols)';
    out.Stdev = std(cols)';
    out.HOG = reshape(hog, 24, 64)';
end
