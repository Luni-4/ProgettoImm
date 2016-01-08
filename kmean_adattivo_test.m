function [aff_param_clusterizzati] = kmean_adattivo_test(affineRegX,affineRegY)
%% Tentantivo di kmeans sui parametri affini

% Controlliamo il tempo di esecuzione
tic

% Creo le celle dove salvo p1 e p2, ossia le m e le q delle rette passanti
% per due punti
p1 = cell(size(affineRegX,1), 1);
p2 = cell(size(affineRegX,1), 1);


%% Calcolo le rette passanti per i due punti affineRegX e affineRegY, 
% nello spazio dei parametri

i=1;
while(i<=size(affineRegX,1))

    
        % Calcolo la m della mia retta, che chiamo p1 come nelle slide
        % Calcolo la q della mia retta, che chiamo p2 come nelle slide
        p1{i,1} = [affineRegY{i,1}] - [affineRegX{i,1}];
        p2{i,1} = [affineRegX{i,1}];
        
        i=i+1;
        
    
end

% Creo una copia per usare durante assegnamento dei parametri affini ai
% centri; visto che le celle sono tutte uguali, salvo in matrice
% tridimensionale
p1_c = zeros(size(p1,1),1,3);
p2_c = zeros(size(p2,1),1,3);

i=1;
while i<=size(p1,1)
   
    p1_c(i,1,:) = p1{i,1};
    p1_c(i,1,:) = p1{i,1};
    
    i=i+1;
    
end

%% Applico il kmeans adattivo ai valori che ho trovato

% Contatore numero cluster
num_clust = 0;

% Contatore numero massimo iterazioni
num_iterazioni=0; 


