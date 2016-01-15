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
opticFlow = opticalFlowLK('NoiseThreshold', 0.05);

% Ciclare finché non ci sono più frame disponibili
while hasFrame(video)
    % Lettura dei frame del video
    frameRGB = readFrame(video);
    
    % Conversione frame in scala di grigio
    frameGray = rgb2gray(frameRGB);
    
    % Calcolo del flusso ottico tra due frame
    flow = estimateFlow(opticFlow, frameGray);
    
    %AffineMotion(flow.Vx,flow.Vy);
    
end