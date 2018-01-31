id = 3;
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

if ~exist(['datasets/' num2str(id) '/tmp/hough_peaks'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/hough_peaks']);
end

if ~exist(['datasets/' num2str(id) '/tmp/projected'], 'dir')
    mkdir(['datasets/' num2str(id) '/tmp/projected']);
end

parfor i = 1:size(images, 1)
    filename = ['datasets/' num2str(id) '/tmp/12.predicted/' images{i} '.png'];
    
    if ~exist(filename, 'file')
        continue;
    end
    
    im = imread(filename);
    im2 = imread(['datasets/' num2str(id) '/tmp/01.small/' images{i} '.jpg']);
    
    [H, T, R] = hough(im);
    
    threshold = ceil(0.2 * max(H(:)));
    nhood_size = [151 9];
    
    P = houghpeaks(H, 4, 'Threshold', threshold, 'NHoodSize', nhood_size);
    lines = houghlines(im, T, R, P, 'FillGap', 20, 'MinLength', 100);
    
    imwrite(rescale(H), ['datasets/' num2str(id) '/tmp/hough/' images{i} '.1.png']);
    
    f1 = figure(1);
    imshow(imadjust(rescale(H)),'XData',T,'YData',R, 'InitialMagnification','fit');
    xlabel('\theta'), ylabel('\rho');
    axis on, axis normal, hold on;

    x = T(P(:,2)); y = R(P(:,1));
    plot(x,y,'s','Color','red');

    hold off;
    
    saveas(f1, ['datasets/' num2str(id) '/tmp/hough/' images{i} '.3.jpg']);

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
    
    plot_lines(id, [images{i} '.1'], im, im2, T, R, P);
    
    a = zeros(size(H));
    
    for k = 1:size(P, 1)
        a(P(k, 1), P(k, 2)) = 1;
    end
    
    imwrite(a, ['datasets/' num2str(id) '/tmp/hough_peaks/' images{i} '.1.png']);
    
    c = repmat(imadjust(rescale(H)), 1, 1, 3);
    
    neighborhood = ones(nhood_size);
    suppression = imfilter(a, neighborhood);
    
    red    = (a == 1);
    yellow = (a == 0) & (suppression >  0) & (H >= threshold);
    green  = (a == 0) & (suppression >  0) & (H <  threshold);
    blue   = (a == 0) & (suppression == 0) & (H >= threshold);
    white  = (a == 0) & (suppression == 0) & (H <  threshold);
    
    c(:, :, 1) = c(:, :, 1) .* (red   | yellow | white);
    c(:, :, 2) = c(:, :, 2) .* (green | yellow | white);
    c(:, :, 3) = c(:, :, 3) .* (blue  | white);
    
    labels = strcat('Retta #', num2str((1:size(P, 1))'));
    positions = [P(:, 2), P(:, 1), repmat(20, size(P, 1), 1)];
    
    c = insertObjectAnnotation(c, 'circle', positions, cellstr(labels), ...
                               'LineWidth', 3);
    
    imwrite(c, ['datasets/' num2str(id) '/tmp/hough/' images{i} '.2.png']);
    
%     f = ones(40, 1);
%     b_ = imfilter(a, f);
%     b = b_ .* a >= 2;
%     
%     imwrite(rescale(b_), ['datasets/' num2str(id) '/tmp/hough_peaks/' images{i} '.2.png']);
%     imwrite(b, ['datasets/' num2str(id) '/tmp/hough_peaks/' images{i} '.3.png']);
%     
%     [r, c] = find(b);
%     P_ = [r, c];
%     
%     plot_lines(id, [images{i} '.2'], im, T, R, P_);
end

function plot_lines(id, name, im, im2, T, R, P)
    f3 = figure(3);
    imshow(im);
    xlabel('x'), ylabel('y');
    axis on, axis image, axis manual;
    hold on;
    
    rho = R(P(:,1));
    theta = T(P(:,2));
    
    theta = deg2rad(theta);
    
    colors = hsv(size(P, 1));
    
    title(['Rette trovate: ' num2str(numel(rho))]);
    
    for j = 1:numel(rho)
        x1 = 1:size(im, 2);
        y1 = (rho(j) - x1 * cos(theta(j))) / sin(theta(j));
        
        y2 = 1:size(im, 1);
        x2 = (rho(j) - y2 * sin(theta(j))) / cos(theta(j));
        
        x = [x1, x2];
        y = [y1, y2];
        
        plot(x, y, 'LineWidth', 2, 'Color', colors(j, :));
    end
    
    legend(strcat('Retta #', num2str((1:numel(rho))')));
    
    % Intersection points
    n = numel(rho);
    
    lines = repmat(1:n, n, 1);
    l1 = tril(lines, -1);
    l2 = tril(lines', -1);
    
    p1 = P(l1(l1 ~= 0), :);
    p2 = P(l2(l2 ~= 0), :);
    
    r1 = R(p1(:, 1))';
    t1 = deg2rad(T(p1(:, 2)))';
    
    r2 = R(p2(:, 1))';
    t2 = deg2rad(T(p2(:, 2)))';
    
    a = [cos(t1), sin(t1), -r1];
    b = [cos(t2), sin(t2), -r2];
    
    intersections = cross(a, b);
    intersections = intersections(:, 1:2) ./ intersections(:, 3);
    
    in_bounds = intersections(:,1) >= 0 & intersections(:,1) <= size(im, 2) & ...
                intersections(:,2) >= 0 & intersections(:,2) <= size(im, 1);
    intersections = intersections(in_bounds, :);
    
    for j = 1:size(intersections, 1)
        plot(intersections(j,1), intersections(j,2), 'x', 'LineWidth', 2, 'Color', 'yellow');
    end
    
    hold off;
    
    saveas(f3, ['datasets/' num2str(id) '/tmp/hough_lines/' name '.jpg']);
    
    assert(size(intersections, 1) == 4);
    
    convex = convhull(intersections);
    
    movingPoints = intersections(convex(1:4), :);
    fixedPoints = [0 0; 1 0; 1 1; 0 1];
    
    tform = fitgeotrans(movingPoints, fixedPoints, 'projective');
    projected = imwarp(im2, tform, 'OutputView', imref2d([512, 512], [0, 1], [0, 1]));
    
    imwrite(projected, ['datasets/' num2str(id) '/tmp/projected/' name '.jpg']);
end
