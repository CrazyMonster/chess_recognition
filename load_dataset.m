function ds = load_dataset(id)
    ds.Path = ["datasets", num2str(id)];
    
    labels = load_labels(ds);
    puzzles = load_puzzles(ds);
    
    ds.Labels = join(labels, puzzles);
    
    fp = load_frames(ds);
    
    if ~isempty(fp)
        ds.Labels.FramePoints = fp;
    end
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
    
    % Carica la colonna Image come stringhe.
    opts = setvartype(opts, {'Image'}, 'string');
    
    out = readtable(path, opts);
end

function out = load_puzzles(dataset)
    path = path_for_asset(dataset, "puzzles.csv");
    
    % Specifica che il file puzzles.csv usa ; come delimitatore, altrimenti
    % gli / contenuti nella notazione FEN confondono detectImportOptions.
    opts = detectImportOptions(path, 'Delimiter', ';');
    
    % Carica la colonna BoardConfiguration come stringhe.
    opts = setvartype(opts, {'BoardConfiguration'}, 'string');
    
    out = readtable(path, opts);
end

function out = load_frames(dataset)
   path = path_for_asset(dataset, "frame_points.mat");
   
   if exist(path, 'file')
       fp = load(path);
       out = fp.points;
   else
       out = [];
   end
end