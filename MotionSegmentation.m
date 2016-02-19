% Utente sceglie se usare video esistente o crearlo da frame separati
in = input('\nPer utilizzare video esistente(.avi), inserire 1.\nPer creare video a partire da frame separati, inserire 2.\n');

if (in == 1)
    [filename, pathname] = uigetfile( {'*.avi'},'Scegli un video:');
    
elseif (in == 2)
    
    filename = createVideo;
    pathname = 'videos/';
    
else
    error('Inserire un valore valido.');
    
end

%% Inserimento parametri di treshold specifici per ogni video
% Fare riferimento a tabella documentazione per valori consigliati
% thLK = input('Inserire il parametro di treshold per Lucas-Kanade\n(Per valori consigliati fare riferimeno tabella documentazione.)\n');
%
% if thLK>0
%
% else
%     error('Inserire un valore maggiore di 0.')
% end
%
% thKmeans = input('Inserire il parametro di treshold per Lucas-Kanade\n(Per valori consigliati fare riferimeno tabella documentazione.)\n');
%
% if thKmeans>0
%
% else
%     error('Inserire un valore maggiore di 0.')
% end

%%

% Nome del file video che si vuole creare/aprire
% filename = 'videos/cats01.avi';

% Se non esiste il video formato dalla sequenza di immagini, crearlo
% if ~exist(filename,'file')
%     createVideo(filename);
% end

% Apertura video in lettura
video = VideoReader([pathname,filename]);

% Definizione di flusso ottico usando Lucas-Kanadae e impostazione soglia
% di noise
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

% Salvataggio frame corrente da usare in iterazione successiva per
% funzione di warping
framePrevious = frameGrayCurrent;

%Variabile che definisce se è prima iterazione AffineMotion sui due frame
%iniziali
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
    %         figure(1);
    %         imshow(frameGrayCurrent,[]);
    %         figure(1);
    %         subplot(5,5,frame);
    %         flows = opticalFlow(flipud(flow.Vx),flipud(flow.Vy));
    %         plot(flows, 'DecimationFactor',[1 1],'ScaleFactor', 1);
    
    if prima == true;
        regioniIn = [];
        
    end
    
    % Modelli di movimento calcolati da funzione AffineMotion
    [regioniOut, regioniIn] = AffineMotion(flow.Vx, flow.Vy, prima, regioniIn);
    
    
    % Finita prima iterazione, variabile logica prima viene posta a false
    prima = false;
    
    %Salvataggio delle regioni
    if ~exist(['output/', filename],'dir')
        mkdir(['output/',filename]);
    end
    regioniNorm =regioniOut/max(abs(regioniOut(:)));
    imwrite(regioniNorm, ['output/cats01/Frame ', num2str(frame), '-',num2str(frame+1),' (Cluster=', num2str(numel(unique(regioniOut))),  ').png'],'png');
    frame = frame +1;
    
    beep;
    
    
    %     % Salvataggio frame corrente da usare in iterazione successiva per
    %     % funzione di warping
    %     regioniIn = regioniOut;
end

beep;