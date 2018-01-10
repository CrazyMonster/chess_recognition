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

%% Region Props

input_dir = 'tmp/edges';
output_dir = 'tmp/regioprops';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.png']);
   
   cc = bwconncomp(in);
   props = regionprops('table', cc, ["Area", "BoundingBox", "Centroid", "ConvexArea", "Eccentricity", "EquivDiameter", "EulerNumber", "Extent", "Extrema", "FilledArea", "MajorAxisLength", "MinorAxisLength", "Orientation", "Perimeter", "Solidity"]);
   
   labels = labelmatrix(cc);
   
%    idx = find([props.Area] > 160);
%    out = ismember(labels, idx);
%    
%    subplot(1, 2, 1);
%    imagesc(labels); axis image; colorbar;
%    
%    subplot(1, 2, 2);
%    imagesc(uint16(labels) .* uint16(out)); axis image; colorbar;
    
   writetable(props, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.csv']);
   
   if ~exist(['datasets/' num2str(id) '/' output_dir '/' images{i}], 'dir')
       mkdir(['datasets/' num2str(id) '/' output_dir '/' images{i}]);
   end
   
   props = regionprops('table', cc, ["Area", "ConvexImage"]);
   
   for j = 1:size(props, 1)
       imwrite(props.ConvexImage{j}, ['datasets/' num2str(id) '/' output_dir '/' images{i} '/' num2str(props.Area(j)) '-' num2str(j) '.png']);
   end
   
end
