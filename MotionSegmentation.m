% Nome del file video che si vuole creare/aprire
filename = 'prova.avi';

% Se non esiste il video formato dalla sequenza di immagini, crearlo
if ~exist(filename,'file')
    createVideo(filename);
end

% Apertura video in lettura
video = VideoReader(filename);

% Definizione di flusso ottico usando Lucas-Kanadae e impostazione soglia
% di noise
opticFlow = opticalFlowLK('NoiseThreshold', 0.0039);

% Lettura primo frame viene posta fuori dal ciclo per evitare che
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

% Ciclare finché non ci sono più frame disponibili
while hasFrame(video)
    
    % Lettura del frame corrente del video
    frameRGBCurrent = readFrame(video);
    
    % Conversione frame corrente in scala di grigio
    frameGrayCurrent = rgb2gray(frameRGBCurrent);
    
    % Calcolo del flusso ottico tra frame corrente e frame precedente
    flow = estimateFlow(opticFlow, frameGrayCurrent);
    figure(1);
    imshow(frameGrayCurrent,[]);
    figure(2);
    plot(flow);
    %quiver(flow.Vx,flow.Vy);   
   
     % Modelli di movimento calcolati da funzione AffineMotion
     %AffineMotion(flow.Vx,flow.Vy, prima);     
    
    % Finita prima iterazione, variabile logica prima viene posta a false    
    prima = false;
    
    % Salvataggio frame corrente da usare in iterazione successiva per
    % funzione di warping
    framePrevious = frameGrayCurrent;    
end