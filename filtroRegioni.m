function nuoveRegioni = filtroRegioni(vecchieRegioni)
%Funzione per eliminazione regioni troppo piccole

nuoveRegioni = vecchieRegioni;

    for i=1:numel(unique(vecchieRegioni))
        
        if(sum(vecchieRegioni(vecchieRegioni==i))<=250)
            
            nuoveRegioni(vecchieRegioni==i) = 0;
        
        end
        
    end
end