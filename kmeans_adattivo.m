function [img_clusterizzata,centri_cluster] = kmeans_adattivo(img)

%% Immagine test, da togliere in versione finale
if nargin == 0
    img = imread('images/cars1_01.jpg');
    img = rgb2gray(img);
end


%%

img = double(img);

% Vettorizzo l'array per velocizzare
img_v = img(:);

% Contatore numero cluster
num_clust = 0;

% Contatore numero massimo iterazioni
num_iterazioni=0; 

%% Trovo il numero di cluster

while(true)
   
    %Scelgo il punto di seed
    seed = mean(img_v); 
    
    %Ad ogni iterazione, aggiungo un nuovo cluster
    num_clust = num_clust+1; 
    
    while(true)
        
        % Incremento contatore numero di iterazioni
        num_iterazioni = num_iterazioni+1;
        
        
        % Calcolo distanza euclidea tra punto seed e valori pixel immagine
        % ldg
        dist = (sqrt((img_v-seed).^2)); 
       
        % Calcolo il valore dell'ampiezza di banda di interesse
        dist_bw = (sqrt(sum((img_v-seed).^2)/numel(img_v)));
    
        % Controllo che i valori siano nell'ampiezza di banda di interesse
        valori_ok = dist<dist_bw;
        
        % Aggiorno la media
        seed_aggiornato = mean(img_v(valori_ok));
        
        % Controllo che il valore sia un numero
        if isnan(seed_aggiornato)
            break;
        end
        
        % Controllo se sono a convergenza, oppure se ho raggiunto numero
        % massimo iterazioni
        if seed == seed_aggiornato || num_iterazioni>10 
            
            % Azzero contatore
            num_iterazioni=0;
            
            % Rimuovo tutti i valori che sono stati assegnati al cluster
            img_v(valori_ok) = [];
            
            % Salvo il valore del centro del cluster trovato
            centri_cluster(num_clust) = seed_aggiornato; 
            
            %Esco dal ciclo
            break;
            
        end
        
        %Aggiorno il valore del seed per la prossima iterazione
        seed = seed_aggiornato;
        
    end
    
    
    % Controllo se tutti i punti sono stati assegnati, oppure se ho
    % raggiunto numero massimo di cluster
    if isempty(img_v) || num_clust>10 
       break;
    end
    
end


%% Ho il numero dei cluster, posso applicare il classico kmeans

% Ordino il vettore dei centri
centri_cluster = sort(centri_cluster); 

% Trovo differenza tra centri vicini
centri_diff = diff(centri_cluster);

% Trovo valore distanza minima tra due centri
dist_min = (max(img(:)/10));

% Scarto i centri troppo vicini tra loro
centri_cluster(centri_diff<=dist_min)=[];


%% Ottengo un'immagine clusterizzata

% Vettorizzo l'immagine per calcolare efficentemente, e ripeto l'immagine
% vettorizzata n volte, dove n è il numero dei cluster trovati
img_ripetuta = repmat(img(:),[1,numel(centri_cluster)]);

% Faccio lo stesso per il centro dei cluster
centri_ripetuti = repmat(centri_cluster,[numel(img),1]);

%Calcolo distanza di ogni punto rispetto centro cluster
distanza = ((img_ripetuta-centri_ripetuti).^2);

% Assegno ogni punto al cluster più vicino
[~,cluster_assegnamento] = min(distanza,[],2);

% Ricostruisco l'immagine, sostituendo ad ogni pixel il numero del cluster di cui fa parte 
img_clusterizzata = reshape(cluster_assegnamento,size(img));

%% Mostra i cluster in cui è divisa l'immagine, da togliere in versione finale

subplot( ceil((numel(centri_cluster))/2), ceil((numel(centri_cluster)/2)), 1);
imshow(img,[]);
title('Immagine di partenza.')

for i =2:(numel(centri_cluster))
        
            subplot( ceil((numel(centri_cluster))/2), ceil((numel(centri_cluster)/2)), i);
            imshow(img_clusterizzata == i,[]);
            title(['Cluster numero ' num2str(i-1) '.']);
             
end
