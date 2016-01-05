function [Hxi,Hyi,uStimato,vStimato] = affine(uReg,vReg)
    sumr=0; 
    sumvx=0;
    sumvy=0;
    for x=1:size(uReg,1)
        for y=1:size(uReg,2)
            regressor = [1 x y]';
            sumr=sumr+(regressor*regressor');
            sumvx=sumvx+regressor*uReg(x,y);
            sumvy=sumvy+regressor*vReg(x,y);            
        end
    end
    Hxi=sumr\sumvx;
    Hyi=sumr\sumvy;     
    
    % Per ogni pixel in regione viene calcolata stima del flusso ottico
    % lungo le x e le y
    [rt,ct]=find((uReg==0 | uReg~=0)); % uStimato,vStimatotrovare indici regione 
    z=[ones([numel(uReg),1]) rt ct]; % Costruzione regressore 
    uStimato=reshape(z*Hxi,[size(uReg,1),size(uReg,2)]); %Calcolo valori stimati flusso ottico vx
    vStimato=reshape(z*Hyi,[size(uReg,1),size(uReg,2)]); %Calcolo valori stimati flusso ottico vy
end