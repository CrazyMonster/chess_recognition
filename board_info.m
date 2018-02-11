function out = board_info(fen)
    X = repmat((1:8)', 1, 8);
    Y = repmat((1:8), 8, 1);
    
    is_white = (mod(X + Y, 2) == 0);

    out = struct('X', num2cell(X), 'Y', num2cell(Y), ...
                 'IsWhite', num2cell(is_white));

    if nargin == 1
        board = parse_fen(fen);
        is_empty = (board == '*');
        
        b = num2cell(board);
        e = num2cell(is_empty);
        
        [out.Piece] = b{:};
        [out.IsEmpty] = e{:};
    end
end
