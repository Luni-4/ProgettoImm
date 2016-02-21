function [cc] = thresholdClustering(affini,th)

% Funzione che si occupa del clustering dei parametri affini, individuando
% in maniera automatica il numero di cluster necessari. Nell'algoritmo di
% clustering basato su soglie, il numero dei cluster è sconosciuto.
% Tuttavia, due elementi sono assegnati allo stesso cluster se la distanza
% tra di loro è inferiore ad una determinata soglia specificata, chiamata th. Questo
% algoritmo viene applicato allo spazio affine, in cui ciascun punto è identificato
% da 6 coordinate. Queste coordinate non sono altro che i parametri affini, che devono essere raggruppati
% in ulteriori parametri affini che li rappresentino. Questi nuovi
% parametri affini, che vengono trovati per mezzo del clustering, corrispondono ai layer di movimento simili presenti
% nella coppia di frame considerata, ma anche ai centri dei cluster considerati.
% Per set di parametri affini si intende l'array composto dai 6 valori, uno per
% ogni regione/layer di movimento.

% Estrazione dei valori dei parametri affini contenuti all'interno della
% variabile affini
affini = affini(:,1:6);

% Selezionare un elemento dal set di parametri affini. Questo elemento sarà
% il seed di un cluster a sé stante.
index = ceil(size(affini,1)/2);
seed = affini(index,:);
centri = seed;

% Variabile booleana, che verrà utilizzata alla prima iterazione per
% inizializzare una cella per ogni centro individuato
prima = true;

