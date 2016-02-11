%function [matrice, sensitivity, specificity, precision, accuracy, numclust] = GroundTruth()  

% Funzione che restituisce, per ogni layer presente nel GT (Ground Truth), matrice di
% confusione, valore di sensitività, di specificità, di precisione, di
% accuratezza e il numero di cluster che si sovrappongono a quel GT

    % Selezionare tipi di file che funzione uigetfile può aprire
    type = {'*.jpg;*.JPG;*.jpeg;*.png;*.PNG',...
                'All image files (*.jpg;*.jpeg;*.png)'
                '*.jpg;*.JPG;*.jpeg', 'JPEG files (*.jpg;*.jpeg)';      
                '*.png;*.PNG', 'PNG files (*.png)'};

    % Scelta del layer di movimento da confrontare (img1 contiene filename immagine caricata,
    % filenameimg1 il suo path)
    [img1, filenameimg1] =  uigetfile(type, 'Selezionare layer da confrontare');

    % Scelta di ground truth (img2 contiene filename immagine caricata,
    % filenameimg2 il suo path)
    [img2, filenameimg2] = uigetfile('*.pgm;*.PGM;*.ppm;*.PPM', 'Selezionare ground truth');

    % Utilizzatore deve caricare immagine da confrontare e GT, altrimenti
    % funzione restituisce errore
    if numel(filenameimg1) == 1 || numel(filenameimg2) == 1
        error('Bisogna caricare entrambe le immagini');
    end   
 

    % Lettura di immagini inserite tramite le funzione uigetfile
    img1 = imread([filenameimg1 img1]);
    img2 = imread([filenameimg2 img2]);

    % Convertire immagini caricate in scala di grigio per mezzo di matgrey
    img1 = 255 * mat2gray(img1);
    img2 = 255 * mat2gray(img2);   

    % Numero di layers presenti nel GT caricato
    val = unique(img2);
    
    % Eliminare lo sfondo, sia che sia di colore bianco o nero, nel calcolo
    % del numero di layers del GT (mode trova il valore più alto
    % all'interno dell'immagine, essendo, in scala di grigio a 8 bit, 255 è
    % il valore più alto)
    if mode(img2) == 255
        val(end) = [];
    else
        val(1) = [];
    end    

    % Numero di layers presenti nel layer di movimento caricato
    valer = unique(img1);  
     
     % Salvare nella variabile n i layers del GT rimasti dopo eliminazione
     % dello sfondo
     n = size(val,1);

    % Definire matrice tridimensionale contenente le regioni del layer di movimento che
    % hanno almeno un pixel in comune con un determinato layer del GT
    livelli = zeros(size(img2,1),size(img2,2),n);
    
    % Array che salva il numero di cluster in comune con ciascun layer del GT
    numclust = zeros(1,n);
    
  
   % Ogni iterazione del ciclo for più esterno cicla su un
   % layer del GT, mentre ogni iterazione del ciclo più interno cicla su
   % ogni regione del layer di movimento. Se una regione ha almeno un pixel in comune con il layer del GT, 
   % la suddetta regione viene aggiunta alla matrice livelli. Quando il ciclo più interno terminerà, la matrice conterrà
   % le regioni che non appartengono al layer del GT, ovvero le uniche che
   % non verranno mai sommate
   for lt=1:n   % Ciclo for più esterno (cicla sui layer GT)
       
        currentLayergt = img2 == val(lt);   % Viene salavato il layer corrente del GT    

        for i=1:numel(valer) % Ciclo for più interno (cicla sulle regioni)
            currentLayer = img1 == valer(i); % Viene salvata la regione corrente che si sta analizzando          
            soluzione = and(currentLayer, currentLayergt);  % Eseguito end per vedere se si ha almeno un pixel in comune        
           if sum(sum(soluzione)) ~= 0  % Se si ha un pixel in comune            
               livelli(:,:,lt) = (livelli(:,:,lt) + currentLayer); % Sommare a matrice livelli il layer in comune
               numclust(1,lt) = numclust(1,lt) + 1; % Salvataggio del numero di cluster in comune con il livello del GT considerato
           end           
       end    
          
   end   
 
   % Matrice tridimensionale che salva TP, TN, FP, FN per ogni livello GT
   matrice = zeros(2,2,n);   
   
   % Array contenente sensitivity per ogni livello GT
   sensitivity = zeros(1,n);
   
   % Array contenente specificità per ogni livello GT
   specificity = zeros(1,n);   
   
   % Array contenente precisione per ogni livello GT
   precision = zeros(1,n);
   
   % Array contenente accuratezza per ogni livello GT
   accuracy = zeros(1,n);
   
   % Layer di movimento viene binarizzata per poter trovare le regioni
   % associate ad ogni layer del GT
   img3 = im2bw(img1);
   
   for i=1:n
       % Facendo differenza tra layer di movimento e
       % elementi non appartenenti al layer del GT considerato, salvati nella matrice livelli, si trova il risultato finale 
       % Il risultato finale viene infine negato per riportare i valori in
       % comune al valore binario di 1
       livelli(:,:,i) =  ~(img3 - livelli(:,:,i));
       
       % Calcolo di matrice di confusione per ogni livello
       matrice(1,1,i) = sum(sum(livelli(:,:,i) & img2 == val(i))); % Veri positivi sono elementi che sono posti a valore logico true sia nel layer di movimento sia in quello di GT
       matrice(1,2,i) = sum(sum(livelli(:,:,i) & ~(img2 == val(i)))); % Veri negativi sono gli elementi che sono posti a valore logico true in layer di movimento ma falsi in quello di GT
       matrice(2,1,i) = sum(sum((~livelli(:,:,i)) & ~(img2 == val(i)))); % Falsi positivi sono gli elementi che sono posti a valore logico false sia nel layer di movimento sia in quello di GT 
       matrice(2,2,i) = sum(sum((~livelli(:,:,i)) & (img2 == val(i)))); % Falsi negativi sono gli elementi che sono posti a valore logico false in layer di movimento ma veri in quello di GT
       
       % Calcolare valori di sensitività, specificità, precisione,
       % e accuratezza
       sensitivity(1,i) = matrice(1,1,i)/(matrice(1,1,i)+matrice(2,2,i));
       specificity(1,i) = matrice(1,2,i)/(matrice(1,2,i)+matrice(2,1,i));
       precision(1,i) = matrice(1,1,i)/(matrice(1,1,i)+matrice(2,1,i));
       accuracy(1,i) = sum(matrice(1,1:2,i))/sum(sum(matrice(:,:,i)));
   end   
  
   
%end