function [nuoveRegioni, numregioni] = filtroRegioni(vecchieRegioni)
%Funzione per eliminazione regioni troppo piccole

nuoveRegioni = vecchieRegioni;

 % Trovare regioni
 reg = unique(vecchieRegioni);
    
  % Eliminare regione contenente pixel scartati da analisi
  reg=reg(2:size(reg,1));


    for i=1:numel(reg)
        conto = vecchieRegioni(vecchieRegioni == reg(i));
        conto = numel(conto);
        if (conto <= 250)
            
            nuoveRegioni(vecchieRegioni==reg(i)) = 0;
        
        end
        
    end
    
    % Riordino la numerazione delle regioni prima kmeans
    prova = nuoveRegioni;
    vecchiValori = unique(nuoveRegioni);
    vecchiValori = vecchiValori(2:size(vecchiValori,1));
    
    

    for i=1:numel(vecchiValori)

        nuoveRegioni(nuoveRegioni == vecchiValori(i)) = i;
    end
    
    numregioni = numel(vecchiValori);
    
end