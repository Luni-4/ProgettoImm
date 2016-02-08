%function [matrice, sensitivity, specificity, precision, accuracy] = GroundTruth()  

% Per ogni layer presente nel GT, funzione restituisce matrice di
% confusione, valore di sensitività, specificità, precisione e accuratezza

% Tipi di file apribili
    type = {'*.jpg;*.JPG;*.jpeg;*.png;*.PNG',...
                'All image files (*.jpg;*.jpeg;*.png)'
                '*.jpg;*.JPG;*.jpeg', 'JPEG files (*.jpg;*.jpeg)';      
                '*.png;*.PNG', 'PNG files (*.png)'};

    % Scelta di layer da confrontare
    [img1, filenameimg1] =  uigetfile(type, 'Selezionare layer da confrontare');

    % Scelta di ground truth

    [img2, filenameimg2] = uigetfile('*.pgm;*.PGM;*.ppm;*.PPM', 'Selezionare ground truth');

    % Devono essere caricate entrambe le immagini
    if numel(filenameimg1) == 1 || numel(filenameimg2) == 1
        error('Bisogna caricare entrambe le immagini');
    end   
 

    % Caricamento immagini
    img1 = imread([filenameimg1 img1]);
    img2 = imread([filenameimg2 img2]);

    % Convertire a livelli di grigio e binarizzare immagine principale
    img1 = 255 * mat2gray(img1);
    img2 = 255 * mat2gray(img2);   

    % Trovare quanti layers sono contenuti nel ground truth
    val = unique(img2);
    
    % Non contare lo sfondo, di colore bianco o nero, nel calcolo dei
    % layers
    if mode(img2) == 255
        val(end) = [];
    else
        val(1) = [];
    end    

    % Trovare da quanti layers è composta immagine da confrontare
    valer = unique(img1);
    
   %for i=1:numel(valer)           
            %subplot(6,6,i);
           %imshow(img1 == valer(i),[]); 
          
   %end    
     
     % Numero di layers del ground truth
     n = size(val,1);

    % Definire matrice che contiene layer che hanno in comune pixels con
    % i layer dei ground truth
    livelli = zeros(size(img2,1),size(img2,2),n);
    
  
   % Ogni iterazione corrisponde a un layer del ground truth, si trovano i layer dell immagine che hanno in comune
   % almeno un pixel con il layer del ground truth considerato. Il
   % risultato finale, salvato nella matrice tridimensionale livelli, conterrà il
   % i layer che non hanno nulla a che fare con il layer del
   % ground truth considerato (saranno scartati successivamente)
   for lt=1:n       
        currentLayergt = img2 == val(lt);      

        for i=1:numel(valer)
            prova = img1 == valer(i);          
            giro = and(prova, currentLayergt);          
           if sum(sum(giro)) ~= 0              
               livelli(:,:,lt) = (livelli(:,:,lt) + prova);
           end           
       end    
          
   end
   
  
   
   %figure(1); 
  % imshow(livelli(:,:,1),[]);
   %img3 = im2bw(img1);
   % figure(1); 
 % imshow(img3,[]);
 % figure(2);
 % ris = ~(img3 - livelli(:,:,1));
 % imshow(ris,[]);
   
 
   % Matrice che salva TP, TN, FP, FN per ogni livello GT
   matrice = zeros(2,2,n);   
   
   % Vettore contenente sensitivity per ogni livello GT
   sensitivity = zeros(1,n);
   
   % Vettore contenente specificità per ogni livello GT
   specificity = zeros(1,n);   
   
   % Vettore contenente precisione per ogni livello GT
   precision = zeros(1,n);
   
   % Vettore contenente accuratezza per ogni livello GT
   accuracy = zeros(1,n);
   
   % Immagine principale viene binarizzata per permettere confronto
   img3 = im2bw(img1);
   
   for i=1:n
       % Facendo differenza tra immagine originale e
       % elementi non appartenenti a layer ground truth considerato, si trova risultato finale 
       % Il risultato finale viene infine negato
       livelli(:,:,i) =  ~(img3 - livelli(:,:,i));
       
       % Calcolo di matrice di confusione per ogni livello
       matrice(1,1,i) = sum(sum(livelli(:,:,i) & img2 == val(i)));
       matrice(1,2,i) = sum(sum(livelli(:,:,i) & ~(img2 == val(i))));
       matrice(2,1,i) = sum(sum((~livelli(:,:,i)) & (img2 == val(i))));
       matrice(2,2,i) = sum(sum((~livelli(:,:,i)) & ~(img2 == val(i)))); 
       
       % Calcolare valori
       sensitivity(1,i) = matrice(1,1,i)/(matrice(1,1,i)+matrice(2,2,i));
       specificity(1,i) = matrice(1,2,i)/(matrice(1,2,i)+matrice(2,1,i));
       precision(1,i) = matrice(1,1,i)/(matrice(1,1,i)+matrice(2,1,i));
       accuracy(1,i) = sum(matrice(1,1:2,i))/sum(sum(matrice(:,:,i)));
   end   
  
   
%end