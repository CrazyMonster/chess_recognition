function out = extract_features(ds)
    id = ds.Id;
    labels = ds.Labels;
    path_for_asset = ds.path_for_asset;
    
    cache = create_cache(ds.path_for_asset("tmp", "dir"));
    
    n = height(labels);
    comparisons = cell(n, 1);
    
    parfor i = 1:n
        l = labels(i, :);
        
        % Segnala a MATLAB che questa è intenzionalmente una variabile broadcast. 
        [~] = path_for_asset;
        
        path = path_for_asset(["images", l.Image], "jpg");
        image = lazy(@imread, path);
        
        f = edge_classifier.extract_edge_features(image, cache, l.Image);
        c = edge_classifier.compare_edge_regions(f);
        
        c.Dataset(:) = id;
        c.Image(:) = l.Image;
        c.RegionCount(:) = height(f);
        
        % Riordina le colonne in modo che le tre appena aggiunte compaiano per prime.
        c = [c(:, end-2:end), c(:, 1:end-3)];
        
        comparisons{i} = c;
    end
    
    out = concat_tables(comparisons);
end

function out = concat_tables(t)
    out = table;

    for i = 1:numel(t)
        % Il numero di righe aggiunte varia, non è possibile preallocare la
        % tabella di destinazione. Il commento sotto disattiva il warning 
        % di MATLAB.
        out = [out; t{i}]; %#ok<AGROW>
    end
end
