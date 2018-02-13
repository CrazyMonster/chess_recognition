id = 1;
ds = load_dataset(id);

images = ds.Labels.Image;

if ~exist(['datasets/' num2str(id) '/tmp/gray'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/gray']);
end

if ~exist(['datasets/' num2str(id) '/tmp/equalized'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/equalized']);
end

if ~exist(['datasets/' num2str(id) '/tmp/projected'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/projected']);
end

if ~exist(['datasets/' num2str(id) '/tmp/bw80'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/bw80']);
end

if ~exist(['datasets/' num2str(id) '/tmp/edge'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/edge']);
end

if ~exist(['datasets/' num2str(id) '/tmp/sharpRadius'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/sharpRadius']);
end

if ~exist(['datasets/' num2str(id) '/tmp/edge2'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/edge2']);
end

% if ~exist(['datasets/' num2str(id) '/tmp/sharpAmount'], 'dir')
%     mkdir(['datasets/2/tmp/sharpAmount']);
% end
% 
% if ~exist(['datasets/' num2str(id) '/tmp/sharpThreshold'], 'dir')
%     mkdir(['datasets/2/tmp/sharpThreshold']);
% end
% 
% if ~exist(['datasets/' num2str(id) '/tmp/sharpGauss'], 'dir')
%     mkdir(['datasets/' num2str(id) '/tmp/sharpGauss']);
% end
% 
% if ~exist(['datasets/' num2str(id) '/tmp/sharp'], 'dir')
%     mkdir(['datasets/' num2str(id) '/tmp/sharp']);
% end

%%
parfor i = 1:size(ds.Labels, 1)
   im = imread(['datasets/' num2str(id) '/images/' images{i} '.jpg']);
   
   gray = rgb2gray(im);
   
   imwrite(gray, ['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
end

%%
parfor i = 1:size(ds.Labels, 1)
   im = imread(['datasets/' num2str(id) '/tmp/smooth/' images{i} '.jpg']);
   
   equalized = histeq(im);
   
   imwrite(equalized, ['datasets/' num2str(id) '/tmp/equalized/' images{i} '.jpg']);
end

%%
% parfor i = 1:size(ds.Labels, 1)
%    im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
%    
%    sharpened = imsharpen(im);
%    
%    imwrite(sharpened, ['datasets/' num2str(id) '/tmp/sharpened/' images{i} '.jpg']);
% end
%%
parfor i = 1:size(ds.Labels, 1)
   im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
   
   sharpened = imsharpen(im, 'Radius', 25);
   
   imwrite(sharpened, ['datasets/' num2str(id) '/tmp/sharpRadius/' images{i} '.jpg']);
end
%%
% parfor i = 1:size(ds.Labels, 1)
%    im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
%    
%    sharpened = imsharpen(im, 'Amount', 2);
%    
%    imwrite(sharpened, ['datasets/' num2str(id) '/tmp/sharpAmount/' images{i} '.jpg']);
% end
% %%
% parfor i = 1:size(ds.Labels, 1)
%    im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
%    
%    sharpened = imsharpen(im, 'Threshold', 0.7);
%    
%    imwrite(sharpened, ['datasets/' num2str(id) '/tmp/sharpThreshold/' images{i} '.jpg']);
% end
% 
% %%
% parfor i = 1:size(ds.Labels, 1)
%    im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
%    
%    mask = padarray(2,[2 2]) - fspecial('gaussian' ,[5 5],2);
%    sharpened = imfilter(im, mask);
%    
%    imwrite(sharpened, ['datasets/' num2str(id) '/tmp/sharpGauss/' images{i} '.jpg']);
% end
% %%
% parfor i = 1:size(ds.Labels, 1)
%     im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
%    
%     mask = fspecial('unsharp', 1);
%     sharpened = imfilter(im, mask);
%    
%    imwrite(sharpened, ['datasets/' num2str(id) '/tmp/sharp/' images{i} '.jpg']);
% end

%%

for i = 1:size(ds.Labels, 1)
   im = imread(['datasets/' num2str(id) '/tmp/sharpRadius/' images{i} '.jpg']);
   
   bw = lib.sauvola(im, [80,80]);
   
   imwrite(bw, ['datasets/' num2str(id) '/tmp/bw80/' images{i} '.jpg']);
end

%%
parfor i =  1:size(ds.Labels, 1)
   im = imread(['datasets/' num2str(id) '/tmp/bw80/' images{i} '.jpg']);
   edges = edge(im, 'Prewitt', 0.1);
   
   imwrite(edges, ['datasets/' num2str(id) '/tmp/edge/' images{i} '.png']);
end

%%
parfor i =  1:size(ds.Labels, 1)
   im = imread(['datasets/' num2str(id) '/tmp/equalized/' images{i} '.jpg']);
   
   edges = edge(im, 'Prewitt', 0.1);
   
   imwrite(edges, ['datasets/' num2str(id) '/tmp/edge2/' images{i} '.jpg']);
end

