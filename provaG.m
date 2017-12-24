id = 1;
ds = load_dataset(id);

images = ds.Image;

if ~exist('datasets/1/tmp/gray', 'dir')
    mkdir('datasets/1/tmp/gray');
end

if ~exist('datasets/1/tmp/bw80', 'dir')
    mkdir('datasets/1/tmp/bw80');
end

if ~exist('datasets/1/tmp/edge', 'dir')
    mkdir('datasets/1/tmp/edge');
end

%%
for i = 1:size(ds, 1)
   im = imread(['datasets/' num2str(id) '/images/' images{i} '.jpg']);
   
   gray = rgb2gray(im);
   
   imwrite(gray, ['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
end
%%

for i = 1:size(ds, 1)
   im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
   
   bw = sauvola(im, [80,80]);
   
   imwrite(bw, ['datasets/' num2str(id) '/tmp/bw80/' images{i} '.jpg']);
end
%%

for i = 1:size(ds, 1)
   im = imread(['datasets/' num2str(id) '/tmp/bw80/' images{i} '.jpg']);
   
   edges = edge(im, 'Prewitt', 0.1);
   
   imwrite(edges, ['datasets/' num2str(id) '/tmp/edge/' images{i} '.jpg']);
end

