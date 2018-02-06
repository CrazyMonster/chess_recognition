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
    
    images = unique(dataset(:, {'Dataset', 'Image', 'RegionCount'}));
    rois = unique(dataset(dataset.Relevance(:, 1) == '1', {'Dataset', 'Image', 'Region_A'}));

    images = outerjoin(images, rois, 'Type', 'left', 'MergeKeys', true);
    
    for i = 1:height(images)
        image = images(i, :);
        
        [cmp, idx, ~] = innerjoin(dataset, image(:, {'Dataset', 'Image'}));
        p = predictions(idx,:);
        
        votes = zeros(1, image.RegionCount);
        
        a = (p(:, 1) == '1');
        b = (p(:, 2) == '1');
        
        a = 2 .* a - 1;
        b = 2 .* b - 1;
        
        is_same = (cmp.Region_A == cmp.Region_B);
        a(is_same) = a(is_same) ./ 2;
        b(is_same) = b(is_same) ./ 2;
        
        for j = 1:height(cmp)
            c = cmp(j, :);
            
            votes(c.Region_A) = votes(c.Region_A) + a(j);
            votes(c.Region_B) = votes(c.Region_B) + b(j);
        end
        
        [v, roi] = max(votes);
        
        % Nessuna regione è stata considerata rilevante dal classificatore.
        if v <= 0
            roi = NaN;
        end
        
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
            
        if ~exist(['datasets/' num2str(image.Dataset) '/tmp/11.predicted/'], 'dir')
            mkdir(['datasets/' num2str(image.Dataset) '/tmp/11.predicted/']);
        end
        
        copyfile(['datasets/' num2str(image.Dataset) '/tmp/08.regions/' char(image.Image) '/' num2str(roi) '.png'], ...
                 ['datasets/' num2str(image.Dataset) '/tmp/11.predicted/' char(image.Image) '.png']);
    end
end
