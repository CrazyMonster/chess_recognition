function predict_test(model, dataset)
    gt = dataset.Labels;
    predictions = model.predictFcn(dataset);
    
    cm = confmat(string(gt), string(predictions));
    
    plabels = strcat('P', cellstr(cm.labels));
    tlabels = strcat('T', cellstr(cm.labels));
    
    fprintf('<strong>Accuracy:</strong> %.2f%%\n', cm.accuracy * 100);
    fprintf('\n');
    fprintf('<strong>Confusion Matrix</strong>\n');
    disp(array2table(cm.cm, 'VariableNames', plabels, 'RowNames', tlabels));
    fprintf('\n');
    fprintf('<strong>Confusion Matrix (raw)</strong>\n');
    disp(array2table(cm.cm_raw, 'VariableNames', plabels, 'RowNames', tlabels));
    
%     images = unique(dataset(dataset.IsROI_A == 1, {'Dataset', 'Image', 'Region_A'}));
    
%     for i = 1:size(images, 1)
%         image = images(i, :);
%         
%         [comparisons, idx, ~] = innerjoin(dataset, image(:, {'Dataset', 'Image'}));
%         p = predictions(idx,:);
%         
%         regions = unique(comparisons(:, {'Region_A'}));
%         votes = zeros(1, size(regions, 1));
%         
%         for j = 1:size(comparisons, 1)
%             c = comparisons(j, :);
%             
%             a = str2double(p(1));
%             b = str2double(p(2));
%             
%             votes(c.Region_A) = votes(c.Region_A) + a - (b - a);
%             votes(c.Region_B) = votes(c.Region_B) + b - (a - b);
%         end
%         
%         [v, roi] = max(votes);
%         
%         if image.Region_A == roi
%             ok = 'OK';
%         else
%             ok = 'ERR';
%         end
%             
%         fprintf('Dataset %d Image %s: %d => %d (%d) %s\n', image.Dataset, image.Image, image.Region_A, roi, v, ok);
%     end
end
    