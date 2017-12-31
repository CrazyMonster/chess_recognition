function board = parse_fen(fen)

    fen = char(fen);
    board = repmat('*', 8, 8);

    x = 1;
    y = 1;

    for j = 1:numel(fen)
       c = fen(j);
    
        if isstrprop(c, 'digit')
            assert(x <= 8 && y <= 8, 'Riga della scacchiera troppo lunga.');
            
            n = str2double(c);
            y = y + n;
        elseif isstrprop(c, 'alpha')
            assert(x <= 8 && y <= 8, 'Riga della scacchiera troppo lunga.');
            
            board(x, y) = c;
            y = y + 1;
        elseif c == '/'
            assert(y == 9, 'Riga della scacchiera non completa.');
            
            x = x + 1;
            y = 1;
        elseif c == ' '
            break;
        else
            error('Carattere non valido.');
        end
    end
    
    assert(x == 8 && y == 9, 'Scacchiera non completa.');
end

