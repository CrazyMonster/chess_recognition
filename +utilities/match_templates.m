files = dir('datasets/2/tmp/cells/002/*.jpg');
n = size(files, 1);

t = load_templates();

figure(1);

for i = 1:numel(t)
    subplot(ceil(numel(t)/4), 4, i);
    
    imagesc(t{i}.image); axis image; colorbar; title(t{i}.name);
end

for i = 1:n
    im = imread([files(i).folder '/' files(i).name]);
    
    out = match(im, t);

    [~, idx] = max(out);

    figure(3);
    subplot(1, 2, 1); imshow(im); title(files(i).name);
    subplot(1, 2, 2); imagesc(t{idx}.image); axis image; colorbar; title(t{idx}.name);
    
    waitforbuttonpress;
end

function t = load_templates()
    files = dir('templates/images/*.png');
    n = size(files, 1);
    
    t = cell(n, 1);
    
    for i = 1:n
        [~, ~, alpha] = imread([files(i).folder '/' files(i).name]);
        
        t{i}.name = files(i).name;
        t{i}.image = 1.0 - im2double(alpha);
    end
end

function out = match(im, t)
    im = im2double(im);
    im = im - mean2(im);
    
    out = zeros(numel(t), 1);
    
    figure(2); 
    
    for i = 1:numel(t)
        template = t{i}.image;
        
        mean = mean2(template);
        std = std2(template);
        
        norm_im = (im - mean) / std;
        norm_template = (template - mean) / std;
        
        filtered = imfilter(norm_im, norm_template);
        
        out(i) = max(filtered(:));
        
        subplot(ceil(numel(t)/4), 4, i);
        imagesc(filtered); axis image; colorbar; title(t{i}.name);
    end
end