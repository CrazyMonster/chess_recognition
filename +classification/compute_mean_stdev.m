function out = compute_mean_stdev(image)

    image = im2double(image);
    [rows, cols, chs] = size(image);
    media = mean(reshape(image, [rows * cols, chs]));
    varianza = std(reshape(image, [rows * cols, chs]));

    out = [media, varianza];
end

