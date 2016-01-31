function nuoveRegioni = filtroRegioni(vecchieRegioni)
%Funzione per eliminazione regioni troppo piccole

nuoveRegioni = vecchieRegioni;

    for i=1:numel(unique(vecchieRegioni))
        
        if(sum(vecchieRegioni(vecchieRegioni==i))<=250)
            
            nuoveRegioni(vecchieRegioni==i) = 0;
        
        end
        
    end
    
    % Riordino la numerazione delle regioni prima kmeans
    vecchiValori = unique(nuoveRegioni);
    for i=0:(size(vecchiValori,1))-1

        nuoveRegioni(nuoveRegioni == vecchiValori(i+1,1)) = i;
    end
    
end