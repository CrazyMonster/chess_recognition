id = 2;
ds = load_dataset(id);

images = ds.Labels.Image;
points = ds.Labels.FramePoints;

if ~exist(['datasets/' num2str(id) '/tmp/cropped/projectedbw'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/cropped/projectedbw']);
end

if ~exist(['datasets/' num2str(id) '/tmp/cropped/projectedgray'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/cropped/projectedgray']);
end


if ~exist(['datasets/' num2str(id) '/tmp/cropped/projectededge'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/cropped/projectededge']);
end

%%
parfor i = 1:size(ds.Labels, 1)
    im = imread(['datasets/' num2str(id) '/tmp/bw80/' images{i} '.jpg']);
  
     
    movingPoints = squeeze(points(i, :, :));
    fixedPoints = [0 0; 1 0; 0 1; 1 1];
    
    % matrice di trasformazione
    tform = fitgeotrans(movingPoints, fixedPoints, 'projective');
    
    projected = imwarp(im, tform, 'OutputView', imref2d([512, 512], [0, 1], [0, 1]));
   
    imwrite(projected, ['datasets/' num2str(id) '/tmp/cropped/projectedbw/' images{i} '.jpg']);
end

%%
parfor i = 1:size(ds.Labels, 1)
    im = imread(['datasets/' num2str(id) '/tmp/gray/' images{i} '.jpg']);
  
     
    movingPoints = squeeze(points(i, :, :));
    fixedPoints = [0 0; 1 0; 0 1; 1 1];
    
    % matrice di trasformazione
    tform = fitgeotrans(movingPoints, fixedPoints, 'projective');
    
    projected = imwarp(im, tform, 'OutputView', imref2d([512, 512], [0, 1], [0, 1]));
   
    imwrite(projected, ['datasets/' num2str(id) '/tmp/cropped/projectedgray/' images{i} '.jpg']);
end

%%
parfor i = 1:size(ds.Labels, 1)
    im = imread(['datasets/' num2str(id) '/tmp/edge/' images{i} '.png']);
  
     
    movingPoints = squeeze(points(i, :, :));
    fixedPoints = [0 0; 1 0; 0 1; 1 1];
    
    % matrice di trasformazione
    tform = fitgeotrans(movingPoints, fixedPoints, 'projective');
    
    projected = imwarp(im, tform, 'OutputView', imref2d([512, 512], [0, 1], [0, 1]));
   
    imwrite(projected, ['datasets/' num2str(id) '/tmp/cropped/projectededge/' images{i} '.jpg']);
end
