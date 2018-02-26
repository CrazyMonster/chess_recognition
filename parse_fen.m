function board = parse_fen(fen)

    fen = char(fen);
    board = repmat('*', 8, 8);

    x = 1;
    y = 1;

    for i = 1:numel(fen)
       c = fen(i);
        
       % Controlla se è un numero.
        if isstrprop(c, 'digit')
            assert(x <= 8 && y <= 8, 'Riga della scacchiera troppo lunga.');
            
            % Cella vuota. 
            n = str2double(c);
            y = y + n;
        % Controlla se è una lettera.
        elseif isstrprop(c, 'alpha')
            assert(x <= 8 && y <= 8, 'Riga della scacchiera troppo lunga.');
            
            % Nella cella abbiamo un pezzo.
            board(x, y) = c;
            y = y + 1;
        % Termine della riga della scacchiera.
        elseif c == '/'
            assert(y == 9, 'Riga della scacchiera non completa.');
            
            x = x + 1;
            y = 1;
        % Finite le celle della scacchiera.
        elseif c == ' '
            break;
        else
            error('Carattere non valido.');
        end
    end
    
    assert(x == 8 && y == 9, 'Scacchiera non completa.');
end

