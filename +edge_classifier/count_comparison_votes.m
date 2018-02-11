function [out, v] = count_comparison_votes(comparisons, votes, region_count)
    a = (votes(:, 1) == '1');
    b = (votes(:, 2) == '1');

    % Assegna +1 punto se Relevance è '1' e -1 punto se Relevance è '0'.
    a = 2 .* a - 1;
    b = 2 .* b - 1;
    
    % Quando una regione viene confrontata con se stessa i punti verrebbero
    % raddoppiati, assegnando +2 o -2 punti. Azzerando uno dei due punteggi
    % si riportano i punti a +1 o -1.
    a(comparisons.Region_A == comparisons.Region_B) = 0;
    
    % Conta i punti assegnati dalle predizioni del classificatore. 
    count = zeros(1, region_count);
    
    for j = 1:height(comparisons)
        c = comparisons(j, :);

        count(c.Region_A) = count(c.Region_A) + a(j);
        count(c.Region_B) = count(c.Region_B) + b(j);
    end

    % Scegli la regione con il massimo punteggio.
    [v, out] = max(count);

    % Nessuna regione è stata considerata rilevante dal classificatore.
    if v <= 0
        out = NaN;
    end
end