clear;
close all;

% cells
Q = im2double(imread('datasets/1/tmp_G/cells/029/6x1.jpg'));
%n = im2double(imread('datasets/1/tmp_G/cells/029/8x3.jpg'));

% template
[~, ~, T_Q1] = (imread('templates/images/k.w.png'));
[~, ~, T_Q2] = (imread('templates/images/k.b.png'));
%T_n = imread('datasets/1/tmp_G/cells/029/8x3.png');

T_Q1 = im2double(~T_Q1);
T_Q2 = im2double(~T_Q2);



out1 = imfilter(Q, T_Q1);
out2 = imfilter(Q, T_Q2);
%out2 = imfilter(n, T_n);

%figure;imagesc(out1);
%figure;imagesc(out2);


avg = mean2(T_Q1);
T_Q12 = T_Q1-avg;
Q2 = Q-avg;

avg2 = mean2(T_Q2);
T_Q22 = T_Q2-avg2;
Q22 = Q-avg2;


out3 = imfilter(T_Q12, Q2);
out4 = imfilter(T_Q22, Q22);
figure;imagesc(out3);
figure;imagesc(out4);

figure; imshow(Q);
figure; imagesc(T_Q1);
figure; imagesc(T_Q2);
%%

files = dir('datasets/1/tmp_G/cells/002/morphological/1/*out2.jpg');
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
    files = dir('templates/images/64/*.w.png');
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
        
        norm_im = (im - mean);
        norm_template = (template - mean);
        
        filtered = imfilter(norm_im, norm_template);
        
        out(i) = max(filtered(:));
        
        subplot(ceil(numel(t)/4), 4, i);
        imagesc(filtered); axis image; colorbar; title(t{i}.name);
    end
end