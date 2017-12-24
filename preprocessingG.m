id = 1;
ds = load_dataset(id);

images = ds.Image;

if ~exist('datasets/1/tmp/projected', 'dir')
    mkdir('datasets/1/tmp/projected');
end

if ~exist('datasets/1/tmp/bw80', 'dir')
    mkdir('datasets/1/tmp/bw80');
end

if ~exist('datasets/1/tmp/edge', 'dir')
    mkdir('datasets/1/tmp/edge');
end

if ~exist('datasets/1/tmp/sharpRadius', 'dir')
    mkdir('datasets/1/tmp/sharpRadius');
end

if ~exist('datasets/1/tmp/sharpAmount', 'dir')
    mkdir('datasets/1/tmp/sharpAmount');
end

if ~exist('datasets/1/tmp/sharpThreshold', 'dir')
    mkdir('datasets/1/tmp/sharpThreshold');
end

if ~exist('datasets/1/tmp/sharpGauss', 'dir')
    mkdir('datasets/1/tmp/sharpGauss');
end

if ~exist('datasets/1/tmp/sharp', 'dir')
    mkdir('datasets/1/tmp/sharp');
end

%%
parfor i = 1:size(ds, 1)
   im = imread(['datasets/' num2str(id) '/images/' images{i} '.jpg']);
   
   gray = rgb2gray(im);
   
   imwrite(gray, ['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
end

%%
parfor i = 1:size(ds, 1)
   im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
   
   sharpened = imsharpen(im);
   
   imwrite(sharpened, ['datasets/' num2str(id) '/tmp/sharpened/' images{i} '.jpg']);
end
%%
parfor i = 1:size(ds, 1)
   im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
   
   sharpened = imsharpen(im, 'Radius', 25);
   
   imwrite(sharpened, ['datasets/' num2str(id) '/tmp/sharpRadius/' images{i} '.jpg']);
end
%%
parfor i = 1:size(ds, 1)
   im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
   
   sharpened = imsharpen(im, 'Amount', 2);
   
   imwrite(sharpened, ['datasets/' num2str(id) '/tmp/sharpAmount/' images{i} '.jpg']);
end
%%
parfor i = 1:size(ds, 1)
   im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
   
   sharpened = imsharpen(im, 'Threshold', 0.7);
   
   imwrite(sharpened, ['datasets/' num2str(id) '/tmp/sharpThreshold/' images{i} '.jpg']);
end

%%
parfor i = 1:size(ds, 1)
   im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
   
   mask = padarray(2,[2 2]) - fspecial('gaussian' ,[5 5],2);
   sharpened = imfilter(im, mask);
   
   imwrite(sharpened, ['datasets/' num2str(id) '/tmp/sharpGauss/' images{i} '.jpg']);
end
%%
parfor i = 1:size(ds, 1)
    im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
   
    mask = fspecial('unsharp', 1);
    sharpened = imfilter(im, mask);
   
   imwrite(sharpened, ['datasets/' num2str(id) '/tmp/sharp/' images{i} '.jpg']);
end

%%

for i = 1:size(ds, 1)
   im = imread(['datasets/' num2str(id) '/tmp/sharpRadius/' images{i} '.jpg']);
   
   bw = sauvola(im, [80,80]);
   
   imwrite(bw, ['datasets/' num2str(id) '/tmp/bw80/' images{i} '.jpg']);
end

%%
parfor i = 1:size(ds, 1)
   im = imread(['datasets/' num2str(id) '/tmp/bw80/' images{i} '.jpg']);
   
   edges = edge(im, 'Prewitt', 0.1);
   
   imwrite(edges, ['datasets/' num2str(id) '/tmp/edge/' images{i} '.jpg']);
end

