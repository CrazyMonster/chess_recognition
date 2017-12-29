id = 1;
ds = load_dataset(id);

images = ds.Labels.Image;

if ~exist(['datasets/' num2str(id) '/tmp/hough'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/hough']);
end

if ~exist(['datasets/' num2str(id) '/tmp/hough_segments'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/hough_segments']);
end

if ~exist(['datasets/' num2str(id) '/tmp/hough_lines'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/hough_lines']);
end

parfor i = 1:size(images, 1)
    im = imread(['datasets/' num2str(id) '/tmp/edges/' images{i} '.png']);
    
    [H, T, R] = hough(im);
    P = houghpeaks(H, 50, 'Threshold', ceil(0.5*max(H(:))), 'NHoodSize', [5 5]);
    lines = houghlines(im,T,R,P,'FillGap',10,'MinLength',50);
    
    f1 = figure(1);
    imshow(imadjust(rescale(H)),'XData',T,'YData',R, 'InitialMagnification','fit');
    xlabel('\theta'), ylabel('\rho');
    axis on, axis normal, hold on;

    x = T(P(:,2)); y = R(P(:,1));
    plot(x,y,'s','color','red');

    hold off;
    
    saveas(f1, ['datasets/' num2str(id) '/tmp/hough/' images{i} '.jpg']);

    f2 = figure(2);
    imshow(im), hold on;
    max_len = 0;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

       % Plot beginnings and ends of lines
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end
    
    plot(xy_long(:,1), xy_long(:,2), 'LineWidth', 1, 'Color', 'cyan');
    
    hold off;
    
    saveas(f2, ['datasets/' num2str(id) '/tmp/hough_segments/' images{i} '.jpg']);
    
    f3 = figure(3);
    imshow(im);
    xlabel('x'), ylabel('y');
    axis on, axis normal, hold on;
    
    rho = R(P(:,1));
    theta = T(P(:,2));
    
    theta = deg2rad(theta);
    
    for j = 1:numel(rho)
        x = 1:size(im, 2);
        y = (rho(j) - x * cos(theta(j))) / sin(theta(j));
        
        plot(x, y, 'Color', 'red');
    end
    
    hold off;
    
    saveas(f3, ['datasets/' num2str(id) '/tmp/hough_lines/' images{i} '.jpg']);
end
