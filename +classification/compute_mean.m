function out = compute_mean(image)

    image = im2double(image);
    [rows, cols, chs] = size(image);
    out = mean(reshape(image, [rows * cols, chs]));
   
end

