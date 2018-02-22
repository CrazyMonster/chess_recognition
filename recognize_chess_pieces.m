function fen = recognize_chess_pieces(image, visualize)
    % Riduci l'immagine a massimo 2048px per lato e convertila in scala 
    % di grigi.
    image = preprocess_image(image, true);
       
    % Estrai la cornice della scacchiera.
   	frame = edge_classifier.predict(image);
    
    % Estrai gli angoli della scacchiera.
    corners = detect_corners(frame);
    
    % Effettua la proiezione e l'equalizzazione dell'istogramma
    % dell'immagine.
    [board, tform] = preprocess_board(image, corners, 'outer');
    
    % Stabilisci l'orientamento della scacchiera estratta e correggilo. 
    orientation = orientation_classifier.predict(board);
    
    upright = rot90(board, orientation - 1);
    
    % Riconosci i pezzi sulla scacchiera.
    fen = piece_classifier.predict(upright);
      
    if nargin < 2 || visualize
        plot_board(image, tform, fen);
    end 
end
