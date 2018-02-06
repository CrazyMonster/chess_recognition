function out = create_dataset(ids, with_relevance)
    
    if nargin < 2
        with_relevance = true;
    end

    out = table;
    
    % Genera le feature dei dataset richiesti e aggregale in un'unica
    % tabella. Carica le label delle regioni di interesse.
    for i = ids
        ds = load_dataset(i);
        f = edge_classifier.training.extract_features(ds);
        
        if with_relevance
            r = edge_classifier.training.load_roi(ds);
        
            A = join(f, r, ...
                      'LeftVariables', {}, ...
                      'LeftKeys',  {'Image', 'Region_A'}, ...
                      'RightKeys', {'Image', 'Region'});
                          
            B = join(f, r, ...
                      'LeftVariables', {}, ...
                      'LeftKeys',  {'Image', 'Region_B'}, ...
                      'RightKeys', {'Image', 'Region'});
            
            % Rappresenta la rilevanza delle due regioni confrontate in un unica
            % feature, sotto forma di due bit:
            % * 11, entrambe le regioni sono regioni di interesse
            % * 10, la regione A è regione di interesse, la regione B non lo è
            % * 01, la regione A non è regione di interesse, la regione B lo è
            % * 00, nessuna delle due regioni è una regione di interesse
            f.Relevance = [num2str(A.IsROI), num2str(B.IsROI)];
        end
            
        % Il numero di righe aggiunte varia a seconda dell'immagine, non
        % è possibile preallocare l'array. Il commento sotto disattiva il 
        % warning di MATLAB.
        out = [out; f]; %#ok<AGROW>
    end
end