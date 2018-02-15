function out = preprocess_image(image, should_downscale, cache, id)
    
    % Di default effettua il downscale.
    if nargin < 2
        should_downscale = true;
    end

    % Disabilita la cache se non viene fornita dal chiamante.
    if nargin < 3
        cache = create_cache(false);
        id = NaN;
    end
    
    if should_downscale
        % Downscale
        % La dimensione desiderata lungo l'asse PIU' LUNGO dell'immagine di input.
        max_size = 2048;
    
        small = cache(["01.small", id], "jpg", @downscale, image, max_size);
        
        % Grayscale
        gray = cache(["02.gray-small", id], "jpg", @rgb2gray, small);
    else
        % Grayscale
        gray = cache(["01.gray", id], "jpg", @rgb2gray, image);
    end
    
    out = gray;
end

function out = downscale(in, max_size)
   [~, idx] = max(size(in));

   if idx == 1
       out = imresize(in, [max_size NaN]);
   else
       out = imresize(in, [NaN max_size]);
   end
end
