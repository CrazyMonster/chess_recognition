id = 1;
ds = load_dataset(id);

labels = ds.Labels;

points = zeros(size(labels, 1), 4, 2);

for i = 1:size(labels, 1)
   l = labels(i, :);
   
   im = lib.imread_rotate(['datasets/' num2str(id) '/images/' char(l.Image) '.jpg']);
   
   % Ordine dei punti: top-left, top-right, bottom-left, bottom-right
   
   for j=1:4
       [x, y] = lib.getline_zoom(im);
       
       points(i, j, :) = [x, y];
   end
   
   save('points', 'points');
end

