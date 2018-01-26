function out = load_roi_labels(id)
    ds = load_dataset(id);
    
    labels = ds.Labels;
    
    out = table;
    
    for i = 1:size(labels, 1)
        l = labels(i, :);
        
        if ~exist(ds.path_for_asset(["frames", l.Image], "dir"), "dir")
            error("Etichette delle regioni di interesse mancanti.");
        end
        
        files = dir(ds.path_for_asset(["frames", l.Image, "*"], "png"));
        n = size(files, 1);
        
        t = table;
        
        t.Dataset(1:n) = id;
        t.Image(1:n) = l.Image;
        
        for j = 1:n
            matches = regexp(files(j).name, '^(?<is_roi>\+?)(?<idx>\d+)', 'names');
            
            t.Region(j) = str2double(matches.idx);
            t.IsROI(j) = isempty(matches.is_roi);
        end
        
        % Il numero di righe aggiunte varia a seconda dell'immagine, non
        % è possibile preallocare l'array. Il commento sotto disattiva il 
        % warning di MATLAB.
        out = [out; t]; %#ok<AGROW>
    end
end
