function out = create_dataset(ids)
    out = table;
    
    % Genera le feature dei dataset richiesti e le aggrega in un'unica
    % tabella. Carica le label delle regioni di interesse.
    for i = ids
        ds = load_dataset(i);
        f = piece_classifier.training.extract_features(ds);
            
        % Il numero di righe aggiunte varia a seconda dell'immagine, non
        % è possibile preallocare l'array. Il commento sotto disattiva il 
        % warning di MATLAB.
        out = [out; f]; %#ok<AGROW>
    end
end