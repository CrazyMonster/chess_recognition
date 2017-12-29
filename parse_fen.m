function chessboard = parse_fen(fen)

    fen = char(fen);
    chessboard = repmat('*', 8, 8);

    x = 1;
    y = 1;

    for j = 1:numel(fen)
       c = fen(j);
    
        if isstrprop(c, 'digit')
            y = y + str2double(c);
        elseif isstrprop(c, 'alpha')
            chessboard(x, y) = c;
            y = y + 1;
        elseif c == '/'
            x = x + 1;
            y = 1;
        elseif c == ' '
            break;
        else
            error('Carattere non valido.');
        end
    end
end

