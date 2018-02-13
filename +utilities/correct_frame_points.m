ids = 1:3;

for id = ids
    ds = load_dataset(id);

    images = ds.Labels.Image;
    points = ds.Labels.FramePoints;
    
    for j = 1:size(images, 1)
        path = ['datasets/' num2str(id) '/images/' images{j} '.jpg'];

        info = imfinfo(path);

        fprintf('%d %s: ', id, images{j});

        if isfield(info, 'Orientation')
            o = info.Orientation;
            
            fprintf('%d', info.Orientation);
        else
            o = 1;
            
            fprintf('/');
        end

        width = info.Width;
        height = info.Height;
        
        fprintf(' %dx%d\n', width, height);
        
        switch o
            case 1
                %normal, leave the data alone
            case 2
                error('Not implemented');                   %right to left
            case 3
                points(j, :, 1) = width - points(j, :, 1);  %180 degree rotation
                points(j, :, 2) = height - points(j, :, 2);
            case 4
                points(j, :, 1) = height - points(j, :, 1); %bottom to top
            case 5
                error('Not implemented');                   %counterclockwise and upside down
            case 6
                tmp = points(j, :, 1);                      %undo 90 degree by rotating 270
                points(j, :, 1) = points(j, :, 2);
                points(j, :, 2) = height - tmp;
            case 7
                error('Not implemented');                   %undo counterclockwise and left/right
            case 8
                tmp = points(j, :, 1);                      %undo 270 rotation by rotating 90
                points(j, :, 1) = width - points(j, :, 2);
                points(j, :, 2) = tmp;           
            otherwise
                warning('unknown orientation %g ignored\n', orient);
        end
    end
    
    save(['datasets/' num2str(id) '/frame_points.mat'], 'points');
end