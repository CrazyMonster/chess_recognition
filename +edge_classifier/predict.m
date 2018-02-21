function out = predict(image)
    persistent classifier;
    
    if isempty(classifier)
        m = load('+edge_classifier/model.mat');
        classifier = m.model;
    end
    
    [f, l] = edge_classifier.extract_edge_features(image);
    
    if height(f) == 0
        error('Nessuna regione trovata.');
    end
    
    c = edge_classifier.compare_edge_regions(f);
    p = classifier.predictFcn(c);
    
    region = edge_classifier.count_comparison_votes(c, p, height(f));
    
    if isnan(region)
        error('Nessuna delle regioni trovate è stata considerata una scacchiera.');
    end
    
    out = (l == region);
end