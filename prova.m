id = 2;
ds = load_dataset(id);

images = ds.Image;

parfor i = 1:size(ds, 1)
   im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
   
   bw = sauvola(im, [80,80]);
   
   imwrite(bw, ['datasets/' num2str(id) '/tmp/bw80/' images{i} '.jpg']);
end