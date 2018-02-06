function out = compare_edge_regions(features)
    
    % Crea una tabella in cui vengano confrontate tutte le coppie di 
    % regioni di questa immagine. Sfrutta il fatto che RegionCount è uguale
    % per tutte le regioni per implementare il prodotto cartesiano con
    % la funzione innerjoin(...).
    
    A = features; B = features;
    comparisons = cartprod(A, B);
    
    % Aggiungi una colonna contenente il numero di regioni presenti
    % nell'immagine.
    count = repmat(height(features), height(comparisons), 1);
    
    % Per una serie di feature, calcola i Delta di tra le due regioni di ogni coppia.
    vars = {'Region', 'Area', 'MajorAxisLength', 'MinorAxisLength', ...
            'Eccentricity', 'Orientation', 'ConvexArea', 'FilledArea', ...
            'EulerNumber', 'EquivDiameter', 'Solidity', 'Extent', ...
            'Perimeter', 'LBP'};
    
    a = comparisons(:, strcat(vars, '_A'));
    b = comparisons(:, strcat(vars, '_B'));
    
    delta = cell(numel(vars), 1);
    
    for i = 1:numel(vars)
        delta{i} = a{:, i} - b{:, i};
    end
    
    % Combina le colonne in un'unica tabella.
    out = [table(count, 'VariableNames', {'RegionCount'}), ...
           comparisons, ...
           table(delta{:}, 'VariableNames', strcat(vars, '_Delta'))];
end
