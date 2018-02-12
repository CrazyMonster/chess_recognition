function evaluate_model(model, dataset)
    gt = dataset.Labels;
    predictions = model.predictFcn(dataset);
    
    cm = confmat(string(gt), string(predictions));
    
    labels = strrep(cm.labels, '*', '_');
    plabels = strcat('P', cellstr(labels));
    tlabels = strcat('T', cellstr(labels));
    
    fprintf('<strong>Accuracy:</strong> %.2f%%\n', cm.accuracy * 100);
    fprintf('\n');
    fprintf('<strong>Confusion Matrix</strong>\n');
    disp(array2table(cm.cm, 'VariableNames', plabels, 'RowNames', tlabels));
    fprintf('\n');
    fprintf('<strong>Confusion Matrix (raw)</strong>\n');
    disp(array2table(cm.cm_raw, 'VariableNames', plabels, 'RowNames', tlabels));
    fprintf('\n');
    
    % display
    errors = dataset(gt ~= predictions, :);
    errorValues = predictions(gt ~= predictions);
    
    fprintf('<strong>Corretti</strong>: %d\n', height(dataset) - height(errors));
    fprintf('<strong>Errati</strong>: %d\n', height(errors));
    fprintf('\n');
    
    for i = 1:height(errors)
        error = errors(i, :);
        
         fprintf('Dataset %d Image %s Cell [%d %d]: T%s => P%s\n', ...
                error.Dataset, error.Image, error.Cell(1), error.Cell(2), error.Labels, errorValues(i));
        
    end
end
    