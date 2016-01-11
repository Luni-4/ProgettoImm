% Calcolo dei parametri affini e dei flussi ottici stimati per ogni regione 
function [Axi, Ayi,uStimato, vStimato ] = affine(uReg,vReg,xt,yt)
    
    %Regressore trasposto
    regressorT=[ones(numel(xt),1) xt yt];
    % Regressore
    regressor=regressorT';
    % Somma del prodotto matriciale tra regressore e regressore trasposto 
    sumr=regressor(1:3,:)*regressorT(:,1:3);
    % Somma del prodotto matriciale tra regressore e flusso ottico lungo
    % le x
    sumvx=regressor(1:3,:)*uReg;
    % Somma del prodotto matriciale tra regressore e flusso ottico lungo le
    % y
    sumvy=regressor(1:3,:)*vReg;
    
    % Risoluzione del sistema Ax=b per i parametri affini dei flussi ottici lungo le x 
    Axi=sumr\sumvx;   
    % Risoluzione del sistema Ax=b per i parametri affini dei flussi ottici lungo le y
    Ayi=sumr\sumvy;  
    
    %Se si vogliono usare le pseudo inverse
    %Hxi=pinv(sumr)*sumvx; %parametri affini flussi ottici lungo le x
    %Hyi=pinv(sumr)*sumvy; %parametri affini flussi ottici lungo le y 

    uStimato = regressorT(:,1:3)*Axi; %Calcolo dei flussi ottici stimati lungo le x
    vStimato = regressorT(:,1:3)*Ayi; %Calcolo dei flussi ottici stimati lungo le y   
        
end