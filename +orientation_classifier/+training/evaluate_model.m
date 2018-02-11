function evaluate_model(model, dataset)
    gt = dataset.OrientationFlags;
    predictions = model.predictFcn(dataset);
    
    cm = confmat(string(gt), string(predictions));
    
    labels = strrep(cm.labels, '*', '_');
    plabels = strcat('P', cellstr(labels));
    tlabels = strcat('T', cellstr(labels));
    
    fprintf('<strong>Accuracy:</strong> %.2f%%\n', cm.accuracy * 100);
    fprintf('\n');
    fprintf('<strong>Confusion Matrix (relative)</strong>\n');
    disp(array2table(cm.cm, 'VariableNames', plabels, 'RowNames', tlabels));
    fprintf('\n');
    fprintf('<strong>Confusion Matrix (absolute)</strong>\n');
    disp(array2table(cm.cm_raw, 'VariableNames', plabels, 'RowNames', tlabels));
    
    images = unique(dataset(:, {'Dataset', 'Image', 'Orientation'}));
    
    for i = 1:height(images)
        image = images(i, :);
        
        [~, idx, ~] = innerjoin(dataset, image);
        g = gt(idx, :);
        p = predictions(idx, :);
        
        errors = strcmp(cellstr(g), cellstr(p));
        
        [orientation, v] = orientation_classifier.count_predited_flags(p);
        
        if image.Orientation == orientation
            ok = 'OK';
        else
            ok = 'ERR';
        end
        
        fprintf('Dataset %d Image %s: T%d => P%d (%.2f votes, %d errors) %s\n', ...
                image.Dataset, image.Image, image.Orientation, orientation, v, sum(~errors), ok);
    end
end
