function newRegioni = residualError(regioni,distanza,th)

% Funzione che si occupa dell'eliminazione di pixel con errore residuo
% troppo alto

% Tutti i pixel che hanno una distanza maggiore della soglia vengono posti
% a 0
regioni(distanza > th) = 0;
% Funzione restituisce le regioni/layer di movimento modificate
newRegioni = regioni;

end