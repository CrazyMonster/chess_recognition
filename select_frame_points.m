id = 1;
ds = load_dataset(id);

labels = ds.Labels;

points = zeros(size(labels, 1), 4, 2);

for i = 1:size(labels, 1)
   l = labels(i, :);
   
   im = imread_rotate(['datasets/' num2str(id) '/images/' char(l.Image) '.jpg']);
   
   for j=1:4
       [x, y] = getline_zoom(im);
       
       points(i, j, :) = [x, y];
   end
   
   save('points', 'points');
end

