function [regioni, numregioni] = Image20x20Subdivider(img)
%% Funzione per la suddivisione dell'immagine di partenza in blocchi 20x20

%Recupero dimensioni dell'immagine da analizzare
[sizeX, sizeY] = size(img);

%Controllo in quanti blocchi posso dividere; se non multiplo di 20,
%l'ultimo riga e/o colonna avrà dimensioni differenti da 20x20
numXblocks = sizeX/20;
numYblocks = sizeY/20; 

%Creo le due matrici per definire il numero di blocchi da 20x20 necessari per le righe e le colonne, 
%da passare a mat2cell
dimXblock = ones(floor(numXblocks),1)*20;
dimYblock = ones(1,floor(numYblocks))*20;

%Se dimensioni immagine immgagine non multiplo di 20, ci sarà un ultima
%riga e/o colonna più piccola alla fine
if (round(numXblocks)~=numXblocks)
    dimXblock(end+ 1, 1) =  (numXblocks - floor(numXblocks))*20 ;
end

if (round(numYblocks)~=numYblocks)
    dimYblock(1, end+ 1) =  (numYblocks - floor(numYblocks))*20 ;
end

% Vettorializzo
X = dimXblock(:);
Y = dimYblock(:);

% Suddivido l'immagine in blocchi 20x20, tranne un ipotetica ultima righa o
% colonna
ImageBlocks = mat2cell(img,round(X),round(Y));

% Creazione ground truth della suddivisione in regioni
ImageBlocks_v = ImageBlocks';
ImageBlocks_v = ImageBlocks_v(:);

for i=1:size(ImageBlocks_v,1)    
    ImageBlocks_v{i} = (ImageBlocks_v{i}.*0)+i;        
end
numregioni=size(ImageBlocks_v,1);
% Ricostruzione dell'immagine partendo dalle celle  in ImageBlocks_v
ImageBlocks_v=reshape(ImageBlocks_v,[size(ImageBlocks,2),size(ImageBlocks,1)]);
regioni = cell2mat(ImageBlocks_v);
regioni=regioni';
