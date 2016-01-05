function  kmean_adattivo_test(u,v)
%% Tentantivo di kmeans sui parametri affini

tic
p1 = zeros(size(u,1), size(u,2));
p2 = zeros(size(u,1), size(u,2));


%% Calcolo la retta passante per due punti, dove ogni punto è dato dalla
% velocità e dalla posizione (DA VETTORIZZARE)

for i=1:size(u,1)
    
    for k=1:size(v,2)
        
        % Calcolo la m della mia retta, che chiamo p1 come nelle slide
        % Calcolo la q della mia retta, che chiamo p2 come nelle slide
        p1(i,k) = u(i,k) - i;
        p2(i,k) = v(i,k) - k;
        
        
    end
    
    
end

%% Applico il kmeans adattivo ai valori che ho trovato

% Contatore numero cluster
num_clust = 0;

% Contatore numero massimo iterazioni
num_iterazioni=0; 


% Vettorializzo (DA SOSTITUIRE IN FINALE)
p1_v = p1(:);
p2_v = p2(:);


while(true)
    
    % Calcolo il seed
    seed = [mean(p1_v);mean(p2_v)];
    
    %Ad ogni iterazione, aggiungo un nuovo cluster
    num_clust = num_clust+1; 
    
    % Aggiungo un contatore
    
    while(true)
        
        % Incremento contatore numero di iterazioni
        num_iterazioni = num_iterazioni+1;
        
        
            
            % Calcolo distanza euclidea tra punto seed e valori pixel immagine
            % ldg
            dist = sqrt((p1_v-seed(1,1)).^2 + (p2_v-seed(2,1)).^2);
            
            % Calcolo ampiezza di banda
            dist_bw = sqrt( (sum((p1_v-seed(1,1)).^2 + (p2_v-seed(2,1)).^2)/numel(p1_v)) );
            
            % Controllo che i valori siano nell'ampiezza di banda di interesse
            valori_ok = dist<dist_bw;
            
             % Aggiorno la media
             seed_aggiornato = [mean(p1_v(valori_ok)); mean(p2_v(valori_ok))];
             
             % Controllo che il valore sia un numero
             if isnan(seed_aggiornato)
                break;
             end
            
             
             % Controllo se sono a convergenza, oppure se ho raggiunto numero
        % massimo iterazioni
        if isequal(seed,seed_aggiornato) || num_iterazioni>10 
            
            % Azzero contatore
            num_iterazioni=0;
            
            % Rimuovo tutti i valori che sono stati assegnati al cluster
            p1_v(valori_ok) = [];
            p2_v(valori_ok) = [];
            
            % Salvo il valore del centro del cluster trovato
            centri_cluster(num_clust,1) = seed_aggiornato(1,1); 
            centri_cluster(num_clust,2) = seed_aggiornato(2,1); 
            
            %Esco dal ciclo
            break;
            
        end
        
        
        %Aggiorno il valore del seed per la prossima iterazione
        seed = seed_aggiornato;
        
        
        
        
        
    end
    
    
       % Controllo se tutti i punti sono stati assegnati, oppure se ho
    % raggiunto numero massimo di cluster
    if isempty(p1_v) || size(centri_cluster,1)>9
       break;
    end
    
end




%
%% Ho il numero dei cluster, posso applicare il classico kmeans
%

% Elimino i centri troppo vicini tra loro (<=.75)

% Inizializzo il vettore per usarlo dopo
dist_no_ok(1,2) = -1 ;

% Calcolo distanza tra i vari centri
for i=1:(size(centri_cluster,1)-1);
   
     dist_centri= sqrt((centri_cluster(i,1)-centri_cluster(i+1,1)).^2 + (centri_cluster(i,2)-centri_cluster(i+1,2)).^2);
        
    %Salvo quali centri sono troppo vicini
     if dist_centri <= 0.75
        dist_no_ok(1,i) = i+1; 
     end
     
end

%Elimino centri troppo vicini
if dist_no_ok(1,2) ~= -1
    centri_cluster(dist_no_ok,:) = [];
end

%% Ottengo un'immagine clusterizzata

% Vettorizzo l'immagine per calcolare efficentemente, e ripeto l'immagine
% vettorizzata n volte, dove n è il numero dei cluster trovati
p1_ripetuta = repmat(p1(:),[1,size(centri_cluster,1)]);
p2_ripetuta = repmat(p2(:),[1,size(centri_cluster,1)]);

% Faccio lo stesso per il centro dei cluster
centri_x = centri_cluster(:,1);
centri_y = centri_cluster(:,2);
centri_ripetuti_x = (repmat(centri_x,[1,numel(p1(:))]))';
centri_ripetuti_y = (repmat(centri_y,[1,numel(p1(:))]))';

%Calcolo distanza di ogni punto rispetto centro cluster
distanza_x = ((p1_ripetuta-centri_ripetuti_x).^2);
distanza_y= ((p2_ripetuta-centri_ripetuti_y).^2);
distanza= sqrt(distanza_x+distanza_y);

% Assegno ogni punto al cluster più vicino
[~,cluster_assegnamento] = min(distanza,[],2);

% Ricostruisco l'immagine, sostituendo ad ogni pixel il numero del cluster di cui fa parte 
aff_param_clusterizzati = reshape(cluster_assegnamento,size(p1));

toc;

%% Mostra i cluster in cui è divisa l'immagine, da togliere in versione finale

figure(1);
imshow(aff_param_clusterizzati,[]);
title('cluster su spazio parametri affini');

figure(2);
subplot( ceil((size(centri_cluster,1))/2), ceil((size(centri_cluster,1))/2), 1);
imshow(aff_param_clusterizzati,[]);
title('Spazio p.a. clusterizzato.')

for i =1:(size(centri_cluster,1))
        
            subplot( ceil((size(centri_cluster,1))/2), ceil((size(centri_cluster,1))/2), i);
            imshow(aff_param_clusterizzati == i,[]);
            title(['Cluster numero ' num2str(i) '.']);
             
end

end