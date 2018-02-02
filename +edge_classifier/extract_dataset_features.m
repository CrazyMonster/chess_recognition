function out = extract_dataset_features(id)
    ds = load_dataset(id);
    
    labels = ds.Labels;
    n = height(labels);
    
    path_for_asset = ds.path_for_asset;
    cache = create_cache(ds.path_for_asset("tmp", "dir"));
    
    features = cell(n, 1);
    
    parfor i = 1:n
        l = labels(i, :);
        
        % Segnala a MATLAB che questa è intenzionalmente una variabile broadcast. 
        [~] = path_for_asset;
        
        path = path_for_asset(["images", l.Image], "jpg");
        image = lazy(@imread, path);
        
        f = edge_classifier.extract_edge_features(image, cache, l.Image);
        
        f.Dataset(:) = id;
        f.Image(:) = l.Image;
        
        % Riordina le colonne in modo che le due appena aggiunte compaiano per prime.
        f = [f(:, end-1:end), f(:, 1:end-2)];
        
        features{i} = f;
    end
    
    out = concat_tables(features);
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
