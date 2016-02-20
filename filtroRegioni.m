function [nuoveRegioni, numregioni] = filtroRegioni(vecchieRegioni)

% Funzione per eliminazione regioni troppo piccole, formate da un numero di
% pixel minore di un valore definito euristicamente.

nuoveRegioni = vecchieRegioni;

% Trovare regioni
reg = unique(vecchieRegioni);

% Eliminare regione contenente pixel scartati da analisi
reg=reg(2:size(reg,1));

% Se un layer è formato da un numero troppo piccolo di pixel, viene
% eliminato. Il valore è stato posto a 250, poiché euristicamente
% affidabile.
for i=1:numel(reg)
    conto = vecchieRegioni(vecchieRegioni == reg(i));
    conto = numel(conto);
    if (conto <= 250)
        
        nuoveRegioni(vecchieRegioni==reg(i)) = 0;
        
    end
    
end

% Riordinamento della numerazione delle regioni
vecchiValori = unique(nuoveRegioni);
vecchiValori = vecchiValori(2:size(vecchiValori,1));

for i=1:numel(vecchiValori)
    
    nuoveRegioni(nuoveRegioni == vecchiValori(i)) = i;
end

numregioni = numel(vecchiValori);

end