while(true)
    
    % Calcolo il seed del primo dentro, ossia l'equazione della retta con
    % cui vorrei approssimare le rette trovate precedentemente
    
    media_p1 = zeros(3,1);
    media_p2 = zeros(3,1);
    
    i=1;
    while(i<=size(p1,1))
        
        media_p1(1,1) = media_p1(1,1) + p1{i,1}(1,1);
        media_p1(2,1) = media_p1(2,1) + p1{i,1}(2,1);
        media_p1(3,1) = media_p1(3,1) + p1{i,1}(3,1);
          
        media_p2(1,1) = media_p2(1,1) + p2{i,1}(1,1);
        media_p2(2,1) = media_p2(2,1) + p2{i,1}(2,1);
        media_p2(3,1) = media_p2(3,1) + p2{i,1}(3,1);
        
        i=i+1;
              
    end
    
    media_p1 = [(media_p1(1,1))/size(p1,1) ; (media_p1(2,1))/size(p1,1); (media_p1(3,1))/size(p1,1)];
    media_p2 = [(media_p2(1,1))/size(p1,1) ; (media_p2(2,1))/size(p1,1); (media_p2(3,1))/size(p1,1)];
        
    
    seed_p1 = media_p1;
    seed_p2 = media_p2;
    
    %Ad ogni iterazione, aggiungo un nuovo cluster
    num_clust = num_clust+1; 
    
    while(true)
        
        % Incremento contatore numero di iterazioni
        num_iterazioni = num_iterazioni+1;
        
        
            
            % Calcolo distanza euclidea tra i punti
            %vettore seed e valori vettori parametri affini
            
            dist_p1 = cell(size(p1,1), 1);
            dist_p2 = cell(size(p1,1), 1);
            
            dist_bw_p1 = zeros(3,1);
            dist_bw_p2 = zeros(3,1);
            
            i=1;
            while(i<=size(p1,1))
                
                dist_p1{i,1} = zeros(3,1);
                dist_p2{i,1} = zeros(3,1);
                i= i+1;
            end
            
            i=1;
            while(i<=size(p1,1))
             
                dist_p1{i,1} = dist_p1{i,1} + (p1{i,1}-seed_p1).^2;
                dist_p2{i,1} = dist_p2{i,1} + (p2{i,1}-seed_p2).^2;
                
                % Metto il valore da parte per calcolare l'ampiezza di
                % banda
                dist_bw_p1 =  dist_bw_p1 + (p1{i,1}-seed_p1).^2;
                dist_bw_p2 =  dist_bw_p2 + (p2{i,1}-seed_p2).^2;
                
                i=i+1;
            end
            
            i=1;
            while(i<=size(p1,1))
                dist_p1{i,1} = sqrt(dist_p1{i,1});
                dist_p2{i,1} = sqrt(dist_p2{i,1});
                i=i+1;
            end
            
            
            % Calcolo ampiezza di banda
            dist_bw_p1 = [sqrt((dist_bw_p1(1,1)/size(p1,1))) ; sqrt((dist_bw_p1(2,1)/size(p1,1))) ; sqrt((dist_bw_p1(3,1)/size(p1,1)))];
            dist_bw_p2 = [sqrt((dist_bw_p2(1,1)/size(p1,1))) ; sqrt((dist_bw_p2(2,1)/size(p1,1))) ; sqrt((dist_bw_p2(3,1)/size(p1,1)))];
            
            % Controllo che i valori siano nell'ampiezza di banda di interesse
            
            valori_ok = ones(size(p1,1),1);
            
            i=1;
            while(i<=size(p1,1))
            
                valori_ok_p1 = dist_p1{i,1}<dist_bw_p1;
                valori_ok_p2 = dist_p2{i,1}<dist_bw_p2;
                
                if (any(valori_ok_p1(:)==0) || any(valori_ok_p2(:)==0) ) 
                    
                   valori_ok(i,1) = 0; 
                    
                end
                
                i=i+1;

            end
            
            
            valori_ok = logical(valori_ok);
            
             % Aggiorno la media (solo se ci sono nuovi valori ok)
             if (any(valori_ok(:)==1))
             
                % Inizializzo contatore numeri ok 
                num_elem_ok = 0;
                 
                media_p1 = zeros(3,1);
                media_p2 = zeros(3,1);
    
                i=1;
                while(i<=size(p1,1))
                    
                    % Per calcolare la nuova media, uso solo i valori che
                    % erano compresi nell'ampiezza di banda
                    if(valori_ok(i,1))
                        media_p1(1,1) = media_p1(1,1) + p1{i,1}(1,1);
                        media_p1(2,1) = media_p1(2,1) + p1{i,1}(2,1);
                        media_p1(3,1) = media_p1(3,1) + p1{i,1}(3,1);

                        media_p2(1,1) = media_p2(1,1) + p2{i,1}(1,1);
                        media_p2(2,1) = media_p2(2,1) + p2{i,1}(2,1);
                        media_p2(3,1) = media_p2(3,1) + p2{i,1}(3,1);
                        
                        % Conta quanti sono gli elementi che sono in fascia
                        % di banda
                        num_elem_ok = num_elem_ok +1;
                    end

                    i=i+1;

                end
                
             
    
                 media_p1 = [(media_p1(1,1))/num_elem_ok ; (media_p1(2,1))/num_elem_ok; (media_p1(3,1))/num_elem_ok];
                 media_p2 = [(media_p2(1,1))/num_elem_ok ; (media_p2(2,1))/num_elem_ok; (media_p2(3,1))/num_elem_ok];


                 seed_aggiornato_p1 = media_p1;
                 seed_aggiornato_p2 = media_p2;
             
             end
        
             % Controllo che il valore sia un numero
             if (any(isnan(seed_aggiornato_p1(:)))  || any(isnan(seed_aggiornato_p2(:))))
                break;
             end
            
             
        % Controllo se sono a convergenza, oppure se ho raggiunto numero
        % massimo iterazioni
        if ((isequal(seed_p1,seed_aggiornato_p1) && isequal(seed_p2,seed_aggiornato_p2)) || num_iterazioni>10 )
            
            % Azzero contatore
            num_iterazioni=0;
            
            % Rimuovo tutti i valori che sono stati assegnati al cluster
            i=1;
            while(i<=size(p1,1))
                
                if(valori_ok(i,1))
                    p1{i,1} = [];
                    p2{i,1} = [];
                end
                
                i=i+1;
            end
            
            % Elimino le celle vuote
            p1 = p1(~cellfun(@isempty, p1));
            p2 = p2(~cellfun(@isempty, p2));
            
            % Salvo il valore del centro del cluster trovato
            centri_cluster_p1(num_clust,:) = seed_aggiornato_p1; 
            centri_cluster_p2(num_clust,:) = seed_aggiornato_p2;
            
            %Esco dal ciclo
            break;
            
        end
        
        
        %Aggiorno il valore del seed per la prossima iterazione
        seed_p1 = seed_aggiornato_p1;
        seed_p2 = seed_aggiornato_p2;
        
        
        
        
        
    end
    
    
       % Controllo se tutti i punti sono stati assegnati, oppure se ho
    % raggiunto numero massimo di cluster
    if isempty(p1) || size(centri_cluster_p1,1)>9
       break;
    end
    
