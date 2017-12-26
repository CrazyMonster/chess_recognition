% Walter Roberson
% December 2015
% Source: https://it.mathworks.com/matlabcentral/answers/260607-how-to-load-a-jpg-properly#answer_203481

function im = imread_rotate(filename)
    im = imread(filename);
    info = imfinfo(filename);

    if isfield(info,'Orientation')
       orient = info(1).Orientation;
       
       switch orient
         case 1
            %normal, leave the data alone
         case 2
            im = im(:,end:-1:1,:);         %right to left
         case 3
            im = im(end:-1:1,end:-1:1,:);  %180 degree rotation
         case 4
            im = im(end:-1:1,:,:);         %bottom to top
         case 5
            im = permute(im, [2 1 3]);     %counterclockwise and upside down
         case 6
            im = rot90(im,3);              %undo 90 degree by rotating 270
         case 7
            im = rot90(im(end:-1:1,:,:));  %undo counterclockwise and left/right
         case 8
            im = rot90(im);                %undo 270 rotation by rotating 90
         otherwise
            warning('unknown orientation %g ignored\n', orient);
       end
    end
end