function out = extract_features(ds)
    id = ds.Id;
    labels = ds.Labels;
    path_for_asset = ds.path_for_asset;
    
    cache = create_cache(ds.path_for_asset(["tmp", "orientation_classifier"], "dir"));
    
    n = height(labels);
    features = cell(n, 4);
    
    parfor i = 1:n
        l = labels(i, :);
        
        % Segnala a MATLAB che questa è intenzionalmente una variabile broadcast. 
        [~] = path_for_asset;
        
        path = path_for_asset(["images", l.Image], "jpg");
        
        image = lazy(@imread, path);
        board = board_info(l.BoardConfiguration);
        points = squeeze(l.FramePoints);
        
        image = preprocess_image(image, false, cache, l.Image);
        image = preprocess_board(image, points, 'inner', cache, l.Image);
        
        for o = 1:4
            f = orientation_classifier.extract_orientation_features(image);

            f.Dataset(:) = id;
            f.Image(:) = l.Image;
            f.Orientation(:) = o;
            f.Cell = [board.X; board.Y]';
            
            % Riordina le colonne in modo che le quattro appena aggiunte compaiano per prime.
            f = [f(:, end-3:end), f(:, 1:end-4)];
            
            f.OrientationFlags = orientation_flags(board, o);
            
            features{i, o} = f;
            
            image = rot90(image, -1);
            board = rot90(board, -1);
        end
    end
    
    out = vertcat(features{:});
end

function out = orientation_flags(board, orientation)
    flags = dec2bin(orientation - 1, 2);
    is_empty = [board.IsEmpty];
    is_white = [board.IsWhite];

    out = repmat(flags, 64, 1);
    out(is_empty, 1) = '*';
    out(is_empty & is_white, 2) = '*';
end
