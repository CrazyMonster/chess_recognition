function out = piece_distribution(ds)
% PIECE_DISTRIBUITION(DS) ritorna il numero di occorrenze per ogni pezzo 
% nel dataset DS.

    labels = cellstr(ds.Labels);

    w = repmat('_b', height(ds), 1);
    w(logical(ds.IsWhite), 2) = 'w';

    a = categorical(strcat(labels, w));
    out = table(categories(a), countcats(a), 'VariableNames', {'Pieces', 'Occurrencies'});
    out = sortrows(out, 'Occurrencies', 'ascend');
end