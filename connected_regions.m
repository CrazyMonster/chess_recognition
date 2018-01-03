id = 1;
ds = load_dataset(id);

images = ds.Labels.Image;

input_dir = 'tmp/edges';
output_dir = 'tmp/connected_regions';

if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
    mkdir(['datasets/' num2str(id) '/' output_dir]);
end

parfor i = 1:size(ds.Labels, 1)
   in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.png']);
   
   out = bwlabel(in);
   out = imadjust(rescale(out));
   
   imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.png']);
end