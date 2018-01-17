function extract_edges(id)
    ds = load_dataset(id);
    labels = ds.Labels;
    
    for i = 1:size(labels, 1)
        l = labels(i, :);
        
        in = lib.imread_rotate(['datasets/' num2str(id) '/images/' l.Image{:} '.jpg']);
        
        % Grayscale
        gray = cached_fapply(ds, ["gray", l.Image], "jpg", @rgb2gray, in);
        
        % Downscale
        % La dimensione desiderata lungo l'asse PIU' LUNGO dell'immagine di input.
        n = 2048;
        
        small = cached_fapply(ds, [['gray_' num2str(n)], l.Image], "jpg", @downscale, gray, n);
        
        % Morphological Opening
        se_h = strel('rectangle', [4 8]);
        se_v = strel('rectangle', [8 4]);
        
        opened = cached_fapply(ds, ["opened", l.Image], "jpg", @opening, small, se_h, se_v);
        
        % Smoothing
        sigma = 2.5;
        
        smooth = cached_fapply(ds, ["smooth", l.Image], "jpg", @imgaussfilt, opened, sigma);
        
        % Edge Detection
        edges = cached_fapply(ds, ["edges", l.Image], "png", @edge, smooth, 'Canny');
        
        % Edge Linking
        max_gap = 1;

        linked = cached_fapply(ds, ["edges_linked", l.Image], "png", @lib.filledgegaps, edges, max_gap);
        
        % Edge Filtering
        props = ["Area", "Eccentricity"];
        condition = @(x) [x.Area] > 900 & [x.Eccentricity] < 0.7;
        
        filtered = cached_fapply(ds, ["edges_filtered", l.Image], "png", @edge_filter, linked, props, condition);
        
        % Region Properties
        props = ["Area", "BoundingBox", "Centroid", "ConvexArea", ...
                 "Eccentricity", "EquivDiameter", "EulerNumber", ...
                 "Extent", "Extrema", "FilledArea", "MajorAxisLength",  ...
                 "MinorAxisLength", "Orientation", "Perimeter", "Solidity"];
             
        regions = cached_fapply(ds, ["regionprops", l.Image], "mat", @region_properties, filtered, props);
        
        % Regions
        for j = 1:size(regions.props, 1)
            % Region contours
            region = cached_fapply(ds, ["regions", l.Image, j], "png", @(r, j) r.labels == j, regions, j);
            
            % Region mask
            masked = cached_fapply(ds, ["masked", l.Image, j], "jpg", @convex_mask, small, region);
            
            % LBP
            lbp = cached_fapply(ds, ["lbp", l.Image, j], "mat", @classification.compute_lbp, masked);
        end
    end
end

function out = downscale(in, n)
   [~, idx] = max(size(in));

   if idx == 1
       out = imresize(in, [n NaN]);
   else
       out = imresize(in, [NaN n]);
   end
end

function out = opening(in, se_h, se_v)
    in = im2double(in);
    out = imopen(in, se_h) .* imopen(in, se_v);
end

function out = edge_filter(in, properties, condition)
    cc = bwconncomp(in);
    props = regionprops(cc, properties);

    labels = labelmatrix(cc);

    results = condition(props);
    idx = find(results);
    
    out = ismember(labels, idx);
end

function out = region_properties(in, properties)
    cc = bwconncomp(in);
    props = regionprops('table', cc, properties);
    labels = labelmatrix(cc);
    
    out.cc = cc;
    out.props = props;
    out.labels = labels;
end

function out = convex_mask(im, region)
    im = im2double(im);
    convex = bwconvhull(region);
    
    out = im .* double(convex);
end
