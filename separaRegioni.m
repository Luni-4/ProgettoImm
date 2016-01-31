function nuoveRegioni = separaRegioni(vecchieRegioni)
%Separa le regioni non adiacenti, e restituisce immagine con nuove label

    sz = size(vecchieRegioni);
    nuoveRegioni = zeros(sz);
    %Contatore regioni
    nRegioni = 1;
    
    
    for i=1:numel(unique(vecchieRegioni))-1
       
        label = bwlabel(vecchieRegioni==i);
        
        for k=1:numel(unique(label))
            
            %Inserisco le regioni separate come nuove regioni
            nuoveRegioni(label==k) = nRegioni;
            %Aumento contatore
            nRegioni = nRegioni+1;
        end
    
    end

end