id = 1;
ds = load_dataset(id);

images = ds.Image;

if ~exist('datasets/1/tmp/projected', 'dir')
    mkdir('datasets/1/tmp/projected');
end


%%
parfor i = 1:size(ds, 1)
   im = imread(['datasets/' num2str(id) '/images/' images{i} '.jpg']);
   
   
   
   imwrite(im, ['datasets/' num2str(id) '/tmp/projected/' images{i} '.jpg']);
end

