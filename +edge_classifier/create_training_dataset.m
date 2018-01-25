function ds = create_training_dataset(ids)
    input_file = 'tmp/edge_features/edge_features.mat';
    
    features = table;
    
    for i = ids
        in = matfile(['datasets/' num2str(i) '/' input_file]);
        props = in.features;
        
        props.Dataset(:) = i;
        
        % Il numero di righe aggiunte varia a seconda dell'immagine, non
        % è possibile preallocare l'array. Il commento sotto disattiva il 
        % warning di MATLAB.
        features = [features; props]; %#ok<AGROW>
    end
    
    % Crea una tabella in cui vengono confrontate tutte le coppie di 
    % regioni di una data immagine.
    A = features; B = features;
    
    comparisons = innerjoin(A, B, 'Keys', {'Dataset', 'Image'});
    comparisons.Order = comparisons.IsROI_A - comparisons.IsROI_B;
    
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