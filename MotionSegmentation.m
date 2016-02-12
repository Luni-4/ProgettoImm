% Nome e formato del video che si vuole creare/aprire
filename = 'prova.avi';

% Se il video composto dalla sequenza di immagini di partenza non esiste,
% crearlo
if ~exist(filename,'file')
    createVideo(filename);
end

% Apertura video in lettura
video = VideoReader(filename);

% Definizione del flusso ottico usando Lucas-Kanadae e impostazione soglia
% di noise
opticFlow = opticalFlowLK('NoiseThreshold', 0.0080);

% La lettura del primo frame viene posta fuori dal ciclo per evitare che
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

% Ciclare fino all'ultimo frame della sequenza video 
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
    
    % Visualizzazione del flusso ottico
    flows = opticalFlow(flipud(flow.Vx),flipud(flow.Vy)); 
    plot(flows, 'DecimationFactor',[1 1],'ScaleFactor', 1);     
   
     % Calcolo dei layer di movimento per ciascuna coppia di frame della sequenza invocando AffineMotion
     AffineMotion(flow.Vx,flow.Vy, prima);     
    
    % Dopo il calcolo dei layer di movimento associati alla prima coppia di frame della sequenza, variabile logica prima viene posta a false    
    prima = false;    
     
end