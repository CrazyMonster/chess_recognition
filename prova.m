id = 1;
ds = load_dataset(id);

images = ds.Labels.Image;

%% Grayscale

input_dir = 'images';
output_dir = 'tmp/gray';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread_rotate(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   out = rgb2gray(in);
   
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.jpg']);
end

%% Downscale

% La dimensione desiderata lungo l'asse PIU' LUNGO dell'immagine di input.
n = 2048;

input_dir = 'tmp/gray';
output_dir = ['tmp/gray_' num2str(n)];

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   [~, idx] = max(size(in));
   
   if idx == 1
       out = imresize(in, [n NaN]);
   else
       out = imresize(in, [NaN n]);
   end
   
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.jpg']);
end

%% Binarization

window = [80, 80];

input_dir = 'tmp/gray_2048';
output_dir = 'tmp/bw';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   out = lib.sauvola(in, window);
   
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.png']);
end

%% Morfology

se = strel('square', 2);

input_dir = 'tmp/bw';
output_dir = 'tmp/bw_dilated';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.png']);
   
   out = imdilate(in, se);
   
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.png']);
end

%% Morphological Closing

se1 = strel('rectangle', [8 2]);
se2 = strel('rectangle', [2 8]);

se3 = strel('rectangle', [10 1]);
se4 = strel('rectangle', [1 10]);

input_dir = 'tmp/bw';
output_dir = 'tmp/bw_closed';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.png']);
   
   in = im2double(in);
   
   out = imclose(in, se1) .* imclose(in, se2);
   %out = imopen(out, se3) .* imopen(out, se4); 
   
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.png']);
end
