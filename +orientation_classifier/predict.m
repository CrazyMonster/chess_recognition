function out = predict(image)
    persistent classifier;
    
    if isempty(classifier)
        m = load('+orientation_classifier/model.mat');
        classifier = m.model;
    end
    
    f = orientation_classifier.extract_orientation_features(image);
    p = classifier.predictFcn(f);
    
    out = orientation_classifier.count_predicted_flags(p);
end

