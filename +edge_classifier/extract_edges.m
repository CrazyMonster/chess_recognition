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

    se_h = strel('rectangle', [3 8]);
    se_v = strel('rectangle', [8 3]);

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
    
    %% Region Properties

    input_dir = 'tmp/edges';
    output_dir = 'tmp/regionprops';

    if ~exist(['datasets/' num2str(id) '/' output_dir], 'dir')
        mkdir(['datasets/' num2str(id) '/' output_dir]);
    end

    parfor i = 1:size(images, 1)
        in = imread(['datasets/' num2str(id) '/' input_dir '/' images{i} '.png']);

        cc = bwconncomp(in);
        props = regionprops('table', cc, ["Area", "BoundingBox", "Centroid", "ConvexArea", "Eccentricity", "EquivDiameter", "EulerNumber", "Extent", "Extrema", "FilledArea", "MajorAxisLength", "MinorAxisLength", "Orientation", "Perimeter", "Solidity"]);
        props2 = regionprops('table', cc, "SubarrayIdx");
        
        labels = labelmatrix(cc);

        props.Subregions(:) = NaN;
        
        idx = find([props.Area] > 900 & [props.Eccentricity] < 0.6);
        
        if ~exist(['datasets/' num2str(id) '/' output_dir '/' images{i}], 'dir')
            mkdir(['datasets/' num2str(id) '/' output_dir '/' images{i}]);
        end

        for j = 1:numel(idx)
            out = (labels == idx(j));
            
            imwrite(out, ['datasets/' num2str(id) '/' output_dir '/' images{i} '/' num2str(idx(j)) '.png']);
            
            subidx = props2.SubarrayIdx(idx(j), :);
            s = labels(subidx{:});
            
            subregions = unique(s);
            
            props.Subregions(idx(j)) = numel(subregions);
        end
        
        m = matfile(['datasets/' num2str(id) '/' output_dir '/' images{i} '/' 'props.mat']);
        m.props = props;
    end
end