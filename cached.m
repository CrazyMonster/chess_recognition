function L = cached(ds, id, type, fn, varargin)
    output_path = ds.path_for_asset(["tmp", id], type);
    
    if ischar(type) || isstring(type)
        switch type
            case {'jpg', 'png'}
                type = image_type();

             case 'mat'
                type = mat_type();

            otherwise
                error('cached_fapply non è in grado di gestire il tipo richiesto.');
        end
    end
    
    if ~exist(output_path, 'file')
        % Risolvi eventuali argomenti lazy.
        varargin = cellfun(@lazy.unwrap, varargin, 'UniformOutput', false);

        result = fn(varargin{:});

        % Crea la directory di output se necessario, sopprimendo il
        % messaggio di avviso se questa esiste già.
        output_dir = fileparts(output_path);

        [~, ~] = mkdir(output_dir);

        type.save(result, output_path);
    end
        
    function out = execute()
        if exist('result', 'var')
            out = result;
        else
            out = type.load(output_path);
        end
    end

    L = lazy(@execute);
end

function t = image_type()
    t.load = @(path) imread(path);
    t.save = @(out, path) imwrite(out, path);
end

function t = mat_type()
    t.load = @load_mat;
    t.save = @save_mat;
    
    function out = load_mat(path)
        m = matfile(path);
        out = m.data;
    end

    function save_mat(out, path)
        m = matfile(path, 'Writable', true);
        m.data = out;
    end
end