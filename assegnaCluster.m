function [newRegioni,distanzaMin]  = assegnaCluster(u,v,cc,regioni)

% Funzione utilizzata per assegnare i centri dei cluster, parametri affini,
% trovati dal thresholdClustering, ad un immagine. Ad ogni centro trovato
% corrisponde un valore in scala di grigio


% Viene trovato il regressore trasposto per tutti i pixel dell'immagine
sz = size(regioni);
index = ones(sz);
[xt, yt] = find(index);
regressore = [ones(size(xt)), xt, yt];


% Matrici contenenti i valori u e v che verranno stimati a partire dai
% parametri affini, centri dei cluster, trovati
uStimato = zeros(size(regioni,1),size(regioni,2),size(cc,1));
vStimato = uStimato;

% Calcolo di u e v rispetto ogni centro possibile, utilizzando un prodotto
% matriciale tra regressore e parametri affini di ogni centro
for i=1:size(cc,1)
    uStimato(:,:,i) = reshape(regressore*(cc(i,1:3)'),sz);
    vStimato(:,:,i) = reshape(regressore*(cc(i,4:6)'),sz);
end

% Per calcolare la distanza di ogni pixel rispetto ad ogni possibile centro viene usata una matrice tridimensionale. 
% I valori di u e v , trovati dal flusso ottico lungo la dimensione z, vengono ripetuti n volte, dove n è uguale
% al numero di centri trovati
uRipetuta = repmat(u,[1,1,size(cc,1)]);
vRipetuta = repmat(v,[1,1,size(cc,1)]);

% Per ogni pixel, viene calcolata la distanza euclidea con ogni centro dei
% cluster
distanza = sqrt((uRipetuta - uStimato).^2 +  (vRipetuta - vStimato).^2);


% Ogni pixel viene assegnato al cluster con distanza minima. distanzaMin contiene
% la distanza euclidea minima del pixel, rispetto al cluster di assegnamento,
% mentre newRegioni contiene la nuova immagine clusterizzata.
[distanzaMin,newRegioni] = min(distanza,[],3);


end