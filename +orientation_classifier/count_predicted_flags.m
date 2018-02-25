function [out, t] = count_predicted_flags(flags)
    
    % Conta le occorrenze di ogni orientamento.
    o = categorical(cellstr(flags), {'**', '*0', '*1', '00', '01', '10', '11'}, 'Protected', true);
    c = countcats(o);
    
    % Pesa le occorrenze in modo che la loro somma sia 1: 
    % - assegna peso nullo alle celle bianche vuote;
    % - assegna peso pari a 0.125 alle celle nere vuote per i due orientamenti 
    %   che possono assumere;
    % - assegna peso pari a 0.875 alle celle contenenti un pezzo.
    
    w_empty = 0.125;
    w_full = 0.875;
    
    votes = [...
                w_full * c(4) + w_empty * c(2), ...
                w_full * c(5) + w_empty * c(3), ...
                w_full * c(6) + w_empty * c(2), ...
                w_full * c(7) + w_empty * c(3), ...
            ];
    
    [t, out] = max(votes);
end
