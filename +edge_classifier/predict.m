function out = predict(image)
    persistent classifier;
    
    if isempty(classifier)
        m = load('+edge_classifier/model.compact.mat');
        classifier = m.model;
    end
    
    f = edge_classifier.extract_edge_features(image);
    c = edge_classifier.compare_edge_regions(f);
    
    p = classifier.predictFcn(c);
    
    out = edge_classifier.count_comparison_votes(c, p, height(f));
end