id = 1;
ds = load_dataset(id);

images = ds.Labels.Image;

[~, ~] = mkdir(['datasets/' num2str(id) '/tmp_G/eq']);

parfor i = 1:size(images, 1)
    path = ['datasets/' num2str(id) '/tmp/projected/' images{i} '.1.jpg'];
    
    if ~exist(path, 'file')
        continue
    end

    in = imread(path);
    in = rgb2gray(in);
    
    in = adapthisteq(in);
    
    imwrite(in, ['datasets/' num2str(id) '/tmp_G/eq/' images{i} '.jpg']);
    
    [~, ~] = mkdir(['datasets/' num2str(id) '/tmp_G/cells/' images{i}]);
    
    for j = 1:8
        for l = 1:8
            x = 62 * (j - 1) + 1 + 8;
            y = 62 * (l - 1) + 1 + 8;
            
            out = in(x : x + 61, y : y + 61);
            
            imwrite(out, ['datasets/' num2str(id) '/tmp_G/cells/' images{i} '/' num2str(j) 'x' num2str(l) '.jpg']);
        end
    end
end
