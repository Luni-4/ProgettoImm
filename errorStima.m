function bool = errorStima(u,v,uS,vS,th)

sigma = (sum((u-uS).^2+(v-vS).^2))/numel(u); % formula per il calcolo dell'errore
if sigma <= th %se errore è <= a soglia, regione mantenuta nell'analisi
    bool=1;
else %altrimenti eliminata
    bool=0;
end

end