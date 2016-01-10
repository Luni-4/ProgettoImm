function bool = errorStima(u,v,uS,vS,th)
    magnitudeR =  hypot(u,v); % calcolo del magnitudo del flusso ottico
    magnitudeRS = hypot(uS,vS); % calcolo del magnitudo del flusso ottico stimato
    sigma=(sum((magnitudeR-magnitudeRS).^2))/numel(u); % formula per il calcolo dell'errore
    if sigma <= th %se errore è <= a soglia, regione mantenuta nell'analisi
       bool=1;
    else %altrimenti eliminata
       bool=0;
    end
end