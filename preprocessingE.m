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
   in = lib.imread_rotate(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
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

%% Morphological Opening Tests

sizes = [5:5:60, 70:10:100];
se = arrayfun(@(i) strel('square', i), sizes);

input_dir = 'tmp/gray_2048';
output_dir = 'tmp/opened_tests';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   in = im2double(in);
   
   if ~exist(['datasets/' num2str(id) '/' output_dir '/' images{i}], 'dir')
       mkdir(['datasets/' num2str(id) '/' output_dir '/' images{i}]);
   end
   
   for j = 1:numel(sizes)
       out = imopen(in, se(j));

       imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '/' num2str(sizes(j)) '.jpg']);
   end
end

%% Morphological Opening

se = strel('square', 10);

input_dir = 'tmp/gray_2048';
output_dir = 'tmp/opened';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   out = imopen(in, se);
    
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.jpg']);
end

%% Binarization

window = [80, 80];

input_dir = 'tmp/closed_100x100';
output_dir = 'tmp/closed_bw';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   out = lib.sauvola(im, window);
    
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.jpg']);
end

%% Morphological Closing Tests

sizes = 1:10;
se1 = arrayfun(@(i) strel('rectangle', [i ceil(i/2)]), sizes);
se2 = arrayfun(@(i) strel('rectangle', [ceil(i/2) i]), sizes);

input_dir = 'tmp/gray_2048';
output_dir = 'tmp/closed_tests';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   in = im2double(in);
   
   if ~exist(['datasets/' num2str(id) '/' output_dir '/' images{i}], 'dir')
       mkdir(['datasets/' num2str(id) '/' output_dir '/' images{i}]);
   end
   
   for j = sizes
       out = imclose(in, se1(j)) .* imclose(in, se2(j));

       imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '/' num2str(j) '.jpg']);
   end
end

%% Morphological Closing

se1 = strel('rectangle', [8 3]);
se2 = strel('rectangle', [3 8]);

input_dir = 'tmp/gray_2048';
output_dir = 'tmp/closed_10x3';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   in = im2double(in);
   
   out = imclose(in, se1) .* imclose(in, se2);
    
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.jpg']);
end

%% Smoothing

sigma = 2.5;

input_dir = 'tmp/opened';
output_dir = 'tmp/smooth';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   out = imgaussfilt(in, sigma);
   
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.jpg']);
end

%% Binarization

window = [80, 80];

input_dir = 'tmp/smooth';
output_dir = 'tmp/bw';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);
   
   out = lib.sauvola(in, window);
   
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.png']);
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

%% Area Opening Tests

min_areas = 40:20:320;

input_dir = 'tmp/edges';
output_dir = 'tmp/area_opened_tests';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.png']);
   
   if ~exist(['datasets/' num2str(id) '/' output_dir '/' images{i}], 'dir')
       mkdir(['datasets/' num2str(id) '/' output_dir '/' images{i}]);
   end
   
   for j = min_areas
       out = bwareaopen(in, j);

       imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '/' num2str(j) '.png']);
   end
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

%% Area Opening

min_area = 180;

input_dir = 'tmp/area_opened';
output_dir = 'tmp/area_opened_2';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

for i = 29 %1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.png']);
   
   cc = bwconncomp(in);
   props = regionprops('table', cc, ["all"]);
   
   labels = labelmatrix(cc);
   
   idx = find([props.Area] > 160);
   out = ismember(labels, idx);
   
   subplot(1, 2, 1);
   imagesc(labels); axis image; colorbar;
   
   subplot(1, 2, 2);
   imagesc(uint16(labels) .* uint16(out)); axis image; colorbar;
   
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.png']);
end
