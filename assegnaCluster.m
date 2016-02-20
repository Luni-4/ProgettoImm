function [newRegioni,distanzaMin]  = assegnaCluster(u,v,cc,regioni)

% Funzione utilizzata per la creazione di un immagine clusterizzata, usando
% i centri dei cluster trovati da thresholdClustering.


% Trovo il regressore per tutti i pixel dell'immagine
sz = size(regioni);
index = ones(sz);
[xt, yt] = find(index);
regressore = [ones(size(xt)), xt, yt];


% Preparo matrici per valori stima u e v
uStimato = zeros(size(regioni,1),size(regioni,2),size(cc,1));
vStimato = uStimato;

% Calcolo u e v rispetto ogni centro possibile, utilizzando un prodotto
% matriciale tra regressore e parametri affini di ogni centro
for i=1:size(cc,1)
    uStimato(:,:,i) = reshape(regressore*(cc(i,1:3)'),sz);
    vStimato(:,:,i) = reshape(regressore*(cc(i,4:6)'),sz);
end

% Viene sfruttata una matrice tridimensionale per calcolare la distanza di
% ogni pixel rispetto ad ogni possibile centro. Ripeto valori di u e v
% trovati dal flusso ottico lungo la dimensione z n volte, dove n è uguale
% al numero di centri trovati
uRipetuta = repmat(u,[1,1,size(cc,1)]);
vRipetuta = repmat(v,[1,1,size(cc,1)]);

% Ogni pixel viene assegnato all'ipotesi migliore, individuata utilizzando
% una distanza euclidea
distanza = sqrt((uRipetuta - uStimato).^2 +  (vRipetuta - vStimato).^2);


% Assegno ogni pixel al cluster con ipotesi migliore. distanzaMin contiene
% la distanza euclida del pixel rispetto cluster di assegnamento, mentra
% newRegioni è la nuova immagine clusterizzata.
[distanzaMin,newRegioni] = min(distanza,[],3);


end