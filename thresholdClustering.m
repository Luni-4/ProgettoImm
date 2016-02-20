function [cc] = thresholdClustering(affini,th)

% Funzione che si occupa del clustering dei parametri affini, individuando
% in maniera automatica il numero di cluster necessari. Nell'algoritmo di
% clustering basato su soglie, il numero di cluster è sconosciuto.
% Tuttavia, due elementi sono assegnati allo stesso cluster se la distanza
% tra di loro è sotto di una determinata soglia specificata th. Questo
% algoritmo viene applicato allo spazio a 6 dimensioni definiti dai set di
% parametri affini, in modo da raggruppare regioni aventi movimenti simili.


% Estrazione dei valori dei parametri affini contenuti all'interno della
% variabile
affini = affini(:,1:6);

% Selezionare un elemento dal set di parametri affini. Questo elemento è
% assegnato come il seed di un cluster a sé stante.
index = ceil(size(affini,1)/2);
seed = affini(index,:);
centri = seed;

% Variabile booleana, che verrà utilizzata alla prima iterazione per
% inizializzare una cella per ogni centro individuato
prima = true;

% Il ciclo while sottostante viene eseguito finché tutti i parametri affini
% non siano stati assegnti ad un centro
while(true)
    
    
    % Calcolo della distanza euclidea di ognuno dei set di parametri
    % affini, rispetto ai centri trovati fino a questo punto. Alla prima
    % iterazione avremo solo un centro, le cui cordinate saranno definite
    % dal valore di seed trovato precedentemente. Per motivi
    % computazionali, la distanza viene calcolata tra due matrici
    % tridimensionali, la prima formata dai set di parametri affini,
    % ripetuti lungo la dimensione z un numero di volte pari al numero di
    % centri trovati, mentre la seconda è formata dai centri trovati
    % finora, elencati lungo l'asse z, e ripetuti lungo la dimensione y un
    % numero di volte pari al numero di set di parametri affini. (immagine
    % della documentazione).
    dist = sqrt(sum((repmat(affini,[1,1,size(centri,3)]) - repmat(centri,[size(affini,1),1,1])).^2,2));
    
    % Ogni set viene assegnato al centro più vicino. La variabile
    % distanzaMin contiene le distanze di ogni set dal centro a loro più
    % vicino, mentre in newRegioni otteniamo una matrice, in cui ad ogni
    % set di parametri affini è stato assegnato al centro più vicino
    [distanzaMin,newRegioni] = min(dist,[],3);
    
    % Variabile booleana utilizzata per controllare quali distanzeMin
    % calcolate precedentemente rispettano la condzione di distanza minima
    % definita da th
    valori_ok = distanzaMin<=th;
    
    % I set che non sono rispettano la condizione precedente, vengono posti
    % a 0, per indicare che non è ancora stato trovato un centro di un
    % cluster sufficientemente vicino.
    newRegioni(not(valori_ok)) = 0;
    
    % Controllo sul numero dell'iterazione. Se è la prima iterazione, viene
    % inizializzata una cella per ogni centro trovato
    if(prima == true)
        
        % Preparazione di una cella per ogni centro; queste celle
        % contengono i valori dei set a loro associati
        n = max(unique(newRegioni));
        elementiCentri = cell(n,1);
        prima = false;
        
    else
        
        % Aggiornamento del numero celle, in modo che corrisponda al numero
        % di centri finora trovati.
        n = max(unique(newRegioni));
        elementiCentri{n,1} = [];
        
    end
    
    % Nel for sottostante, i set di parametri affini vengono assegnati ai
    % centri più vicini trovati precedentemente, che rispettano la
    % condizione indicata da th.
    for i=1:size(newRegioni)
        
        % Le regioni passate da affini con valore compreso nella soglia th
        % vengono assegnate alla cella corrispondente al centro più vicino
        if newRegioni(i,1)>0
            
            elementiCentri{newRegioni(i,1)}(end+1,:) = affini(i,:);
            
            
            % Le regioni con valori NON compresi in soglia sono utilizzati
            % come valori di seed di nuovi centri, che vengono così
            % inizializzati. Alla prima iterazione avremo quindi un numero
            % di centri uguale al numero di set di parametri affini che non
            % sono abbastaza vicini al primo centro inizializzato, più il
            % primo centro inizializzato all'inizio della funzione.
        else
            
            % L'array centri contiene le coordinate dei centri trovati
            % finora
            centri(1,:,end+1) = affini(i,:);
            
            % All'interno di ogni cella elementiCentri sono contenuti i set
            % di parametri affini che sono sufficientemente vicini al
            % centro corrispondente.
            elementiCentri{end+1,1} = affini(i,:);
        end
        
    end
    
    % Controllo sul numero di cluster trovati. Se sono stati individuati
    % più centri, viene effettuato un controllo sulla distanza dei cluster
    % trovati finora. Se la distanza di un nuovo cluster ad un altro
    % cluster è inferiore alla soglia, viene effettuato un merge tra i due
    % cluster vicini, e ricalcolate le distanze tra i cluster.
    if(size(centri,3)>1)
        
        % Distanza tra cluster, rappresentata attraverso matrice
        % triangolare. La funzione permute riordina i centri trovati, in
        % modo che centri diversi siano messi in righe diverse. Viene poi
        % calcolata la distanza tra i vari centri, ceh sono resituiti nella
        % matrice distC.
        distC =  squareform(pdist(permute(centri,[3,2,1])));
        
        % Individuazione cluster troppo vicini. Il controllo viene
        % effettuato sulla matrice distC precedentemente trovata.
        cluster_vicini = distC<=th;
        cluster_vicini = triu(cluster_vicini,1); % Consideriamo solo valori sopra diagonale
        
        % Trovo indici cluster sotto valore soglia, che devono quindi
        % essere uniti
        [cluster1, cluster2] = find(cluster_vicini);
        
        % Controllo se sono stati trovati cluster troppo vicini. Nel caso
        % in cui siano stati trovati, i due cluster vengono uniti in un
        % unico cluster, al cui interno vengono inseriti i set di parametri
        % affini in loro contenuti. Il valore del centro della nuova
        % regione è ottenuto come media degli elementi contenuti nel
        % cluster
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
            
            % Se non esistono centri troppo vicini, e quindi tutti i set
            % sono stati asseganti ad un centro, break
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