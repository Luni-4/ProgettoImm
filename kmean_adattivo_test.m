function [newAffiniX, newAffiniY, newRegioni] = kmean_adattivo_test(affiniX,affiniY,regioni)
%% Tentantivo di kmeans sui parametri affini

% Controlliamo il tempo di esecuzione
tic

% Faccio una copia 
affiniX_c = affiniX;
affiniY_c = affiniY;


%% Applico il kmeans adattivo ai valori che ho trovato

% Contatore numero cluster
num_clust = 0;

% Contatore numero massimo iterazioni
num_iterazioni=0; 


while(true)
    
    % Calcolo il seed del primo centro, ossia l'equazione della retta con
    % cui vorrei approssimare le rette trovate precedentemente
    p1Media = median(affiniX(:,1:3),1);
    p2Media = median(affiniY(:,1:3),1);
    
    % Uso i valori trovati come coordinate punto seed
    p1Seed = p1Media;
    p2Seed = p2Media;
    
    %Ad ogni iterazione, aggiungo un nuovo cluster
    num_clust = num_clust+1; 
    
    while(true)
        
        % Incremento contatore numero di iterazioni
        num_iterazioni = num_iterazioni+1;
                      
        % Calcolo distanza euclidea tra i punti
        %vettore seed e valori vettori parametri affini
        if(exist('p1Dist','var'))
               p1Dist = []; 
               p2Dist = []; 
        end
        p1Dist(:,1) = sqrt(sum((affiniX(:,1:3) - p1Seed).^2,2));
        p2Dist(:,1) = sqrt(sum((affiniY(:,1:3) - p2Seed).^2,2));
     
                       
        % Calcolo ampiezza di banda
        p1Dist_bw = sqrt((sum(sum((affiniX(:,1:3) - p1Seed).^2,2),1))/size(affiniX,1));
        p2Dist_bw = sqrt((sum(sum((affiniY(:,1:3) - p2Seed).^2,2),1))/size(affiniX,1));
            
        % Controllo che i valori siano nell'ampiezza di banda di interesse
        if(exist('valori_ok','var'))
               clearvars  valori_ok; 
        end
        valori_ok(:,1) = p1Dist(:)<p1Dist_bw;
        valori_ok(:,1) = p2Dist(:)<p2Dist_bw;
            
        % Aggiorno il seed
        p1NewSeed = mean(affiniX(valori_ok,1:3),1);
        p2NewSeed = mean(affiniY(valori_ok,1:3),1);
            
                        
        % Controllo che il valore sia un numero
        if (any(isnan(p1NewSeed(:)))  || any(isnan(p2NewSeed(:))))
                break;
        end
            
             
        % Controllo se sono a convergenza, oppure se ho raggiunto numero
        % massimo iterazioni
        if ((isequal(p1Seed,p1NewSeed) && isequal(p2Seed,p2NewSeed)) || num_iterazioni>10 )
            
            % Azzero contatore
            num_iterazioni=0;
            
            affiniX(valori_ok,:) = [];
            affiniY(valori_ok,:) = [];
          
                       
            % Salvo il valore del centro del cluster trovato
            centri_cluster_p1(num_clust,:) = p1NewSeed; 
            centri_cluster_p2(num_clust,:) = p1NewSeed;
            
            %Esco dal ciclo
            break;
            
        end
        
        
        %Aggiorno il valore del seed per la prossima iterazione
        p1Seed = p1NewSeed;
        p2Seed = p2NewSeed;
       
        
    end
    
    
       % Controllo se tutti i punti sono stati assegnati, oppure se ho
    % raggiunto numero massimo di cluster
    if isempty(affiniX) || num_clust>9
       break;
    end
    
end




%
%% Ho il numero dei cluster, posso applicare il classico kmeans
%

% Elimino i centri troppo vicini tra loro (<=.75, da testare)

% Calcoliamo la distanza dei centri dallo zero
dist_cc1 = diff(centri_cluster_p1,1,1);
dist_cc2 = diff(centri_cluster_p2,1,1);

% Elimino i centri che sono troppo vicini (PER ORA DISTANZA DI PROVA 0,75)
centri_no_ok = (sqrt(sum((dist_cc1).^2,2)) + sqrt(sum((dist_cc2).^2,2)))./2<=0.75;
centri_no_ok = any(centri_no_ok==1,2);
centri_no_ok = [0;centri_no_ok]; 
centri_no_ok = logical(centri_no_ok);

centri_cluster_p1(centri_no_ok) = [];
centri_cluster_p2(centri_no_ok) = [];


%% Ottengo un'immagine clusterizzata

% Vettorizzo l'immagine per calcolare efficentemente, e ripeto l'immagine
% vettorizzata n volte, dove n è il numero dei cluster trovati
affiniX_ripetuta = repmat(affiniX_c(:,1:3),[1,1,size(centri_cluster_p1,1)]);
affiniY_ripetuta = repmat(affiniY_c(:,1:3),[1,1,size(centri_cluster_p2,1)]);

% Faccio lo stesso per il centro dei cluster
% Creo array tridimensionale
ccp1 = centri_cluster_p1;
ccp2 = centri_cluster_p2;

[r,c] = size(centri_cluster_p1);
nlay  = 3;
centri_cluster_p1   = permute(reshape(centri_cluster_p1',[c,r/nlay,nlay]),[2,1,3]);

[r,c] = size(centri_cluster_p2);
nlay  = 3;
centri_cluster_p2   = permute(reshape(centri_cluster_p2',[c,r/nlay,nlay]),[2,1,3]);

centri_cluster_p1 = repmat(centri_cluster_p1,[size(affiniX_c,1),1,1]);
centri_cluster_p2 = repmat(centri_cluster_p2,[size(affiniX_c,1),1,1]);

%Calcolo distanza di ogni punto rispetto centro cluster
distanzaX = sum(((affiniX_ripetuta-centri_cluster_p1).^2),2);
distanzaY = sum(((affiniY_ripetuta-centri_cluster_p2).^2),2);

distanza = (distanzaX+distanzaY)./2;


% Assegno ogni punto al cluster più vicino
[~,cluster_assegnamento] = min(distanza,[],3);

% Riordino la numerazione delle regioni prima kmeans
vecchiValori = unique(regioni);
for i=1:size(vecchiValori,1)
    
    regioni(regioni == vecchiValori(i,1)) = i;
       
end

% Ricostruisco l'immagine, sostituendo ad ogni regione il numero del cluster di cui fa parte 
newRegioni = zeros(size(regioni,1),size(regioni,2));

for i=1:size(cluster_assegnamento,1);
    newRegioni(regioni==i) = cluster_assegnamento(i,1);    
end

% PRmetri affini per ogni regione
newAffiniX = zeros(size(centri_cluster_p1,3),4);
newAffiniY = zeros(size(centri_cluster_p1,3),4);

for i=1:size(centri_cluster_p1,3)
    newAffiniX(i,:) = [ccp1(cluster_assegnamento(i,1),:), i];
    newAffiniY(i,:) = [ccp2(cluster_assegnamento(i,1),:), i];
end
toc;
end