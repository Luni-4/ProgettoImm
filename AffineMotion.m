function AffineMotion(u,v, prima)

% Funzione che identifica i diversi layer di movimento per ciascuna coppia
% di frame presenti nella sequenza video. Nei commenti relativi a questa
% funzione, la parola regioni si riferisce alle regioni 20x20 calcolate
% inizialmente, mentre layer di movimento alle successive regioni calcolate

% Variabile che conta il numero di iterazioni fatte dal ciclo while per
% individuare tutti i possibili layer di movimento
iterazione=0; 

% Il flusso ottico associato ai primi 2 frame della sequenza video e, solo
% alla prima iterazione del ciclo while, viene suddiviso in regioni
% non sovrapposte di dimensioni 20x20 (per le altre coppie di frame della sequenza la variabile prima viene
% posta a 0)
if iterazione == 0 %&& prima == true
    [regioni, numregioni] = Image20x20Subdivider(u);
end

figure(3);

%subplot(5,5,1);
%imshow(img1,[]);
%subplot(5,5,2);
%imshow(img2,[]);

subplot(5,5,1);
imshow(regioni,[]);

while iterazione < 20 % Ciclo while viene eseguito fino ad un numero di iterazioni tale da consentire di poter 
    % individuare tutti i layer di movimento presenti 
    
    % Inizializzazione del contatore che valuta il tempo di esecuzione
    % delle istruzioni contenute nel ciclo while per ogni iterazione
    tic;
    
    % Matrice che salva i parametri affini e la regione alla quale sono associati 
    affini = zeros(numregioni,7);
    % Array che salva il flusso ottico calcolato usando i parametri affini
    % delle x (ax0, axx, axy)   
    uStimato=u; 
    % Array che salva il flusso ottico calcolato usando i parametri affini
    % delle y (ay0, ayx, ayy)
    vStimato=v; 
    
    % Viene impostata soglia per l'eliminazione delle regioni che hanno un
    % errore residuo troppo alto, le ipotesi associate a queste regioni non forniscono una
    % buona descrizione del movimento e devono essere eliminate
    % per facilitare l'operazione di clustering    
    threshold=1; 
    
    % Il ciclo itera sui layer di movimento e le regioni calcolando le ipotesi di movimento 
    % con i relativi parametri affini
    for i=1:numregioni
        % Vengono salvati gli indici delle righe nell'array xt e quelli delle colonne in yt
        [xt,yt] = find(regioni == i);
        % Viene invocata funzione affine
        [Axi, Ayi, uS, vS] = affine(u(regioni==i),v(regioni==i),xt,yt);
        % Viene salvato il flusso ottico calcolato usando i parametri affini lungo le x 
        uStimato(regioni == i)= uS;
        % Viene salvato il flusso ottico calcolato usando i parametri affini lungo le y
        vStimato(regioni == i)= vS;
        % Funzione che calcola errore residuo, se valore restituito è pari
        % a 1, i parametri affini calcolati vengono salvati con realtiva
        % regione/ layer di movimento alla quale sono associati      
        if errorStima(u(regioni==i),v(regioni==i),uS,vS,threshold) == 1
            affini(i, 1:3) = Axi';  % Salvataggio dei parametri affini delle x
            affini(i, 4:6) = Ayi'; % Salvataggio dei parametri affini della y
            affini(i,7) = i; % Salvataggio della regione a cui sono associati
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
              k = ceil(size(affini,1)/2);
            
    %
    %         % O si sceglie k usando la media del numero di parametri affini
    %         %k = floor(mean(1:size(affini,1)));
    %
            pass = affini(1:k, 1:6);
            [indx, cc] = kmeans(affini(:,1:6),[], 'EmptyAction','singleton',  'Start',pass);
    %        %[indx, cc] = kmeans(affini(:,1:6),k);
    %
    %Threshold-Based Clustering Algorithm
    %th = 0.2;
    %[cc] = thresholdClustering(affini,th);
    
    
    %Assegnameno regioni a cluster più vicino
    [regioni,distanza] = assegnaCluster(u, v,cc,regioni);
    
    
    % Elimino pixel con errore troppo alto da regioni
    % th rappresenta errore massimo
    th=1;
    regioni = residualError(regioni,distanza,th);
    
    % Separo le regioni non connesse
    regioni = separaRegioni(regioni);
    
    % Elimino regioni troppo piccole
    [regioni, numregioni] = filtroRegioni(regioni);
    
    % Incremento Contatore
    iterazione = iterazione +1;
    
    toc;
    
    % Mostro risultato iterazione
    %figure(1);
    subplot(5,5,iterazione+1);
    imshow(regioni,[]);
    title(['Iterazione ', num2str(iterazione),', cluster: ',num2str(numregioni),'.']);
    
    
end % Fine iterazioni singolo frame

end
