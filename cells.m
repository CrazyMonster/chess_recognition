id = 1;
ds = load_dataset(id);

images = ds.Labels.Image;

parfor i = 1:size(images, 1)
    
    if ~exist(['datasets/' num2str(id) '/tmp_G/cells/' images{i}], 'dir')
        mkdir(['datasets/' num2str(id) '/tmp_G/cells/' images{i}]);
    end
    
    filename = ['datasets/' num2str(id) '/tmp/projected/' images{i} '.1.jpg'];
            
    if ~exist(filename, 'file')
        continue
    end

    in = imread(filename);
    
    for j = 1:8
        for l = 1:8
            x = 62 * (j - 1) + 1 + 8;
            y = 62 * (l - 1) + 1 + 8;
            
            out = in(x : x + 61, y : y + 61);
            
            imwrite(out, ['datasets/' num2str(id) '/tmp_G/cells/' images{i} '/' num2str(j) 'x' num2str(l) '.jpg']);
        end
    end
end
