function [cv, images] = create_cvpartition(ds)
    images = unique(ds(:, {'Dataset', 'Image', 'Orientation'}));
    cv = cvpartition(images.Orientation, 'Holdout', 0.25);
    
%     test = images(cv.test, :);
%     training = images(cv.training, :);
    
%     test_cells = innerjoin(ds, test);
%     training_cells = innerjoin(ds, training);
end
