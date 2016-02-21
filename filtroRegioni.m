function [nuoveRegioni, numregioni] = filtroRegioni(vecchieRegioni)

% Funzione usata per eliminare i layer di movimento troppo piccoli, siccome aumenterebbero solo la complessit�
% computazionale e non fornirebbero nessun beneficio all'analisi. La
% grandezza dei layer di movimento da eliminare viene scelta in modo euristico.

nuoveRegioni = vecchieRegioni;

% Trovare i layer di movimento attualmente presenti
reg = unique(vecchieRegioni);

% Eliminare il layer che contiene i pixel che sono stati scartati
% dall'analisi
reg=reg(2:size(reg,1));

% Se un layer � formato da un numero troppo piccolo di pixel, viene
% eliminato. Il valore � stato posto a 250, poich� euristicamente
% affidabile. Ciclo itera su ogni layer.

for i=1:numel(reg)
    
    % Variabile che contiene il layer di movimento corrente
    conto = vecchieRegioni(vecchieRegioni == reg(i));
    % Numero di pixel contenuti nel layer
    conto = numel(conto);
    % Se il valore � minore di 250, pixel di layer vengono impostati a 0 e
    % assegnati insieme ai pixel scartati dall'analisi
    if (conto <= 250)        
        nuoveRegioni(vecchieRegioni==reg(i)) = 0;        
    end
    
end

% Regioni rimaste vengono riordinate per poter ricalcolarne i parametri
% affini

% Trovare i layer di movimento attualmente presenti
vecchiValori = unique(nuoveRegioni);

% Eliminare il layer che contiene i pixel che sono stati scartati
% dall'analisi
vecchiValori = vecchiValori(2:size(vecchiValori,1));

% Ciclo itera su ogni layer di movimento e assegna come valore
% identificativo del layer il valore della i-esima iterazione
for i=1:numel(vecchiValori)
    
    nuoveRegioni(nuoveRegioni == vecchiValori(i)) = i;
end

% Funzione restituisce anche il numero di layer di movimento trovati
numregioni = numel(vecchiValori);

end