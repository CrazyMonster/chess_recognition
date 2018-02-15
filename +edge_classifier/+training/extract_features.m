function out = extract_features(ds)
    id = ds.Id;
    labels = ds.Labels;
    path_for_asset = ds.path_for_asset;
    
    cache = create_cache(ds.path_for_asset(["tmp", "edge_classifier"], "dir"));
    
    n = height(labels);
    comparisons = cell(n, 1);
    
    parfor i = 1:n
        l = labels(i, :);
        
        % Segnala a MATLAB che questa è intenzionalmente una variabile broadcast. 
        [~] = path_for_asset;
        
        path = path_for_asset(["images", l.Image], "jpg");
        
        image = lazy(@imread, path);
        image = preprocess_image(image, true, cache, l.Image);
        
        f = edge_classifier.extract_edge_features(image, cache, l.Image);
        c = edge_classifier.compare_edge_regions(f);
        
        c.Dataset(:) = id;
        c.Image(:) = l.Image;
        
        % Riordina le colonne in modo che le due appena aggiunte compaiano per prime.
        c = [c(:, end-1:end), c(:, 1:end-2)];
        
        comparisons{i} = c;
    end
    
    out = vertcat(comparisons{:});
end
