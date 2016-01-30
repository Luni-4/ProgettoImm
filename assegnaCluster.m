function [newRegioni,distanzaMin]  = assegnaCluster(u,v,cc,regioni)
    %% Ottengo un'immagine clusterizzata
    

%     % Creo matrice 3 dimensioni per velocizzare calcoli
%     affiniX_ripetuta = repmat(affiniX(:,1:3),[1,1,size(ccp1,1)]);
%     affiniY_ripetuta = repmat(affiniY(:,1:3),[1,1,size(ccp2,1)]);
%     
%     % Creo array tridimensionale cluster
%     ccp1_c = ccp1;
%     ccp2_c = ccp2;
% 
% %     [r,c] = size(ccp1);
% %     nlay  = 3;
% %     ccp1   = permute(reshape(ccp1',[c,r/nlay,nlay]),[2,1,3]);
% % 
% %     [r,c] = size(ccp2);
% %     nlay  = 3;
% %     ccp2   = permute(reshape(ccp2',[c,r/nlay,nlay]),[2,1,3]);
% 
%     ccp1 = permute(ccp1,[3,2,1]);
%     ccp2 = permute(ccp2,[3,2,1]);
% 
%     ccp1 = repmat(ccp1,[size(affiniX,1),1,1]);
%     ccp2 = repmat(ccp2,[size(affiniX,1),1,1]);
% 
%     %Calcolo distanza di ogni punto rispetto centro cluster
%     distanzaX = sum(((affiniX_ripetuta-ccp1).^2),2);
%     distanzaY = sum(((affiniY_ripetuta-ccp2).^2),2);
% 
%     distanza = (distanzaX+distanzaY)./2;
% 
% 
%     % Assegno ogni punto al cluster più vicino
%     [~,cluster_assegnamento] = min(distanza,[],3);
% 
%     % Riordino la numerazione delle regioni prima kmeans
%     vecchiValori = unique(regioni);
%     for i=0:(size(vecchiValori,1))-1
% 
%         regioni(regioni == vecchiValori(i+1,1)) = i;
% 
%     end
    
    % Trovo il regressore per tutti i pixel dell'immagine
    sz = size(regioni);
    index = ones(sz);
    [xt, yt] = find(index);
    regressore = [ones(size(xt)), xt, yt];
    
    
    % Preparo matrici per valori stima u e v
    uStimato = zeros(size(regioni,1),size(regioni,2),size(cc,1));
    vStimato = uStimato;
    
    % Calcolo u e v rispetto ogni centro possibile
    for i=1:size(cc,1)
        uStimato(:,:,i) = reshape(regressore*(cc(i,1:3))',sz);
        vStimato(:,:,i) = reshape(regressore*(cc(i,4:6))',sz);
    end
    
    % Ripeto valori di u e v trovati dal flusso ottico per numero centri
    % possibili
    uRipetuta = repmat(u,[1,1,size(cc,1)]);
    vRipetuta = repmat(v,[1,1,size(cc,1)]);
    
    % Trovo a quali centri sono più vicini tutti i punti
    distanza = sqrt((uRipetuta - uStimato).^2 +  (vRipetuta - vStimato).^2);
    
%     uDist = (uRipetuta - uStimato).^2;
%     vDist = (uRipetuta - uStimato).^2
%     distanza = (uDist-vDist)./2;
    
    %Assegno ogni punto al cluster più vicino
    [distanzaMin,cluster_assegnamento] = min(distanza,[],3);

    % Riordino la numerazione delle regioni prima kmeans
    vecchiValori = unique(regioni);
    for i=0:(size(vecchiValori,1))-1

        regioni(regioni == vecchiValori(i+1,1)) = i;
    end
        
    % Ricostruisco l'immagine, sostituendo ad ogni regione il numero del cluster di cui fa parte 
    newRegioni = zeros(size(regioni,1),size(regioni,2));

    for i=1:size(cluster_assegnamento,1);
        newRegioni(regioni==i) = cluster_assegnamento(i,1);    
    end

%     % PRmetri affini per ogni regione
%     newAffiniX = zeros(size(ccp1,3),4);
%     newAffiniY = zeros(size(ccp1,3),4);
% 
%     for i=1:size(ccp1,3)
%         newAffiniX(i,:) = [ccp1_c(cluster_assegnamento(i,1),:), i];
%         newAffiniY(i,:) = [ccp2_c(cluster_assegnamento(i,1),:), i];
%     end
end