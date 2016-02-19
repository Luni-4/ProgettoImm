function centriParametri = kmeansClassico(affini,nCluster)

%
% Contatore iterazioni
nIterazioni = 1;


% Inizializzo i centri a caso
maxValue = max(affini(:,1:6),[],1);
a1 = maxValue(1,1)/nCluster : maxValue(1,1)/nCluster : maxValue(1,1);
a2 = maxValue(1,2)/nCluster : maxValue(1,2)/nCluster : maxValue(1,2);
a3 = maxValue(1,3)/nCluster : maxValue(1,3)/nCluster : maxValue(1,3);
a4 = maxValue(1,4)/nCluster : maxValue(1,4)/nCluster : maxValue(1,4);
a5 = maxValue(1,5)/nCluster : maxValue(1,5)/nCluster : maxValue(1,5);
a6 = maxValue(1,6)/nCluster : maxValue(1,6)/nCluster : maxValue(1,6);

a1 = permute(a1,[3,1,2]);
a2 = permute(a2,[3,1,2]);
a3 = permute(a3,[3,1,2]);
a4 = permute(a4,[3,1,2]);
a5 = permute(a5,[3,1,2]);
a6 = permute(a6,[3,1,2]);

centri = [a1,a2,a3,a4,a5,a6];

% Ripeto parametri affini in entrata
affiniRipetuta = repmat(affini(:,1:6),[1,1,nCluster]);

while(true)
    
    % Ripeto centri
    centriRipetuti = repmat(centri, [size(affini,1),1,1]);
    
    % Calcolo distanza
    distanza = sum(((affiniRipetuta - centriRipetuti).^2),2);
    
    % Trovo a quale centro sono più vicino
    [~,centroVicino] = min(distanza,[],3);
    
    % Mi segno centro più vicino
    affini(:,7) = centroVicino;
    affiniC = affini(:,1:6);
    
    nuoviCentri = centri;
    
    % Calcolo i nuovi centri come media parametri affini
    for i=1:nCluster
        appartenentiCluster = affini(:,7) == i;
        nuoviCentri(1,6,i) = sum(affiniC(appartenentiCluster),1);
    end
    
    
    %Controllo se sono a convergenza oppure numero max iterazioni
    if(isequal(nuoviCentri,centri) || nIterazioni >10)
        break;
    else
        centri = nuoviCentri;
    end
    
    nIterazioni = nIterazioni +1;
    
end

centriParametri = permute(centri,[3,2,1]);


end