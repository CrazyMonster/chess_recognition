function evaluate_model(model, dataset)
    gt = dataset.Relevance;
    predictions = model.predictFcn(dataset);
    
    cm = confmat(string(gt), string(predictions));
    
    plabels = strcat('P', cellstr(cm.labels));
    tlabels = strcat('T', cellstr(cm.labels));
    
    fprintf('<strong>Accuracy:</strong> %.2f%%\n', cm.accuracy * 100);
    fprintf('\n');
    fprintf('<strong>Confusion Matrix (relative)</strong>\n');
    disp(array2table(cm.cm, 'VariableNames', plabels, 'RowNames', tlabels));
    fprintf('\n');
    fprintf('<strong>Confusion Matrix (absolute)</strong>\n');
    disp(array2table(cm.cm_raw, 'VariableNames', plabels, 'RowNames', tlabels));
    fprintf('\n');
    
    images = unique(dataset(:, {'Dataset', 'Image', 'RegionCount'}));
    rois = unique(dataset(dataset.Relevance(:, 1) == '1', {'Dataset', 'Image', 'Region_A'}));

    images = outerjoin(images, rois, 'Type', 'left', 'MergeKeys', true);
    
    for i = 1:height(images)
        image = images(i, :);
        
        [cmp, idx, ~] = innerjoin(dataset, image(:, {'Dataset', 'Image'}));
        p = predictions(idx,:);
        
        [roi, v] = edge_classifier.count_comparison_votes(cmp, p, image.RegionCount);
        
        if image.Region_A == roi || all(isnan([image.Region_A, roi]))
            ok = 'OK';
        else
            ok = 'ERR';
        end
        
        fprintf('Dataset %d Image %s: T%d => P%d (%d votes, %d regions) %s\n', ...
                image.Dataset, image.Image, image.Region_A, roi, v, image.RegionCount, ok);
        
        if isnan(roi)
           continue; 
        end
            
        if ~exist(['datasets/' num2str(image.Dataset) '/tmp/predicted/'], 'dir')
            mkdir(['datasets/' num2str(image.Dataset) '/tmp/predicted/']);
        end
        
        copyfile(['datasets/' num2str(image.Dataset) '/tmp/edge_classifier/08.regions/' char(image.Image) '/' num2str(roi) '.png'], ...
                 ['datasets/' num2str(image.Dataset) '/tmp/predicted/' char(image.Image) '.png']);
    end
end
