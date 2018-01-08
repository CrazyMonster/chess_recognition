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

%% Morphological Closing Tests

sizes = 1:10;
se = arrayfun(@(i) strel('square', i), sizes);

input_dir = 'tmp/gray_2048';
output_dir = 'tmp/closed_tests';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   if ~exist(['datasets/' num2str(id) '/' output_dir '/' images{i}], 'dir')
       mkdir(['datasets/' num2str(id) '/' output_dir '/' images{i}]);
   end
   
   for j = sizes
       out = imclose(in, se(j));

       imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '/' num2str(j) '.jpg']);
   end
end

%% Morphological Closing

se = strel('square', 3);

input_dir = 'tmp/gray_2048';
output_dir = 'tmp/closed';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   out = imclose(in, se);
    
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.jpg']);
end

%% Smoothing

sigma = 2.5;

input_dir = 'tmp/closed';
output_dir = 'tmp/smooth';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   out = imgaussfilt(in, sigma);
   
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.jpg']);
end

%% Edges

input_dir = 'tmp/smooth';
output_dir = 'tmp/edges';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   out = edge(in, 'Canny');
   
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.png']);
end

%% Area Opening

min_area = 180;

input_dir = 'tmp/edges';
output_dir = 'tmp/area_opened';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.png']);
   
   out = bwareaopen(in, min_area);
   
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.png']);
end
