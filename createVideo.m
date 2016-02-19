function filename = createVideo

%
if nargin<1
    filename = input('\nInserisci nome video: ','s');
end

% Funzione per la scelta della serie di immagini
imgnames = pickImages();

if ~iscell(imgnames)
    error('Inserire delle immagini');
end

% Creazione video, specificando filename e formato di compressione
video = VideoWriter(['videos/',filename],'Uncompressed AVI');

% Apertura del file video in scrittura
open(video);

% Lettura prima immagine della sequenza
img = imread(imgnames{1});

% Estrazione delle dimensioni
dimX= size(img,1);
dimY = size(img,2);

% Scrittura della prima immagine nel video
writeVideo(video,img);

for i=2:size(imgnames,2)
    
    % Lettura della i-esima immagine nell' array di celle
    img = imread(imgnames{i});
    
    % Aggiunta di immagini al video solo se hanno stessa dimensione
    if size(img,1) == dimX && size(img,2) == dimY
        writeVideo(video,img);
    end
end

% Chiusura file video in scrittura
close(video);

filename = [filename, '.avi'];
end