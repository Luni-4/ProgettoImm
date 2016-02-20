function newRegioni = residualError(regioni,distanza,th)

% Funzione che si occupa dell'eliminazione di pixel con errore residuo
% troppo alto

regioni(distanza > th) = 0;
newRegioni = regioni;

end