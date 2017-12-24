id = 1;
ds = load_dataset(id);

images = ds.Image;

control_points = zeros(size(ds, 1), 4, 2);

for i = 1
   im = imread(['datasets/' num2str(id) '/images/' images{i} '.jpg']);
   
   for j=1:4
       [x, y] = getline_zoom(im);
       
       control_points(i, j, :) = [x, y];
   end
   
   save('points', 'control_points');
end

