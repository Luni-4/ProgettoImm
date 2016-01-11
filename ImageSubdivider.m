%Struttura che contiene ogni regione classificata (matrice bidimensionale)
% Riga  indici regione xt 
% Riga  indici regione yt

% Riga= numero della regione
% Colonne= indici per xt(dimensione 1) yt (dimensione 2)
function [regioni, numregioni] = ImageSubdivider(regClass,dimX,dimY)
    regioni=zeros(dimX,dimY); %preallocazione di regione
    for i=1:size(regClass,1)
        regioni(regClass(i,:,1),regClass(i,:,2))=i; % le regioni che identificano i flussi ottici dei frame sono aggiornate
    end
    numregioni=size(regClass,1);
end