% Il ciclo while sottostante viene eseguito finché tutti i parametri affini
% non sono assegnati ad un centro
while(true)
    
    
    % Calcolo della distanza euclidea tra ogni set di parametri
    % affini e i centri trovati fino a questo punto. Alla prima
    % iterazione avremo solo un centro, le cui cordinate saranno definite
    % dal valore di seed trovato precedentemente. Per motivi
    % computazionali, la distanza viene calcolata tra due matrici
    % tridimensionali, la prima formata dai set di parametri affini,
    % ripetuti lungo la dimensione z un numero di volte pari al numero di
    % centri trovati, mentre la seconda è formata dai centri trovati
    % finora, elencati lungo l'asse z, e ripetuti lungo la dimensione y un
    % numero di volte pari al numero dei set di parametri affini. (per chiarire meglio questo passaggio
    % è presente un immagine esplicativa nella documentazione).
    dist = sqrt(sum((repmat(affini,[1,1,size(centri,3)]) - repmat(centri,[size(affini,1),1,1])).^2,2));
    
    % Ogni set viene assegnato al centro più vicino. La variabile
    % distanzaMin contiene le distanze di ogni set dal centro a loro più
    % vicino, mentre in newRegioni è contenuta una matrice, in cui ogni
    % set di parametri affini è stato assegnato al centro più vicino
    [distanzaMin,newRegioni] = min(dist,[],3);
    
    % Variabile booleana utilizzata per controllare quali elementi in
    % distanzaMin, calcolati precedentemente, rispettano la condizione di distanza minima
    % definita da th
    valori_ok = distanzaMin<=th;
    
    % I set che non sono rispettano la condizione precedente, vengono posti
    % a 0, ciò indica che non è ancora stato trovato un centro, di un
    % cluster, sufficientemente vicino.
    newRegioni(not(valori_ok)) = 0;
    
    % Se si è alla prima iterazione del ciclo, viene inizializzata una cella,
    % per ogni centro trovato
    if(prima == true)
        
        % Preparazione di una cella per ogni centro; queste celle
        % contengono i valori dei set a loro associati
        n = max(unique(newRegioni));
        elementiCentri = cell(n,1);
        prima = false;
        
    else
        
        % Aggiornamento del numero celle, in modo che corrispondano al numero
        % di centri finora trovati.
        n = max(unique(newRegioni));
        elementiCentri{n,1} = [];
        
    end
    
    % Nel for sottostante, i set di parametri affini vengono assegnati ai
    % centri più vicini, trovati precedentemente, che rispettano la
    % condizione indicata da th.
    for i=1:size(newRegioni)
        
        % Le regioni\layer di movimento passati da affini, con valore
        % inferiore o uguale a th, vengono assegnati ad una cella. Questa
        % cella corrisponde al centro più vicino.
        if newRegioni(i,1)>0
            
            elementiCentri{newRegioni(i,1)}(end+1,:) = affini(i,:);
            
            
            % Le regioni con valori superiori alla soglia sono utilizzati
            % come valori di seed per creare nuovi centri, che vengono così
            % inizializzati. La quantità di centri presenti alla prima iterazione
            % è pari alla somma tra il numero di set dei parametri affini
            % non sufficientemente vicini al primo centro inizializzato e
            % il primo centro inizializzato stesso.
        else
            
            % L'array centri contiene le coordinate dei centri trovati
            % finora
            centri(1,:,end+1) = affini(i,:);
            
            % All'interno di ogni cella dell'array di celle elementiCentri sono contenuti i set
            % di parametri affini che sono sufficientemente vicini al
            % centro corrispondente.
            elementiCentri{end+1,1} = affini(i,:);
        end
        
    end
    
    % Viene effettuato un controllo sul numero dei cluster trovati. Se sono stati individuati
    % più centri, viene effettuato un controllo sulla distanza tra i cluster
    % trovati finora. Se la distanza di un cluster ad un altro
    % è inferiore alla soglia, viene effettuato un merge tra i due
    % cluster vicini, e ricalcolate le distanze del nuovo cluster rispetto a tutti gli altri.
    if(size(centri,3)>1)
        
        % Distanza tra cluster, rappresentata attraverso una matrice
        % triangolare. La funzione permute riordina i centri trovati, in
        % modo che centri diversi siano messi in righe diverse. Viene poi
        % calcolata la distanza tra i vari centri, che sono resituiti nella
        % matrice distC.
        distC =  squareform(pdist(permute(centri,[3,2,1])));
        
        % Individuazione dei cluster troppo vicini. Il controllo viene
        % effettuato sulla matrice distC precedentemente trovata.
        cluster_vicini = distC<=th;
        cluster_vicini = triu(cluster_vicini,1); % Si considerano solo i valori sopra alla diagonale
        
        % Individuazione dei cluster inferiori alla soglia, devono essere
        % uniti
        [cluster1, cluster2] = find(cluster_vicini);
        
        % Se sono stati trovati cluster troppo vicini, i due cluster vengono uniti in un
        % unico cluster, contenente i set di parametri
        % affini di ciascuno di essi. Il centro del nuovo cluster
        % è ottenuto come media degli elementi.
        if not(isempty(cluster1))
            
            % Elementi associati al cluster c2 sono spostati all'interno del cluster c1
            elementiCentri{cluster1(1)} = [elementiCentri{cluster1(1)}; elementiCentri{cluster2(1)}];
            
            % Aggiornamento centro del cluster c1, eseguendo media dei valori
            % contenuti al suo interno
            centri(1,:,cluster1(1)) = mean(elementiCentri{cluster1(1)},1);
            
            % Eliminazione del cluster c2
            centri(:,:,cluster2(1)) = [];
            elementiCentri{cluster2(1)} = [];
            elementiCentri = elementiCentri(~cellfun('isempty',elementiCentri));
            
            % Se non esistono centri troppo vicini, e quindi tutti i set
            % dei parametri affini sono stati asseganti ad un centro, il ciclo viene interrotto
        else
            break;
            
        end
        
        % Se esiste solo un cluster, tutti i set di parametri affini sono a
        % lui assegnati, break
    else
        
        break;
    end
    
end


% La funzione restituisce tutti i centri trovati, ognuno mostrato su righe
% diverse.
cc = permute(centri,[3,2,1]);



end