function out = compute_(im)

    im = im2double(im);
    [rows, cols, chs] = size(im);
    
    bw = ~imbinarize(im);
    
    x = [0 1 1 0; 1 1 1 1; 0 1 1 0];
    
    disk = strel('disk', 1);
    square = strel('square', 2);
    dilated = imdilate(bw, disk);  
    
    opened = imopen(dilated, x);
    
    disk2 = strel('disk', 1);
    label = imclose(opened, disk2);
    
    out = sum(sum(label));

end

