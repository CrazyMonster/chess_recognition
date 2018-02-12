function out = extract_features(ds)
    id = ds.Id;
    labels = ds.Labels;
    path_for_asset = ds.path_for_asset;
    
    n = height(labels);
    features = cell(n, 1);
    
    parfor i = 1:n
        l = labels(i, :);
        
        % Segnala a MATLAB che questa è intenzionalmente una variabile broadcast. 
        [~] = path_for_asset;
        
        path = path_for_asset(["images", l.Image], "jpg");
        
        image = lib.imread_rotate(path);
        board = board_info(l.BoardConfiguration);
        points = squeeze(l.FramePoints);
        
        image = rgb2gray(image);
        image = project_board(image, points, 'inner');
        image = adapthisteq(image);
        
        f = piece_classifier.extract_piece_features(image);

        f.Dataset(:) = id;
        f.Image(:) = l.Image;
        f.Cell = [board.X; board.Y]';

        % Riordina le colonne in modo che le quattro appena aggiunte compaiano per prime.
        f = [f(:, end-2:end), f(:, 1:end-3)];

        f.Labels = [board.Piece]';

        features{i} = f;

    end
    
    out = vertcat(features{:});
end
