function [newRegioni,distanzaMin]  = assegnaCluster(u,v,cc,regioni)
%% Ottengo un'immagine clusterizzata

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
    uStimato(:,:,i) = reshape(regressore*(cc(i,1:3)'),sz);
    vStimato(:,:,i) = reshape(regressore*(cc(i,4:6)'),sz);
end

% Ripeto valori di u e v trovati dal flusso ottico per numero centri
% possibili
uRipetuta = repmat(u,[1,1,size(cc,1)]);
vRipetuta = repmat(v,[1,1,size(cc,1)]);

% Trovo a quali centri sono più vicini tutti i punti
distanza = sqrt((uRipetuta - uStimato).^2 +  (vRipetuta - vStimato).^2);


%Assegno ogni punto al cluster più vicino
[distanzaMin,newRegioni] = min(distanza,[],3);


end