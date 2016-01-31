function nuoveRegioni = filtroRegioni(vecchieRegioni)
%Funzione per eliminazione regioni troppo piccole

nuoveRegioni = vecchieRegioni;

 % Trovare regioni
 reg = unique(vecchieRegioni);
    
  % Eliminare regione contenente pixel scartati da analisi
  reg=reg(2:size(reg,1));


    for i=1:numel(reg)
        conto = vecchieRegioni(vecchieRegioni==i);
        if (sum(conto)<=250)
            
            nuoveRegioni(vecchieRegioni==i) = 0;
        
        end
        
    end
    
    % Riordino la numerazione delle regioni prima kmeans
    vecchiValori = unique(nuoveRegioni);
    for i=0:(size(vecchiValori,1))-1

        nuoveRegioni(nuoveRegioni == vecchiValori(i+1,1)) = i;
    end
    
end