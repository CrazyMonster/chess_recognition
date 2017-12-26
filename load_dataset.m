function ds = load_dataset(id)
    ds.Path = ["datasets", num2str(id)];
    
    ds.Labels = load_labels(ds);
    ds.Labels.BoardConfiguration = load_board_configurations(ds);
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
    
    % Carica la colonna Image come stringhe.
    opts = setvartype(opts, {'Image'}, 'string');
    
    out = readtable(path, opts);
end

function out = load_puzzles(dataset)
    path = path_for_asset(dataset, "puzzles.csv");
    
    % Specifica che il file puzzles.csv usa ; come delimitatore, altrimenti
    % gli / contenuti nella notazione FEN confondono detectImportOptions.
    opts = detectImportOptions(path, 'Delimiter', ';');
    
    puzzles = readtable(path, opts);
    
    out = containers.Map(puzzles.Puzzle, puzzles.BoardConfiguration);
end

function out = load_board_configurations(dataset)
    puzzle_ids = dataset.Labels.Puzzle;
    puzzles = load_puzzles(dataset);
    
    % Per ogni immagine nel dataset, mappa il numero del puzzle con la 
    % configurazione della scacchiera caricata da load_puzzles(...).
    out = arrayfun(@(id) string(puzzles(id)), puzzle_ids);
end

function out = load_frames(dataset)
   path = path_for_asset(dataset, "frame_points.mat");
   
   if exist(path, 'file')
       fp = load(path);
       out = fp.points;
   end
end