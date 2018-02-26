id = 3;
ds = load_dataset(id);

labels = ds.Labels.Image;
configurations = ds.Labels.BoardConfiguration;

% Crea la cartella che conterrà la ground truth.
[~, ~] = mkdir(['datasets/' num2str(id) '/groundtruth']);

parfor i = 1:size(configurations, 1)
    
    FEN = configurations(i);
    
    % Genera un file di testo contenente lo schema raffigurato, con lo
    % stesso nome dell'immgine a cui si riferisce.
    FileID = fopen(['datasets/' num2str(id) '/groundtruth/' labels{i} '.txt'], 'w');
    
    % Scrivi la configurazione FEN (riga di testo) nel file. 
    fprintf(FileID,"%s\n", FEN);
    fclose(FileID);
end
