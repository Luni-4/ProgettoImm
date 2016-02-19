% File principale del progetto. Alla fine della sua esecuzione, saranno
% restituiti, sotto forma di immagini a livello di grigio, i layer di movimento
% trovati per ogni coppia di frame contenuta nella sequenza video
% considerata


% Utente sceglie se usare video esistente o crearne uno nuovo, partendo da
% una sequenza di immagini scelta
in = input('\nPer utilizzare video esistente(.avi), inserire 1.\nPer creare video a partire da frame separati, inserire 2.\n');

% Se il valore contenuto nella variabile in è uguale a 1, utente sceglie
% quale video caricare. Se il valore è pari a 2, video viene creato da
% sequenza di immagini. Se il valore inserito è un altro, viene invocato
% errore
if (in == 1)
    % Funzione uigetfile restituisce, per il video scelto, filename e
    % percorso
    [filename, pathname] = uigetfile( {'*.avi'},'Scegli un video:');
    
elseif (in == 2)
    % Viene invocata funzione createVideo
    filename = createVideo;
    pathname = 'videos/';
    
else
    error('Inserire un valore valido.');
    
end

% Apertura del file video in lettura
video = VideoReader([pathname,filename]);

% opticFlow definisce la struttura usata per il calcolo del flusso ottico usando il metodo Lucas-Kanadae
% Viene impostata una soglia di noise per evitare di considerare piccoli
% movimenti, non esistenti nelle coppie di frame analizzate, ma introdotti dal noise 
opticFlow = opticalFlowLK('NoiseThreshold',0.0001);

% Lettura primo frame viclearene posta fuori dal ciclo per evitare che
% AffineMotion calcoli layer tra primo frame e frame precedente (immagine
% nera) aggiunta da implementazione del Lucas-Kanadae

% Lettura del primo frame del video
frameRGBCurrent = readFrame(video);

% Conversione del primo frame in scala di grigio
frameGrayCurrent = rgb2gray(frameRGBCurrent);

% Calcolo del flusso ottico tra primo frame e frame precedente (immagine
% nera)
flow = estimateFlow(opticFlow, frameGrayCurrent);

% Variabile booleana usata per fare in modo che la funzione AffineMotion suddivida il flusso ottico, calcolato
% tra il primo e il secondo frame del video, in regioni non sovrapposte di
% dimensioni 20x20. Alla fine della prima iterazione, viene posta a
% false
prima = true;

% Contatore frame
frame = 1;

% Ciclare finché non ci sono più frame disponibili
while hasFrame(video)
    
    % Lettura del frame corrente del video
    frameRGBCurrent = readFrame(video);
    
    % Conversione frame corrente in scala di grigio
    frameGrayCurrent = rgb2gray(frameRGBCurrent);
    
    % Calcolo del flusso ottico tra frame corrente e frame precedente
    flow = estimateFlow(opticFlow, frameGrayCurrent);
    
    % Possibilità di stampare il flusso ottico per ogni iterazione
    %         figure(1);
    %         imshow(frameGrayCurrent,[]);
    %         figure(1);
    %         subplot(5,5,frame);
    %         flows = opticalFlow(flipud(flow.Vx),flipud(flow.Vy));
    %         plot(flows, 'DecimationFactor',[1 1],'ScaleFactor', 1);
    
    % Se si è alla prima iterazione, regioniIn è un array vuoto
    if prima == true;
        regioniIn = [];
        
    end
    
     % Calcolo dei layer di movimento per ciascuna coppia di frame della sequenza invocando AffineMotion
     % Vengono passati in input i flussi ottici calcolati precedentemente,
     % per le x e le y, la variabile prima e la matrice contenente i layer
     % di movimento trovati all'iterazione precedente. 
     % Il primo valore restituito contiene i layer di movimento calcolati
     % per la coppia di frame considerata, il secondo valore le regioni
    [regioniOut, regioniIn] = AffineMotion(flow.Vx, flow.Vy, prima, regioniIn);   

    
    % Se non esiste la directory per il
    %salvataggio dei layer di movimento, crearla
    if ~exist(['output/', filename],'dir')
        mkdir(['output/',filename]);
    end
    
    % I layer di movimento vengono normalizzati (livellì di intensità
    % compresi tra 0 e 1). Procedimento fatto per facilitare il salvataggio
    regioniNorm =regioniOut/max(abs(regioniOut(:)));
    
    % Ad ogni iterazione, vengono salvate le immagini in formato png contenenti i layer di movimento, per ciascuna coppia di frame considerata 
    % Il filename è strutturato in maniera tale che si possa individuare a
    % quale coppia ci si riferisce e il numero di layers individuati
    imwrite(regioniNorm, ['output/cats01/Frame ', num2str(frame), '-',num2str(frame+1),' (Cluster=', num2str(numel(unique(regioniOut))),  ').png'],'png');
   
    % Incrementare il contatore dei frame
    frame = frame +1;
    
    % Variabile prima viene posta a false    
    prima = false;
    
    % Segnale sonoro che identifica la fine dell'iterazione
    beep;
end
 % Segnale sonoro che identifica la fine dell'esecuzione del processo
beep;