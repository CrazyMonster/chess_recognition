id = 1;
ds = load_dataset(id);
r = edge_classifier.training.load_roi(ds);

[~, ~] = mkdir(['datasets/' num2str(id) '/tmp/predicted/']);

r = r(r.IsROI == 1, :);

parfor j=1:height(r)
    region = r(j, :);
    
    in = ['datasets/' num2str(id) '/tmp/edge_classifier/09.masked/' char(region.Image) '/' num2str(region.Region) '.jpg'];
    out = ['datasets/' num2str(id) '/tmp/predicted/' char(region.Image) '.jpg'];
    
    copyfile(in, out);
end
