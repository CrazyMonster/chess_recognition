function out = extract_features(ds)
    id = ds.Id;
    labels = ds.Labels;
    path_for_asset = ds.path_for_asset;
    
    n = height(labels);
    features = cell(n, 4);
    
    parfor i = 1:n
        l = labels(i, :);
        
        % Segnala a MATLAB che questa è intenzionalmente una variabile broadcast. 
        [~] = path_for_asset;
        
        path = path_for_asset(["tmp", "eq", l.Image], "jpg");
        
        image = imread(path);
        board = board_info(l.BoardConfiguration);
        
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

function out = board_info(fen)
    board = parse_fen(fen);
    
    X = repmat((1:8)', 1, 8);
    Y = repmat((1:8), 8, 1);
    
    is_empty = (board == '*');
    is_white = (mod(X + Y, 2) == 0);

    out = struct('Piece', num2cell(board), ...
                 'X', num2cell(X), 'Y', num2cell(Y), ...
                 'IsEmpty', num2cell(is_empty), 'IsWhite', num2cell(is_white));
end

function out = orientation_flags(board, orientation)
    flags = dec2bin(orientation - 1, 2);
    is_empty = [board.IsEmpty];
    is_white = [board.IsWhite];

    out = repmat(flags, 64, 1);
    out(is_empty, 1) = '*';
    out(is_empty & is_white, 2) = '*';
end
