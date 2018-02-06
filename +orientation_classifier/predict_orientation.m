id = 3;
ds = load_dataset(id);

labels = ds.Labels;

% creazione dei dati

features = [];
HogFts = [];

counter = 1;

for i = 1:height(labels)
    l = labels(i, :); 
    path = (['datasets/' num2str(id) '/tmp/non_oriented/' char(l.Image) '.jpg']); 
    
    if ~exist(path, 'file')
        continue;
    end 
    
    im = imread(path);
    
    features(counter, :) = classification.compute_mean_stdev(im);
    HogFts(counter, :) = extractHOGFeatures(im);
    
    counter = counter + 1;
end


P3.Features = features;
P3.HogFts = HogFts;