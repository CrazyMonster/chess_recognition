function extract_edges(id)
    ds = load_dataset(id);
    images = ds.Labels.Image;
    
    %% Grayscale

    input_dir = 'images';
    output_dir = 'tmp/gray';

    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end

    parfor i = 1:size(images, 1)
       in = lib.imread_rotate(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);

       out = rgb2gray(in);

       imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.jpg']);
    end

    %% Downscale

    % La dimensione desiderata lungo l'asse PIU' LUNGO dell'immagine di input.
    n = 2048;

    input_dir = 'tmp/gray';
    output_dir = ['tmp/gray_' num2str(n)];

    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end

    parfor i = 1:size(images, 1)
       in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);

       [~, idx] = max(size(in));

       if idx == 1
           out = imresize(in, [n NaN]);
       else
           out = imresize(in, [NaN n]);
       end

       imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.jpg']);
    end

    %% Morphological Opening

    se_h = strel('rectangle', [4 8]);
    se_v = strel('rectangle', [8 4]);

    input_dir = 'tmp/gray_2048';
    output_dir = 'tmp/opened';

    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end

    parfor i = 1:size(images, 1)
       in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);

       in = im2double(in);
       out = imopen(in, se_h) .* imopen(in, se_v);

       imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.jpg']);
    end

    %% Smoothing

    sigma = 2.5;

    input_dir = 'tmp/opened';
    output_dir = 'tmp/smooth';

    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end

    parfor i = 1:size(images, 1)
       in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);

       out = imgaussfilt(in, sigma);

       imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.jpg']);
    end

    %% Edges

    input_dir = 'tmp/smooth';
    output_dir = 'tmp/edges';

    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end

    parfor i = 1:size(images, 1)
       in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.jpg']);

       out = edge(in, 'Canny');

       imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.png']);
    end
    
    %% Edge Linking

    max_gap = 1;
    
    input_dir = 'tmp/edges';
    output_dir = 'tmp/edges_linked';

    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end

    parfor i = 1:size(images, 1)
       in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.png']);

       out = lib.filledgegaps(in, max_gap);

       imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.png']);
    end
    
    %% Edge Filtering

    input_dir = 'tmp/edges_linked';
    output_dir = 'tmp/edges_filtered';

    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end

    parfor i = 1:size(images, 1)
        in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.png']);

        cc = bwconncomp(in);
        props = regionprops('table', cc, ["Area", "Eccentricity"]);
        
        labels = labelmatrix(cc);

        idx = find([props.Area] > 900 & [props.Eccentricity] < 0.7);
        out = ismember(labels, idx);
        
        imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '.png']);
    end
    
    %% Region Properties

    input_dir = 'tmp/edges_filtered';
    output_dir = 'tmp/regionprops';

    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end

    parfor i = 1:size(images, 1)
        in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.png']);

        cc = bwconncomp(in);
        props = regionprops('table', cc, ["Area", "BoundingBox", "Centroid", "ConvexArea", "Eccentricity", "EquivDiameter", "EulerNumber", "Extent", "Extrema", "FilledArea", "MajorAxisLength", "MinorAxisLength", "Orientation", "Perimeter", "Solidity"]);
        
        labels = labelmatrix(cc);
        
        if ~exist(['datasets/' num2str(id) '/' output_dir '/' images{i}], 'dir')
            mkdir(['datasets/' num2str(id) '/' output_dir '/' images{i}]);
        end

        for j = 1:size(props, 1)
            out = (labels == j);
            
            imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '/' num2str(j) '.png']);
        end
        
        m = matfile(['datasets/' num2str(id) '/' output_dir '/' images{i} '/' 'props.mat']);
        m.props = props;
    end
    
    %% Masked Images
    
    images_dir = 'tmp/gray_2048';
    input_dir = 'tmp/edges_filtered';
    output_dir = 'tmp/masked';

    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end

    parfor i = 1:size(images, 1)
        image = imread(['datasets/' num2str(id) '/' images_dir '/' images{i} '.jpg']);
        in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.png']);
        
        im = im2double(image);
        
        cc = bwconncomp(in);
        labels = labelmatrix(cc);
        
        n = max(max(labels));
        
        if ~exist(['datasets/' num2str(id) '/' output_dir '/' images{i}], 'dir')
            mkdir(['datasets/' num2str(id) '/' output_dir '/' images{i}]);
        end

        for j = 1:n
            region = (labels == j);
            
            convex = bwconvhull(region);
            masked = im .* double(convex);
            
            imwrite(masked, ['datasets/' num2str(id) '/' output_dir '/' images{i} '/' num2str(j) '.jpg']);
        end
    end
    
    %% LBP
    
    input_dir = 'tmp/masked';
    output_dir = 'tmp/lbp';

    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end

    all = cell(size(images, 1), 1);
    
    parfor i = 1:size(images, 1)
        files = dir(['datasets/' num2str(id) '/' input_dir '/' images{i} '/*.jpg']);
        n = size(files, 1);
        
        lbp = zeros(n, 59);
        
        for j = 1:n
            im = imread([files(j).folder '/' files(j).name]);
            
            lbp(j, :) = classification.compute_lbp(im);
        end
        
        all{i} = table(lbp, 'VariableNames', {'LBP'});
    end
    
    props = table();
    
    for i = 1:size(images, 1)
        props = [props; all{i}]; %#ok<AGROW>
    end
    
    m = matfile(['datasets/' num2str(id) '/' output_dir '/lbp.mat']);
    m.props = props;
end
