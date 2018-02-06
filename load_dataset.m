function ds = load_dataset(id)
    ds.path_for_asset = @(varargin) path_for_asset(["datasets", id], varargin{:});
    
    ds.Id = id;
    
    labels = load_labels(ds);
    puzzles = load_puzzles(ds);
    
    ds.Labels = join(labels, puzzles);
    
    fp = load_frames(ds);
    
    if ~isempty(fp)
        ds.Labels.FramePoints = fp;
    end
end

function out = load_labels(ds)
    path = ds.path_for_asset("labels", "csv");

    opts = detectImportOptions(path);
    
    % Carica la colonna Image come stringhe.
    opts = setvartype(opts, {'Image'}, 'string');
    
    out = readtable(path, opts);
end

function out = load_puzzles(ds)
    path = ds.path_for_asset("puzzles", "csv");
    
    % Specifica che il file puzzles.csv usa ; come delimitatore, altrimenti
    % gli / contenuti nella notazione FEN confondono detectImportOptions.
    opts = detectImportOptions(path, 'Delimiter', ';');
    
    % Carica la colonna BoardConfiguration come stringhe.
    opts = setvartype(opts, {'BoardConfiguration'}, 'string');
    
    out = readtable(path, opts);
end

function out = load_frames(ds)
   path = ds.path_for_asset("frame_points", "mat");
   
   if exist(path, 'file')
       fp = load(path);
       out = fp.points;
   else
       out = [];
   end
end