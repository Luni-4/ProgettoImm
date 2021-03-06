function [regioniOut,regioniErr] =  AffineMotion(u,v, prima, regioniIn,thCluster)

% Funzione che identifica i diversi layer di movimento per ciascuna coppia
% di frame presenti nella sequenza video. Nei commenti relativi a questa
% funzione, la parola regioni si riferisce alle regioni 20x20 calcolate
% inizialmente, mentre layer di movimento alle successive regioni calcolate

% Variabile che conta il numero di iterazioni fatte dal ciclo while per
% individuare tutti i possibili layer di movimento
iterazione=1;

% Se si � alla prima iterazione e si stanno analizzando i primi due frame
% della sequenza, il flusso ottico viene suddiviso in regioni di dimensione
% 20x20. Altrimenti, vengono utilizzati i layer di movimento, alla quale
% sono stati totli i pixel con errore elevato, della coppia di frame
% analizzati precedentemente
if prima == true
    [regioni, numregioni] = Image20x20Subdivider(u);
else
    regioni = regioniIn;
    % Trovare numero di layer di movimento contenuti in regioniIn
    numregioni = numel(unique(regioniIn));
end


% Il ciclo while sottostante viene eseguito per un numero di iterazioni
% tale da consentire di poter individuare tutti i layer di movimento
% presenti
while (true)
    
    % Inizializzazione del contatore che valuta il tempo di esecuzione
    % delle istruzioni contenute nel ciclo while per ogni iterazione
    tic;
    
    % Matrice che salva i parametri affini e la regione alla quale sono
    % associati
    affini = zeros(numregioni,7);
    
    % Array che salva il flusso ottico calcolato usando i parametri affini
    % per le x (ax0, axx, axy)
    uStimato=u;
    
    % Array che salva il flusso ottico calcolato usando i parametri affini
    % per le y (ay0, ayx, ayy)
    vStimato=v;
    
    % Viene impostata soglia per l'eliminazione delle regioni/layer di
    % movimento che hanno un errore residuo troppo alto, le ipotesi
    % associate a queste regioni non forniscono una buona descrizione del
    % movimento e devono essere eliminate per facilitare l'operazione di
    % clustering
    threshold=1;
    
    % Il ciclo itera sui layer di movimento/regioni calcolando le ipotesi
    % di movimento con i relativi parametri affini
    for i=1:numregioni
        
        % Per ogni regione/layer di movimento vengono salvati gli indici
        % delle righe nell'array xt e quelli delle colonne in yt
        [xt,yt]=find(regioni == i);
        % Viene invocata funzione affine
        [Axi, Ayi, uS, vS] = affine(u(regioni==i),v(regioni==i),xt,yt);
        % Viene salvato il flusso ottico calcolato usando i parametri
        % affini per le x
        uStimato(regioni == i)= uS;
        % Viene salvato il flusso ottico calcolato usando i parametri
        % affini per le y
        vStimato(regioni == i)= vS;
        
        % Funzione che calcola errore residuo, se valore restituito � pari
        % a 1, i parametri affini calcolati vengono salvati con relativa
        % regione/ layer di movimento alla quale sono associati. Questo controllo viene effettuato
        %solo alla prima iterazione della prima coppia di frame.
        if prima == true
            if errorStima(u(regioni==i),v(regioni==i),uS,vS,threshold) == 1
                affini(i, 1:3) = Axi';  % Salvataggio dei parametri affini per le x
                affini(i, 4:6) = Ayi'; % Salvataggio dei parametri affini per le y
                affini(i,7) = i; % Salvataggio della regione/layer di movimento a cui sono associati
            end
        else
            affini(i, 1:3) = Axi';  % Salvataggio dei parametri affini per le x
            affini(i, 4:6) = Ayi'; % Salvataggio dei parametri affini per le y
            affini(i,7) = i; % Salvataggio della regione/layer di movimento a cui sono associati

        end
        
    end
    
    
    %Eliminazione dall'array affini i parametri affini che non hanno
    %superato la soglia di threshold. Questo controllo viene effettuato
    %solo alla prima iterazione della prima coppia di frame.
    if prima == true 
        affini((affini(:,7) ==0),:) = [];
        prima = false;
    end    

    
    
    % Raggruppamento in cluster di regioni aventi parametri affini simili,
    % invocando thresholdClustering. La funzione restituisce le coordinate
    % dei centri dei cluster che meglio approssimano i parametri affini
    % contenuti nella variabile "affini". La variabile di threshold viene
    % inserita dall'utente e va ad indicare la distanza minima che un
    % determinato elemento(composto dai 6 parametri affini) deve avere dal
    % centro di un cluster, in modo che sia assegnato ad esso. Numeri pi�
    % bassi garantiscono che anche movimenti molto piccoli vengano
    % individuati come cluster separati, ma aumentano la sovrasegmentazione
    % dell'immagine finale, nonch� il costo computazionale. Per valori
    % consigliati, fare riferimento alla tabella  alla fine della
    % documentazione.
    [cc] = thresholdClustering(affini,thCluster);
    
    
    % Assegnameno regioni a cluster pi� vicino. La funzione associa ogni
    % pixel al cluster avente centro con parametri affini pi� simili ai
    % parametri affini del pixel in questione.
    [regioni,distanza] = assegnaCluster(u,v,cc,regioni);    
    
    
    % Eliminazione pixel con errore residuo troppo alto. thErr rappresenta
    % il valore di errore massimo, che � posto ad 1, poich� euristicamente
    % ha dato risultati migliori. I pixel scartati vengono salvati in
    % regioniErr venendo tutti posti a 0,  andando a formare un layer
    % speciale.
        thErr= 1;
        regioniErr = residualError(regioni,distanza,thErr);

    
    % Controllo sul numero delle iterazioni del calcolo affine motion. I
    % valori max di iterazioni sono trovati euristicamente
    if (iterazione > 5)               
        break;
    end
    
    
    % Regioni appartenenti ad uno stesso layer, ma tra loro spazialmente
    % disgiunte, sono separate in layer differenti.
    regioni = separaRegioni(regioniErr);
    
    % Eliminazione regioni troppo piccole
    [regioni, numregioni] = filtroRegioni(regioni);
    
    % Valutazione del tempo di esecuzione delle istruzioni contenute nel
    % ciclo while per ogni iterazione
    t = toc;
    disp(['Iterazione ',num2str(iterazione), ' ok, durata iterazione = ',num2str(t),'.']);
    
    % Incremento contatore del numero di iterazioni fatte dal ciclo while
    % per individuare tutti i possibili layer di movimento
    iterazione = iterazione +1;
    
    
end % Fine iterazioni singolo frame

% Regioni finali
regioniOut = regioni;

end
