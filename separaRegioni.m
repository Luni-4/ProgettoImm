function nuoveRegioni = separaRegioni(vecchieRegioni)
%Separa le regioni non adiacenti, e restituisce immagine con nuove label

    nuoveRegioni = vecchieRegioni;
    %Contatore regioni
    nRegioni = numel(unique(vecchieRegioni));
    
    
    for i=1:numel(unique(vecchieRegioni))
       
        label = bwlabel(vecchieRegioni==i);
        
        for k=1:numel(unique(label))
            
            %Inserisco le regioni separate come nuove regioni
            nuoveRegioni(label==k) = nRegioni;
            %Aumento contatore
            nRegioni = nRegioni+1;
        end
    
    end

end