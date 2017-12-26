function ds = load_dataset(id)
    ds.Path = ["datasets", num2str(id)];
    
    ds.Labels = load_labels(ds);
    ds.Labels.FramePoints = load_frames(ds);
end

function out = path_for_asset(dataset, filename)
    out = join([dataset.Path, filename], "/");
    
    % Converti il path in character array, come richiesto da molte funzioni
    % di Matlab.
    out = char(out);
end

function out = load_labels(dataset)
    path = path_for_asset(dataset, "labels.csv");

    opts = detectImportOptions(path);
    
    % Carica la colonna Image come character array.
    opts = setvartype(opts, {'Image'}, 'string');
    
    out = readtable(path, opts);
end

function out = load_frames(dataset)
   path = path_for_asset(dataset, "frame_points.mat");
   
   if exist(path, 'file')
       fp = load(path);
       out = fp.points;
   end
end