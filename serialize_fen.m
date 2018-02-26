function fen = serialize_fen(board)
    fen = char();
    
    for i = 1:size(board, 1)
        empty = 0;
        
        for j = 1:size(board, 2)
           c = board(i, j);
           
            % Controlla il numero di celle vuote.
            if c == '*'
                empty = empty + 1; 
                
                if j == 8 || board(i, j + 1) ~= '*'
                    % Aggiungi il numero corrispondente alle celle vuote.
                    fen = [fen, num2str(empty)];
                    empty = 0;
                end
            % Aggiungi il carattere alla stringa FEN.
            else 
                fen = [fen, c];
            end 
        end 
        
        % Termine della riga.
        if i < 8
            fen = [fen, '/'];
        end 
    end
    
    % Termine della sequenza.
    fen = [fen, ' - 0 1'];
end

