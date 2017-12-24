id = 1;
ds = load_dataset(id);

images = ds.Image;

if ~exist('datasets/1/tmp/projected', 'dir')
    mkdir('datasets/1/tmp/projected');
end

%%
for i = 13
    im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
    
    movingPoints = [483 1281; 1899 1365; 435 2811; 1829 2709];
    fixedPoints = [0 0; 500 0; 0 500; 500 500];
    
    % matrice di trasformazione
    tform = fitgeotrans(movingPoints, fixedPoints, 'projective');
    
    projected = imwarp(im, tform, 'OutputView', imref2d([500, 500]));
   
    imwrite(projected, ['datasets/' num2str(id) '/tmp/projected/' images{i} '.jpg']);
end
