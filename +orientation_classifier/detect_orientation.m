id = 3;
ds = load_dataset(id);

firstPoint = squeeze(ds.Labels.FramePoints(:, 1, :));

images = ds.Labels.Image;

orientation = NaN(height(ds.Labels), 1);

for i = 1:height(ds.Labels)
    
    % informazioni riguardo le dimenensioni dell'immagne originale
    info = imfinfo(['datasets/' num2str(id) '/images/' images{i} '.jpg']);
    
    oldWidth = info.Width;
    oldHeight = info.Height;
    
    [~, idx] = max([oldWidth, oldHeight]);
    
    if idx == 1 
        newWidth = 2048;
        newHeight = (newWidth * oldHeight) / oldWidth;
    else 
        newHeight  = 2048;
        newWidth = (newHeight * oldWidth) / oldHeight;
    end 
        
    % scalo le dimesioni del punto orgininale
    scaledOP = firstPoint(i, :) .* [newWidth, newHeight] ./ [oldWidth, oldHeight];
    
    % trovo il punto iniziale dell'immagine ritagliata per effetture la rotazione
    path = ['datasets/' num2str(id) '/tmp/points/' images{i} '.mat'];
   
    if ~exist(path, 'file')
        continue;
    end 
    
    p = load(path);
   
    d = sqrt(sum((p.movingPoints - scaledOP).^2, 2)); 
    
    [~, idx] = min(d);
    
    orientation(i) = idx;
end 

P3 = table;
P3.orientation = orientation(~isnan(orientation));
