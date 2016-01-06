function [regX, regY] = errorStima(uReg,vReg,uS,vS,th)
    magnitudeR =  hypot(uReg,vReg); % calcolo del magnitudo del flusso ottico
    magnitudeRS = hypot(uS,vS); % calcolo del magnitudo del flusso ottico stimato
    sigma=(sum(sum((magnitudeR-magnitudeRS).^2)))/numel(uReg); % formula per il calcolo dell'errore
    if sigma <= th %se errore è <= a soglia, regione mantenuta nell'analisi
        regX=uS;
        regY=vS;
    else %altrimenti eliminata
        regX=[];
        regY=[];
    end
end