function bool = errorStima(u,v,uS,vS,th) 
    % Viene calcolato l'errore residuo associato alla regione/layer di
    % movimento considerato    
    sigma = (sum((u-uS).^2+(v-vS).^2))/numel(u);
    % se errore, contenuto nella variabile sigma, è minore o uguale a soglia di threshold,
    % regione/ layer di movimento non viene scartato dall'analisi
    if sigma <= th 
       bool=1;
    else 
       bool=0;
    end
end