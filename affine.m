function [Axi, Ayi,uStimato, vStimato ] = affine(uReg,vReg,xt,yt)

    % Funzione che, per ogni regione/layer di movimento trovato, calcola i 6 parametri affini,
    % 3 per le x e 3 per le y, e i flussi ottici stimati a partire dai parametri affini calcolati
    
    % Regressore trasposto [1 x y]
    regressorT=[ones(numel(xt),1) xt yt];
    
    % Regressore
    regressor=regressorT';
    
    % Somma del prodotto matriciale tra regressore e regressore trasposto 
    sumr=regressor(1:3,:)*regressorT(:,1:3);
    
    % Somma del prodotto matriciale tra regressore e flusso ottico per
    % le x
    sumvx=regressor(1:3,:)*uReg;
    
    % Somma del prodotto matriciale tra regressore e flusso ottico per le
    % y
    sumvy=regressor(1:3,:)*vReg;
    
    % Risoluzione del sistema Ax=b, vengono trovati i 3 parametri affini delle x
    Axi=sumr\sumvx;  
    
    % Risoluzione del sistema Ax=b, vengono trovati i 3 parametri affini
    % delle y
    Ayi=sumr\sumvy;      
    
    %Calcolo dei flussi ottici stimati per le x
    uStimato = regressorT(:,1:3)*Axi;
    
    %Calcolo dei flussi ottici stimati per le y  
    vStimato = regressorT(:,1:3)*Ayi;  
        
end