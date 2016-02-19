function [regioniOut,regioniErr] =  AffineMotion(u,v, prima, regioniIn)

% Funzione che identifica i diversi layer di movimento per ciascuna coppia
% di frame presenti nella sequenza video. Nei commenti relativi a questa
% funzione, la parola regioni si riferisce alle regioni 20x20 calcolate
% inizialmente, mentre layer di movimento alle successive regioni calcolate

% Variabile che conta il numero di iterazioni fatte dal ciclo while per
% individuare tutti i possibili layer di movimento
iterazione=1;

% Se si è alla prima iterazione e si stanno analizzando i primi due frame
% della sequenza, il flusso ottico viene suddiviso in regioni di dimensione
% 20x20. Altrimenti, vengono utilizzati i layer di movimento, alla quale sono stati totli i pixel con errore
% elevato, della coppia di frame analizzati precedentemente
if prima == true
    [regioni, numregioni] = Image20x20Subdivider(u);
else
    regioni = regioniIn;
    % Trovare numero di layer di movimento contenuti in regioniIn
    numregioni = numel(unique(regioniIn));
end


% Il ciclo while sottostante viene eseguito per un numero di iterazioni tale da consentire di poter 
% individuare tutti i layer di movimento presenti 
while (true)
    
    % Inizializzazione del contatore che valuta il tempo di esecuzione
    % delle istruzioni contenute nel ciclo while per ogni iterazione
    tic;
    
    % Matrice che salva i parametri affini e la regione alla quale sono associati 
    affini = zeros(numregioni,7); 
    
    % Array che salva il flusso ottico calcolato usando i parametri affini
    % per le x (ax0, axx, axy)   
    uStimato=u; 
    
    % Array che salva il flusso ottico calcolato usando i parametri affini
    % per le y (ay0, ayx, ayy)
    vStimato=v; 
    
    % Viene impostata soglia per l'eliminazione delle regioni/layer di movimento che hanno un
    % errore residuo troppo alto, le ipotesi associate a queste regioni non forniscono una
    % buona descrizione del movimento e devono essere eliminate
    % per facilitare l'operazione di clustering    
    threshold=1; 
    
    % Il ciclo itera sui layer di movimento/regioni calcolando le ipotesi di movimento 
    % con i relativi parametri affini
    for i=1:numregioni
        % Per ogni regione/layer di movimento vengono salvati gli indici delle righe nell'array xt e quelli delle colonne in yt
        [xt,yt]=find(regioni == i);
        % Viene invocata funzione affine
        [Axi, Ayi, uS, vS] = affine(u(regioni==i),v(regioni==i),xt,yt);
        % Viene salvato il flusso ottico calcolato usando i parametri affini per le x 
        uStimato(regioni == i)= uS;
        % Viene salvato il flusso ottico calcolato usando i parametri affini per le y
        vStimato(regioni == i)= vS;
        
        % Funzione che calcola errore residuo, se valore restituito è pari
        % a 1, i parametri affini calcolati vengono salvati con relativa
        % regione/ layer di movimento alla quale sono associati      
        if errorStima(u(regioni==i),v(regioni==i),uS,vS,threshold) == 1
            affini(i, 1:3) = Axi';  % Salvataggio dei parametri affini per le x
            affini(i, 4:6) = Ayi'; % Salvataggio dei parametri affini per le y
            affini(i,7) = i; % Salvataggio della regione/layer di movimento a cui sono associati
        end
    end
    
    
    %Eliminazione dall'array affini i parametri affini che non hanno
    %superato la soglia di threshold
    affini((affini(:,7) ==0),:) = [];
    
    
    %     %Kmenas classico
    %     % nCentri rappresenta il numero di cluster resistuiti
    %     % nCentri = input('Inserite il numero di regioni da trovare: ');
    %     nCentri =  10;
    %     cc = kmeansClassico(affini,nCentri);
    %
    
    %         %Kmeans adattivo
    %         % Th rappresenta distanza massima tra centri(0.75)
    %         th=0.75;
    %         [cc]= kmean_adattivo(affini,th);
    
    %         %Kmeans di matlab
    %
    %         % O si sceglie k usando sempre la metà dei parametri affini
    %         % disponibili
    %     if(size(affini,1))>10
    %         k = 10;
    %     else
    %         k = size(affini,1);
    %     end;
    
    %
    %         % O si sceglie k usando la media del numero di parametri affini
    %         %k = floor(mean(1:size(affini,1)));
    %
    %     pass = affini(1:k, 1:6);
    %     [indx, cc] = kmeans(affini(:,1:6),[], 'EmptyAction','singleton',  'Start',pass);
    %[indx, cc] = kmeans(affini(:,1:6),k);
    %     %
    
    % Valore di threshold per algoritmo clustering, il cui valore dipende
    % fortemente da video in analisi
    th = 0.05;
    
    %Threshold-Based Clustering Algorithm
    [cc] = thresholdClustering(affini,th);
    
    
    %Assegnameno regioni a cluster più vicino
    [regioni,distanza] = assegnaCluster(u, v,cc,regioni);
    
    
    
    % Elimino pixel con errore troppo alto da regioni
    % th rappresenta errore massimo
    th= 1;
    regioniErr = residualError(regioni,distanza,th);
    
    
    % Controllo sul numero delle iterazioni del calcolo affine motion
    % I valori max di iterazioni sono trovati euristicamente
    if (prima== true && iterazione > 5) || (prima== false && iterazione > 2)
        disp(iterazione);
        toc;
        break;
    end
    
    
    % Separazione regioni non connesse
    regioni = separaRegioni(regioniErr);
    
    % Eliminazione regioni troppo piccole
    [regioni, numregioni] = filtroRegioni(regioni);
    
    disp(iterazione);
    
    toc;
    
    % Mostro risultato iterazione
    %     figure(2);
    %     subplot(5,5,iterazione+1);
    %     imshow(regioni,[]);
    %     title(['Iterazione ', num2str(iterazione),', cluster: ',num2str(numregioni),'.']);
    
    % Incremento Contatore
    iterazione = iterazione +1;
    
    
end % Fine iterazioni singolo frame

% Regioni finali
regioniOut = regioni;

end
