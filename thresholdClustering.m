function [cc] = thresholdClustering(affini,th)

%Considero solo parametri affini
affini = affini(:,1:6);

% Scelta casuale del seed per definire primo centro
index = randsample(size(affini,1),1);
seed = affini(index,:);
centri = seed;

% Controllo iterazioni
prima = true;


while(true)
    
    % Calcolo distanza rispetto ogni possibile centro
    dist = sqrt(sum((affini(:,:) - repmat(centri,[size(affini,1),1,1])).^2,2));
    
    % Associazione di ogni regione al centro più vicino
    [distanzaMin,newRegioni] = min(dist,[],3);
    
    % Estrazione regioni la cui distanza è minore soglia th
    valori_ok = distanzaMin<=th;
    
    % Azzero regioni che non sono comprese all'interno di th
    newRegioni(not(valori_ok)) = 0;
    
    % Controllo se sono a prima iterazione
    if(prima == true)
        
        % Preparazione di una cella per ogni centro; queste celle
        % contengono i valori delle regioni a loro associati
        n = max(unique(newRegioni));
        elementiCentri = cell(n,1);
        prima = false;
        
    else
        
        %Aggiorna numero celle
        n = max(unique(newRegioni));
        elementiCentri{n,1} = [];
        
    end
    
    % Assegnamento delle regioni passate da affini
    for i=1:size(newRegioni)
        
        % Le regioni passate da affini con valore compreso nella soglia th
        % vengono assegnate ai corrispettivi centri
        if newRegioni(i,1)>0
            
            elementiCentri{newRegioni(i,1)}(end+1,:) = affini(i,:);
            
            
        % Le regioni con valori NON compresi in soglia sono i centri di
        % nuovi cluster
        else
            centri(1,:,end+1) = affini(i,:);
            elementiCentri{end+1,1} = affini(i,:);
        end
        
    end
    
    % Controllo sull'esistenza di più cluster
    if(size(centri,3)>1)
        
        % Distanza tra cluster, rappresentata attraverso
        % matrice triangolare
        distC =  squareform(pdist(permute(centri,[3,2,1])));
        
        % Individuazione cluster troppo vicini
        cluster_vicini = distC<=th;
        cluster_vicini = triu(cluster_vicini,1); % Consideriamo solo valori sopra diagonale
        
        % Trovo indici cluster sotto valore soglia
        [cluster1, cluster2] = find(cluster_vicini);
        
        %Se esistono cluster troppo vicini
        if not(isempty(cluster1))
            
            % Elementi associati al vecchio cluster c2 sono spostati in c1
            elementiCentri{cluster1(1)} = [elementiCentri{cluster1(1)}; elementiCentri{cluster2(1)}];
            
            % Aggiornamento valore cluster c1, come media dei valori
            % contenuti al suo interno
            centri(1,:,cluster1(1)) = mean(elementiCentri{cluster1(1)},1);
            
            % Eliminazione vecchio cluster c2
            centri(:,:,cluster2(1)) = [];
            elementiCentri{cluster2(1)} = [];
            elementiCentri = elementiCentri(~cellfun('isempty',elementiCentri));
            
            % Se non esistono centri troppo vicini, break
        else
            break;
            
        end
        
        % Se esiste solo un cluster, break
    else
        
        break;
    end
    
end


% Centri finali
cc = permute(centri,[3,2,1]);



end