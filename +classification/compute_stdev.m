function out = compute_stdev(image)

    image = im2double(image);
    [rows, cols, chs] = size(image);
    out = std(reshape(image, [rows * cols, chs]));

end

