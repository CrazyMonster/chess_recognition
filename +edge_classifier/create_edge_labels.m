function create_edge_labels(id)
    ds = load_dataset(id);
    images = ds.Labels.Image;
    
    input_dir = 'tmp/regionprops';
    output_dir = 'tmp/edge_labels';

    labels = table();
    
    for i = 1:size(images, 1)
        files = dir(['datasets/' num2str(id) '/' input_dir '/' images{i} '/+*.png']);
        
        assert(size(files, 1) == 1, ['Annotazione errata per immagine ' images{i} ]);
        
        matches = regexp(files(1).name, '(\d)+', 'match');
        idx = str2double(matches{1});
        
        m = matfile(['datasets/' num2str(id) '/' input_dir '/' images{i} '/' 'props.mat']);
        props = m.props;
        
        props.Image(:) = images(i);
        
        props.IsROI(:) = false;
        props.IsROI(idx) = true;
        
        labels = [labels; props];
    end
    
    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end
    
    m = matfile(['datasets/' num2str(id) '/' output_dir '/edge_labels.mat']);
    m.labels = labels;
end