function create_edge_features(id)
    ds = load_dataset(id);
    
    labels = ds.Labels;
    
    cache = create_cache(ds.path_for_asset("tmp", "dir"));
    
    features = table();
    
    for i = 1:size(labels, 1)
        l = labels(i, :);
        
        regions = cache(["regionprops", l.Image], "mat");
        regions = lazy.unwrap(regions);
        
        props = regions.props;
        
        % Carica le features LBP.
        lbp = cache(["lbp", l.Image], "mat");
        lbp = lazy.unwrap(lbp);
        
        props.LBP = lbp.LBP;
        
        % Memorizza dei metadati relativi alla regione.
        props.Id(:) = 1:size(props, 1);
        props.Image(:) = l.Image;
        
        % Carica le annotazioni delle regioni di interesse.
        props.IsROI(:) = false;
        
        files = dir(ds.path_for_asset(["frames", l.Image, "+*"], "png"));
        
        for j = 1:size(files, 1)
            matches = regexp(files(j).name, '(\d)+', 'match');
            idx = str2double(matches{1});
        
            props.IsROI(idx) = true;
        end
        
        % Il numero di righe aggiunte varia a seconda dell'immagine, non
        % è possibile preallocare l'array. Il commento sotto disattiva il 
        % warning di MATLAB.
        features = [features; props]; %#ok<AGROW>
    end
    
    output_dir = 'tmp/edge_features';
    
    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end
    
    m = matfile(['datasets/' num2str(id) '/' output_dir '/edge_features.mat'], 'Writable', true);
    m.features = features;
end