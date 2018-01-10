id = 1;
ds = load_dataset(id);

labels = ds.Labels;

if ~exist(['datasets/' num2str(id) '/tmp/frame'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/frame']);
end

parfor i = 1:size(labels, 1)
    l = labels(i, :);
    
    im = lib.imread_rotate(['datasets/' num2str(id) '/images/' char(l.Image) '.jpg']);
    fp = reshape(l.FramePoints, 4, 2);
    
    f1 = figure(1);
    
    imshow(im);
    hold on;
    
    plot(fp(1:2, 1), fp(1:2, 2),'LineWidth', 2, 'Color', 'green');
    plot(fp(2:2:4, 1), fp(2:2:4, 2),'LineWidth', 2, 'Color', 'green');
    plot(fp(3:4, 1), fp(3:4, 2),'LineWidth', 2, 'Color', 'green');
    plot(fp(1:2:3, 1), fp(1:2:3, 2),'LineWidth', 2, 'Color', 'green');
    
    for j=1:4
        x = fp(j, 1);
        y = fp(j, 2);
        
        plot(x, y, 'x', 'color', 'red');
    end
    
    hold off;
    
    saveas(f1, ['datasets/' num2str(id) '/tmp/frame/' char(l.Image) '.jpg']);
end
