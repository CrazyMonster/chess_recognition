id = 1;
ds = load_dataset(id);

profile off;
profile on;

for i = 1:height(ds.Labels)
    l = ds.Labels(i, :);
    
    image = imread(['datasets/' num2str(id) '/images/' l.Image{:} '.jpg']);
    fen = recognize_chess_pieces(image, false);
    
    if fen == l.BoardConfiguration
        ok = 'OK';
    else
        ok = 'ERROR';
    end
    
    fprintf('%s - %s %s\n', l.Image, fen, ok);
end

profile viewer;