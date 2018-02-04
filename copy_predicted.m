id = 1;
r = edge_classifier.training.load_roi(id);

[~, ~] = mkdir(['datasets/' num2str(id) '/tmp/11.predicted/']);

r = r(r.IsROI == 1, :);

parfor j=1:height(r)
    region = r(j, :);
    
    in = ['datasets/' num2str(id) '/frames/' char(region.Image) '/+' num2str(region.Region) '.png'];
    out = ['datasets/' num2str(id) '/tmp/11.predicted/' char(region.Image) '.png'];
    
    copyfile(in, out);
end
