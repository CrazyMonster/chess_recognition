function out = extract_features(ds)
    id = ds.Id;
    labels = ds.Labels;
    path_for_asset = ds.path_for_asset;
    
    n = height(labels);
    features = cell(n, 4);
    
    for i = 1:n
        l = labels(i, :);
        
        % Segnala a MATLAB che questa è intenzionalmente una variabile broadcast. 
        [~] = path_for_asset;
        
        path = path_for_asset(["tmp", "eq", l.Image], "jpg");
        image = imread(path);
        
        for o = 1:4
            f = orientation_classifier.extract_orientation_features(image);

            f.Dataset(:) = id;
            f.Image(:) = l.Image;
            f.Orientation(:) = o;

            % Riordina le colonne in modo che le tre appena aggiunte compaiano per prime.
            f = [f(:, end-2:end), f(:, 1:end-3)];

            features{i, o} = f;
            
            image = rot90(image, -1);
        end
    end
    
    out = vertcat(features{:});
end
