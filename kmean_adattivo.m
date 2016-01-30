function [centri_cluster] = kmean_adattivo(affini,th)
%% Kmeans sui parametri affini

% Contatore numero cluster
num_clust = 0;

% Contatore numero massimo iterazioni
num_iterazioni=0;



while(true)
    
    % Calcolo il seed del primo centro, ossia l'equazione della retta con
    % cui vorrei approssimare le rette trovate precedentemente
    media = mean(affini(:,1:6),1);
    
%     p1Media = mean(affiniX(:,1:3),1);
%     p2Media = mean(affiniY(:,1:3),1);

    
    % Uso i valori trovati come coordinate punto seed
    seed = media;
    
%     p1Seed = p1Media;
%     p2Seed = p2Media;
    
    %Ad ogni iterazione, aggiungo un nuovo cluster
    num_clust = num_clust+1; 
    
    while(true)
        
        % Incremento contatore numero di iterazioni
        num_iterazioni = num_iterazioni+1;
                      
        % Calcolo distanza euclidea tra i punti
        %vettore seed e valori vettori parametri affini
        if(exist('dist','var'))
               clearvars dist; 
        end
        
        dist = sqrt(sum(((affini(:,1:6) - repmat(seed,[size(affini,1),1,1])).^2),2));
        
%         p1Dist(:,1) = sqrt(sum(((affiniX(:,1:3) - p1Seed).^2),2));
%         p2Dist(:,1) = sqrt(sum(((affiniY(:,1:3) - p2Seed).^2),2));
     
                       
       % Calcolo distanza minima tra regioni e nuovo seed
       dist_bw = sqrt((sum(sum((affini(:,1:6) - repmat(seed,[size(affini,1),1,1])).^2,2),1))/size(affini,1));
        
%         p1Dist_bw = sqrt((sum(sum((affiniX(:,1:3) - p1Seed).^2,2),1))/size(affiniX,1));
%         p2Dist_bw = sqrt((sum(sum((affiniY(:,1:3) - p2Seed).^2,2),1))/size(affiniX,1));
            
        % Controllo che i valori siano nell'ampiezza di banda di interesse
        if(exist('valori_ok','var'))
               clearvars  valori_ok; 
        end
        
        valori_ok = dist<dist_bw;
        
%         valori_ok(:,1) = p1Dist(:)<p1Dist_bw;
%         valori_ok(:,2) = p2Dist(:)<p2Dist_bw;
%         valori_ok = sum(valori_ok,2);
%         valori_ok(valori_ok>0) = 1;
%         valori_ok = logical(valori_ok);
            
        % Aggiorno il seed
        newSeed = mean(affini(valori_ok, 1:6));
        
        
%         p1NewSeed = mean(affiniX(valori_ok,1:3),1);
%         p2NewSeed = mean(affiniY(valori_ok,1:3),1);
            
                        
        % Controllo che il valore sia un numero
        if (any(isnan(newSeed(:))))
            num_iterazioni = 0;
            break;
        end
        
%         if (any(isnan(p1NewSeed(:)))  || any(isnan(p2NewSeed(:))))
%             num_iterazioni = 0;
%             break;
%         end
            
             
        % Controllo se sono a convergenza, oppure se ho raggiunto numero
        % massimo iterazioni
         if (isequal(seed,newSeed)|| num_iterazioni>10 )
            
            % Azzero contatore
            num_iterazioni=0;
            
            affini(valori_ok,:) = [];
          
                       
            % Salvo il valore del centro del cluster trovato
            centri_cluster(num_clust,:) = newSeed; 
            
            
            %Esco dal ciclo
            break;
            
        end
        
%         if ((isequal(p1Seed,p1NewSeed) && isequal(p2Seed,p2NewSeed)) || num_iterazioni>10 )
%             
%             % Azzero contatore
%             num_iterazioni=0;
%             
%             affiniX(valori_ok,:) = [];
%             affiniY(valori_ok,:) = [];
%           
%                        
%             % Salvo il valore del centro del cluster trovato
%             centri_cluster_p1(num_clust,:) = p1NewSeed; 
%             centri_cluster_p2(num_clust,:) = p2NewSeed;
%             
%             %Esco dal ciclo
%             break;
%             
%         end
        
        
        %Aggiorno il valore del seed per la prossima iterazione
        seed= newSeed;
        
%         p1Seed = p1NewSeed;
%         p2Seed = p2NewSeed;
       
        
    end
    
    
       % Controllo se tutti i punti sono stati assegnati, oppure se ho
    % raggiunto numero massimo di cluster
     if isempty(affini) || num_clust>9
       break;
    end
    
%     if isempty(affiniX) || num_clust>9
%        break;
%     end
    
end




%
%% Ho il numero dei cluster, posso applicare il classico kmeans
%

% Elimino i centri troppo vicini tra loro (<=.75, da testare)

% Calcoliamo la distanza dei centri dallo zero
dist = diff(centri_cluster,1,1);

% dist_cc1 = diff(centri_cluster_p1,1,1);
% dist_cc2 = diff(centri_cluster_p2,1,1);

% Elimino i centri che sono troppo vicini (PER ORA DISTANZA DI PROVA 0,75)
centri_no_ok = sqrt(sum((dist).^2,2))<=th; % Calcolo distanza tra centri

% centri_no_ok = (sqrt(sum((dist_cc1).^2,2)) + sqrt(sum((dist_cc2).^2,2)))./2<=0.75; % Calcolo distanza tra centri
% centri_no_ok = any(centri_no_ok==1,2);           % Controllo se centri sono più vicini distanza

centri_no_ok = [false;centri_no_ok];  % Aggiunta riga per rendere booleano stessa dimensione centri_no_ok
centri_cluster(centri_no_ok,:) = [];

% centri_cluster_p1(centri_no_ok,:) = [];
% centri_cluster_p2(centri_no_ok,:) = [];


end