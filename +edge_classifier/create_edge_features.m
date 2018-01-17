function create_edge_features(id)
    ds = load_dataset(id);
    images = ds.Labels.Image;
    
    input_dir = 'tmp/regionprops_labeled';
    output_dir = 'tmp/edge_features';

    features = table();
    
    for i = 1:size(images, 1)
        m = matfile(['datasets/' num2str(id) '/' input_dir '/' images{i} '/' 'props.mat']);
        props = m.props;
        
        props.Id(:) = 1:size(props, 1);
        props.Image(:) = images(i);
        
        props.IsROI(:) = false;
        
        files = dir(['datasets/' num2str(id) '/' input_dir '/' images{i} '/+*.png']);
        
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
    
    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end
    
    m = matfile(['datasets/' num2str(id) '/' output_dir '/edge_features.mat']);
    m.features = features;
end