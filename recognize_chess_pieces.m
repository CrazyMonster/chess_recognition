function fen = recognize_chess_pieces(image, visualize)
% RECOGNIZE_CHESS_PIECES Localizza la scacchiera nell'immagine di input
% IMAGE, riconosce i pezzi e li codifica nella notazione FEN.
%
% Se invocata senza valori di ritorno o se VISUALIZE è true, la funzione 
% visualizza in una figura di MATLAB la posizione della scacchiera 
% nell'immagine e la configurazione di pezzi riconosciuta.
%
% ATTENZIONE: Affinché la visualizzazione funzioni correttamente è 
% necessario che il font Chess Merida sia installato sul sistema. Una copia
% del font è fornita con il progetto, nella cartella fonts/.

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
    
    % Visualizza la scacchiera.
    if nargout == 0 || (nargin == 2 && visualize)
        plot_board(image, tform, fen);
    end 
end
