function fen = serialize_fen(board)

    fen = char();
    
    for i = 1:size(board, 1)
        empty = 0;
        
        for j = 1:size(board, 2)
            
           c = board(i, j);
           
            if c == '*'
                empty = empty + 1; 
                
                if j == 8 || board(i, j + 1) ~= '*'
                    fen = [fen, num2str(empty)];
                    empty = 0;
                end

            else 
                fen = [fen, c];
            end 
        end 
        
        if i < 8
            fen = [fen, '/'];
        end 
        
    end
    
    fen = [fen, ' - 0 1'];
end

