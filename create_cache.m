function C = create_cache(base_path)
    
    % Fornisci una sintassi semplice per disattivare la cache.
    if base_path ~= false
        C = @cache;
    else
        C = @nocache;
    end

    function L = cache(id, type, fn, varargin)
        output_path = path_for_asset(base_path, id, type);
        
        % Supporta varie strategie per la memorizzazione del risultato su
        % disco.
        if ischar(type) || isstring(type)
            switch type
                case 'jpg'
                    type_handler = image_type({}, {'Quality', 85});
                    
                case 'png'
                    type_handler = image_type();

                 case 'mat'
                    type_handler = mat_type();

                otherwise
                    error('cached non è in grado di gestire il tipo richiesto.');
            end
        else
            type_handler = type;
        end

        % Se la funzione non è ancora stata eseguita.
        if ~exist(output_path, 'file')
            from_cache = false;
            
            % Esegui la funzione.
            result = execute(fn, varargin{:});
            
            % Crea la directory di output se necessario, sopprimendo il
            % messaggio di avviso se questa esiste già.
            output_dir = fileparts(output_path);

            [~, ~] = mkdir(output_dir);

            % Salva il risultato su disco.
            type_handler.save(result, output_path);
        else
            from_cache = true;
        end

        function out = resolve()
            if from_cache
                out = type_handler.load(output_path);
            else
                out = result;
            end
        end

        % Utilizza lazy per caricare da disco solo i risultati
        % effettivamente richiesti.
        L = lazy(@resolve);
    end

    function out = nocache(~, ~, fn, varargin)
        % Esegui direttamente la funzione.
        out = execute(fn, varargin{:});
    end

    function out = execute(fn, varargin)
        % Risolvi eventuali argomenti lazy.
        varargin = lazy.gather(varargin);

        out = fn(varargin{:});
    end
end
    
function t = image_type(readopts, writeopts)
    if nargin < 2
        readopts = {};
        writeopts = {};
    end

    t.load = @(path) imread(path, readopts{:});
    t.save = @(out, path) imwrite(out, path, writeopts{:});
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