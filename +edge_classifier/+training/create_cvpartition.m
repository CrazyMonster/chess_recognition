function [cv, images] = create_cvpartition(ds)
    rcount = unique(ds(:, {'Dataset', 'Image', 'RegionCount'}));
    roi = unique(ds(ds.Relevance(:, 1) == '1', {'Dataset', 'Image', 'Region_A'}));
    
    images = outerjoin(rcount, roi, 'Type', 'left', 'MergeKeys', true);
    has_roi = ~isnan(images.Region_A);
    
    cv = cvpartition(has_roi, 'Holdout', 0.2);
end

