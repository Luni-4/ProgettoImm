function filename = createVideo

% La funzione crea un video partendo da una sequenza di immagini scelte da
% utente

% Utente inserisce nome del video che vuole creare
filename = input('\nInserisci nome video: ','s');

% Se utente non inserisce nessun filename, funzione restituisce errore
if isempty(filename)
    error('Deve essere scelto un filename per il video');
end


% Viene invocata la funzione pickImages, permette ad un utente di scegliere la sequenza
% di immagini
imgnames = pickImages();

% Se imgnames non è un array di celle, perché utente non ha inserito
% nessuna immagine, funzione restituisce errore
if ~iscell(imgnames)
    error('Inserire delle immagini');
end

% Creazione del video, specificando filename e formato di compressione
video = VideoWriter(['videos/',filename],'Uncompressed AVI');

% Apertura del file video in scrittura
open(video);

% Lettura prima immagine della sequenza
img = imread(imgnames{1});

% Dimensioni dell'immagine di partenza
dimX= size(img,1);
dimY = size(img,2);

% Scrittura della prima immagine all'interno del file video
writeVideo(video,img);

% Ciclo effettuato sul resto delle immagini della sequenza
for i=2:size(imgnames,2)
    
    % Lettura della i-esima immagine, contenuta nell'array di celle
    % imgnames
    img = imread(imgnames{i});
    
    %  Le immagini sono aggiunte al video solo se hanno la stessa dimensione
    if size(img,1) == dimX && size(img,2) == dimY
        writeVideo(video,img);
    end
end

% Chiusura del file video in scrittura
close(video);

% La varaibile restituita dalla funzione contiene il filename scelto da utente e
% come estensione il formato di compressione 
filename = [filename, '.avi'];
end