end




%
%% Ho il numero dei cluster, posso applicare il classico kmeans
%

% Elimino i centri troppo vicini tra loro (<=.75, da testare)

% Inizializzo il vettore per usarlo dopo
dist_no_ok = zeros(size(centri_cluster_p1,1),1);

% Calcolo distanza tra i vari centri
for i=1:(size(centri_cluster_p1,1)-1);
   
     dist_centri_p1= sqrt((centri_cluster_p1(i,1)-centri_cluster_p1(i+1,1)).^2 + (centri_cluster_p1(i,2)-centri_cluster_p1(i+1,2)).^2)+ (centri_cluster_p1(i,3)-centri_cluster_p1(i+1,3)).^2;
     dist_centri_p2= sqrt((centri_cluster_p2(i,1)-centri_cluster_p2(i+1,1)).^2 + (centri_cluster_p2(i,2)-centri_cluster_p2(i+1,2)).^2)+ (centri_cluster_p2(i,3)-centri_cluster_p2(i+1,3)).^2;
        
    %Salvo quali centri sono troppo vicini
     if (dist_centri_p1 <= 0.005 && dist_centri_p2 <= 0.005)
        dist_no_ok(i,:) = 1; 
     end
     
end

dist_no_ok = dist_no_ok(:);
dist_no_ok = logical(dist_no_ok);

%Elimino centri troppo vicini
centri_cluster_p1(dist_no_ok,:) = [];
centri_cluster_p2(dist_no_ok,:) = [];

%% Ottengo un'immagine clusterizzata (DA CONTINUARE DA QUI)

% Vettorizzo l'immagine per calcolare efficentemente, e ripeto l'immagine
% vettorizzata n volte, dove n è il numero dei cluster trovati
p1_ripetuta = repmat(p1_c,[1,size(centri_cluster_p1,1)]);
p2_ripetuta = repmat(p2_c,[1,size(centri_cluster_p2,1)]);

% Faccio lo stesso per il centro dei cluster
% Creo array tridimensionale

centri_p1 = zeros(1,size(centri_cluster_p1,1),3);
centri_p2 = zeros(1,size(centri_cluster_p1,1),3);

i=1;
while i<=size(centri_cluster_p1,1)
    
    centri_p1(1,i,:) = centri_cluster_p1(i,:);
    centri_p2(1,i,:) = centri_cluster_p2(i,:);
    
    i=i+1;

end

centri_ripetuti_p1 = (repmat(centri_p1,[size(p1_c,1),1]));
centri_ripetuti_p2 = (repmat(centri_p2,[size(p1_c,1),1]));

%Calcolo distanza di ogni punto rispetto centro cluster
distanza_p1 = ((p1_ripetuta(:,:,1)-centri_ripetuti_p1(:,:,1)).^2) + ((p1_ripetuta(:,:,2)-centri_ripetuti_p1(:,:,2)).^2) + ((p1_ripetuta(:,:,3)-centri_ripetuti_p1(:,:,3)).^2);
distanza_p2 = ((p2_ripetuta(:,:,1)-centri_ripetuti_p2(:,:,1)).^2) + ((p2_ripetuta(:,:,2)-centri_ripetuti_p2(:,:,2)).^2) + ((p2_ripetuta(:,:,3)-centri_ripetuti_p2(:,:,3)).^2);


distanza= sqrt(distanza_p1+distanza_p2);

% Assegno ogni punto al cluster più vicino
[~,cluster_assegnamento] = min(distanza,[],2);

% Ricostruisco l'immagine, sostituendo ad ogni pixel il numero del cluster di cui fa parte 
aff_param_clusterizzati = reshape(cluster_assegnamento,[6 11]);

toc;

% %% Mostra i cluster in cui è divisa l'immagine, da togliere in versione finale
% 
% figure(1);
% imshow(aff_param_clusterizzati,[]);
% title('cluster su spazio parametri affini');
% 
% figure(2);
% subplot( ceil((size(centri_cluster,1))/2), ceil((size(centri_cluster,1))/2), 1);
% imshow(aff_param_clusterizzati,[]);
% title('Spazio p.a. clusterizzato.')
% 
% for i =1:(size(centri_cluster,1))
%         
%             subplot( ceil((size(centri_cluster,1))/2), ceil((size(centri_cluster,1))/2), i);
%             imshow(aff_param_clusterizzati == i,[]);
%             title(['Cluster numero ' num2str(i) '.']);
%              
% end

end