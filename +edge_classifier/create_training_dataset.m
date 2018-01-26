function ds = create_training_dataset(ids, with_roi)
    if ~exist('with_roi', 'var')
        with_roi = true;
    end

    dataset = table;
    
    for i = ids
        f = edge_classifier.extract_dataset_features(i);
        
        if with_roi
            r = edge_classifier.load_roi_labels(i);
        
            assert(size(f, 1) == size(r, 1), "Le regioni di interesse non sono state etichettate correttamente.");
        
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
    
    comparisons = innerjoin(A, B, 'Keys', {'Dataset', 'Image'});
    
    % Calcola l'ordine desiderato degli elementi:
    % * -1, la regione A viene prima della regione B
    % *  0, le due regioni sono equivalenti
    % *  1, la regione A viene dopo della regione B
    if with_roi
        comparisons.Order = comparisons.IsROI_A - comparisons.IsROI_B;
    end
    
    vars = {'Area', 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity', ...
            'Orientation', 'ConvexArea', 'FilledArea', 'EulerNumber', ...
            'EquivDiameter', 'Solidity', 'Extent', 'Perimeter', 'LBP'};
    
    for i = 1:numel(vars)
        a = comparisons(:, [vars{i} '_A']);
        b = comparisons(:, [vars{i} '_B']);
        
        comparisons(:, [vars{i} '_Delta']) = table(table2array(a) - table2array(b));
    end
         
    ds = comparisons;
end