function out = load_dataset(id)
    filename = ['datasets/' num2str(id) '/labels.csv'];
    
    opts = detectImportOptions(filename);
    opts = setvartype(opts, {'Image'}, 'char');
    
    out = readtable(filename, opts);
end