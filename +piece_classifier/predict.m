function out = predict(image)
    persistent classifier;
    
    if isempty(classifier)
        m = load('+piece_classifier/model.mat');
        classifier = m.model;
    end
    
    f = piece_classifier.extract_piece_features(image);
    p = classifier.predictFcn(f);
    
    board = reshape(p, 8, 8);
    
    % Ritorna la configurazione FEN.
    out = serialize_fen(board);
end

