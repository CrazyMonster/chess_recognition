function out = path_for_asset(base_path, filename, type)
    out = join([base_path, filename], "/");
    
    if type ~= "dir"
        out = join([out, type], ".");
    end
    
    % Converti il path in character array, come richiesto da molte funzioni
    % di Matlab.
    out = char(out);
end