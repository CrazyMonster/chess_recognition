r = edge_classifier.load_roi_labels(1);

parfor j=1:height(r)
    region = r(j, :);
    
    path = ['datasets/' num2str(region.Dataset) '/tmp/08.regions/' char(region.Image) '/' num2str(region.Region) '.png'];
    
    [~, ~] = mkdir(['datasets/' num2str(region.Dataset) '/tmp/frames/' char(region.Image)]);
    
    if region.IsROI
        roi = '+';
    else
        roi = '';
    end
    
    if ~exist(path, 'file')
        fprintf('La regione DS:%d IM:%s R:%d %c non esiste più.\n', region.Dataset, region.Image, region.Region, roi);
        continue
    end
    
    out = ['datasets/' num2str(region.Dataset) '/tmp/frames/' char(region.Image) '/' roi num2str(region.Region) '.png'];
    
    copyfile(path, out);
end
