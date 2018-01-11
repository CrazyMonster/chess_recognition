id = 1;
ds = load_dataset(id);

images = ds.Labels.Image;

parfor i = 1:size(images, 1)
    
    if ~exist(['datasets/' num2str(id) '/tmp_G/cells/' images{i}], 'dir')
        mkdir(['datasets/' num2str(id) '/tmp_G/cells/' images{i}]);
    end
    
    for j = 1:8
        for l = 1:8
            
            x = 64 * (j - 1);
            y = 64 * (l - 1);
            
            im = imread(['datasets/' num2str(id) '/tmp_G/cropped/projectedgray/' images{i} '.jpg']);
            im_cropped = imcrop(im, [x, y, 64, 64]);
            
            imwrite(im_cropped, ['datasets/' num2str(id) '/tmp_G/cells/' images{i} '/' num2str(j) 'x' num2str(l) '.jpg']);
  
        end 
    end
    
end
