function [cv, images] = create_cvpartition(ds)
    rcount = unique(ds(:, {'Dataset', 'Image', 'RegionCount'}));
    roi = unique(ds(ds.Relevance(:, 1) == '1', {'Dataset', 'Image', 'Region_A'}));
    
    images = outerjoin(rcount, roi, 'Type', 'left', 'MergeKeys', true);
    has_roi = ~isnan(images.Region_A);
    
    cv = cvpartition(has_roi, 'Holdout', 0.2);
    
    %     test = images(cv.test, :);
    %     training = images(cv.training, :);
    
    %     test_cmp = innerjoin(ds, test(:, {'Dataset', 'Image'}));
    %     training_cmp = innerjoin(ds, training(:, {'Dataset', 'Image'}));
end

