id = 1;
ds = load_dataset(id);

labels = ds.Labels;

for i = 1:size(labels, 1)
    l = labels(i, :);
    
    for j = 1:8
        for k = 1:8
            
            im = imread(['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/' num2str(j) 'x' num2str(k) '.jpg']);
            
            if ~exist(['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/1'], 'dir')
                mkdir(['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/1']);
            end
            
            
            if ~exist(['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/2'], 'dir')
                mkdir(['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/2']);
            end
            
             if ~exist(['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/3'], 'dir')
                mkdir(['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/3']);
            end
            
              if ~exist(['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/4'], 'dir')
                mkdir(['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/4']);
              end
              
              if ~exist(['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/5'], 'dir')
                mkdir(['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/5']);
              end
            
            line = strel('line', 3, 135);
            
            %opened = imopen(im, line);
            closed = imclose(im, line);
            %eroded = imerode(im, line);
            dilated = imdilate(im, line);
            
            %bw = imbinarize(opened);
            %label = bwlabel(bw);
            
            
             out1 = lib.sauvola(closed, [15 15]);
             out2 = lib.sauvola(dilated, [15 15]);
            
            %%imwrite(opened,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/1/' num2str(j) 'x' num2str(k) 'opened.jpg']);
            imwrite(closed,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/1/' num2str(j) 'x' num2str(k) 'closed.jpg']);
           % %imwrite(eroded,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/1/' num2str(j) 'x' num2str(k) 'eroded.jpg']);
            imwrite(dilated, ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/1/' num2str(j) 'x' num2str(k) 'dilated.jpg']);
             imwrite(out1,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/1/' num2str(j) 'x' num2str(k) 'out1.jpg']);
          imwrite(out2,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/1/' num2str(j) 'x' num2str(k) 'out2.jpg']);
         
          out3 = lib.sauvola(im, [50 50]);
          out3 = imdilate(out3, line);
          
          
          imwrite(out3,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/1/' num2str(j) 'x' num2str(k) 'out3.jpg']);
         
            
%             sphere = strel('sphere', 2);
%             
%             opened = imopen(im, sphere);
%             closed = imclose(im, sphere);
%             eroded = imerode(im, sphere);
%             dilated = imdilate(im, sphere);
%             
%             imwrite(opened,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/2/' num2str(j) 'x' num2str(k) 'opened.jpg']);
%             imwrite(closed,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/2/' num2str(j) 'x' num2str(k) 'closed.jpg']);
%             imwrite(eroded,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/2/' num2str(j) 'x' num2str(k) 'eroded.jpg']);
%             imwrite(dilated, ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/2/' num2str(j) 'x' num2str(k) 'dilated.jpg']);
             
%             disk = strel('disk', 1);
%             
%             opened = imopen(im, disk);
%             closed = imclose(im, disk);
%             eroded = imerode(im, disk);
%             dilated = imdilate(im, disk);
%             
%             imwrite(opened,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/3/' num2str(j) 'x' num2str(k) 'opened.jpg']);
%             imwrite(closed,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/3/' num2str(j) 'x' num2str(k) 'closed.jpg']);
%             imwrite(eroded,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/3/' num2str(j) 'x' num2str(k) 'eroded.jpg']);
%             imwrite(dilated, ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/3/' num2str(j) 'x' num2str(k) 'dilated.jpg']);
%             
%             sphere = strel('sphere', 2);
%             
%             opened = imopen(255-im, sphere);
%             closed = imclose(255-im, sphere);
%             eroded = imerode(255-im, sphere);
%             dilated = imdilate(255-im, sphere);
%             
%             imwrite(255-opened,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/4/' num2str(j) 'x' num2str(k) 'opened.jpg']);
%             imwrite(255-closed,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/4/' num2str(j) 'x' num2str(k) 'closed.jpg']);
%             imwrite(255-eroded,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/4/' num2str(j) 'x' num2str(k) 'eroded.jpg']);
%             imwrite(255-dilated, ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/4/' num2str(j) 'x' num2str(k) 'dilated.jpg']);
%            


%1

%             sphere = strel('sphere', 2);
% 
%             closed1 = imclose(im, sphere);
%             dilated1 = imdilate(im, sphere);
%             
%             %2
%             disk = strel('disk', 1);
%            
%             closed2 = imclose(im, disk);
%             dilated2 = imdilate(im, disk);
%             
%             
%             line = strel('line', 3, 135);
%             c1 = imclose(closed1, line);
%             d1 = imdilate(dilated1, line);
%             
%             
%              c2 = imclose(closed2, line);
%             d2 = imdilate(dilated2, line);
%             
%             
%             
%             imwrite(c1,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/5/' num2str(j) 'x' num2str(k) 'c1.jpg']);
%             imwrite(d1,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/5/' num2str(j) 'x' num2str(k) 'd1.jpg']);
%             imwrite(c2,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/5/' num2str(j) 'x' num2str(k) 'c2.jpg']);
%             imwrite(d2,  ['datasets/' num2str(id) '/tmp_G/cells/' char(l.Image) '/morphological/5/' num2str(j) 'x' num2str(k) 'd2.jpg']);
         
        
            
        end
    end
end