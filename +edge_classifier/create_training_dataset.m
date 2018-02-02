function out = create_training_dataset(ids, with_roi)
    if ~exist('with_roi', 'var')
        with_roi = true;
    end

    dataset = table;
    
    % Genera le feature dei dataset richiesti e aggregale in un'unica
    % tabella. Carica le label delle regioni di interesse.
    for i = ids
        f = edge_classifier.extract_dataset_features(i);
        
        if with_roi
            r = edge_classifier.load_roi_labels(i);
        
            assert(height(f) == height(r), "Le regioni di interesse non sono state etichettate correttamente.");
        
            ds = join(f, r);
        else
            ds = f;
        end
            
        % Il numero di righe aggiunte varia a seconda dell'immagine, non
        % è possibile preallocare l'array. Il commento sotto disattiva il 
        % warning di MATLAB.
        dataset = [dataset; ds]; %#ok<AGROW>
    end
    
    % Crea una tabella in cui vengono confrontate tutte le coppie di 
    % regioni di una data immagine.
    A = dataset; B = dataset;
    comparisons = innerjoin(A, B, 'Keys', {'Dataset', 'Image', 'RegionCount'});
    
    % Calcola i Delta di una serie di feature delle due regioni.
    vars = {'Region', 'Area', 'MajorAxisLength', 'MinorAxisLength', ...
            'Eccentricity', 'Orientation', 'ConvexArea', 'FilledArea', ...
            'EulerNumber', 'EquivDiameter', 'Solidity', 'Extent', ...
            'Perimeter', 'LBP'};
    
    for i = 1:numel(vars)
        a = comparisons(:, [vars{i} '_A']);
        b = comparisons(:, [vars{i} '_B']);
        
        comparisons(:, [vars{i} '_Delta']) = table(table2array(a) - table2array(b));
    end
    
    % Rappresenta la rilevanza delle due regioni confrontate in un unica
    % feature, sotto forma di due bit:
    % * 11, entrambe le regioni sono regioni di interesse
    % * 10, la regione A è regione di interesse, la regione B non lo è
    % * 01, la regione A non è regione di interesse, la regione B lo è
    % * 00, nessuna delle due regioni è una regione di interesse
    if with_roi
        comparisons.Relevance = [num2str(comparisons.IsROI_A), num2str(comparisons.IsROI_B)];
    end
    
    out = comparisons;
end