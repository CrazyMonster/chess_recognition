id = 1;
ds = load_dataset(id);

for i=size(ds, 1)
   im = imread(['datasets/' id '/images/' ds.Image{i} '.jpg']);
   
end