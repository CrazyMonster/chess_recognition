id = 1;
ds = load_dataset(id);

images = ds.Image;
load(['datasets/' num2str(id) '/points.mat']);

for i = 1:size(ds, 1)
    im = imread_rotate(['datasets/' num2str(id) '/images/' images{i} '.jpg']);
    
    f1 = figure(1);
    
    imshow(im);
    hold on;
    
    plot(points(i, 1:2, 1), points(i, 1:2, 2),'LineWidth', 2, 'Color', 'green');
    plot(points(i, 2:2:4, 1), points(i, 2:2:4, 2),'LineWidth', 2, 'Color', 'green');
    plot(points(i, 3:4, 1), points(i, 3:4, 2),'LineWidth', 2, 'Color', 'green');
    plot(points(i, 1:2:3, 1), points(i, 1:2:3, 2),'LineWidth', 2, 'Color', 'green');
    
    for j=1:4
        x = points(i, j, 1);
        y = points(i, j, 2);
        
        plot(x, y, 'x', 'color', 'red');
    end
    
    hold off;
    
    saveas(f1, ['datasets/' num2str(id) '/tmp/bbox/' images{i} '.jpg']);
    
end
