function fen = recognize_chess_pieces(image)
    % 
    image = preprocess_image(image, true);
       
    % Estrai la cornice della scacchiera.
   	frame = edge_classifier.predict(image);
    
    % Estrai gli angoli della scacchiera
    corners = detect_corners(frame);
    
    % Effettua la proiezione e l'equalizzazione dell'istogramma
    % dell'immagine
    board = preprocess_board(image, corners, 'outer');
    
    % 
    orientation = orientation_classifier.predict(board);
    
    upright = rot90(board, orientation - 1);
    
    fen = piece_classifier.predict(upright);
end

