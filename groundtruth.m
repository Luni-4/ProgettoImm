%function [matrice, accuracy] = groundtruth()  
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
    if numel(img1) == 1 || numel(img2) == 1
        error('Bisogna caricare entrambe le immagini');
    end

    % Caricamento immagini
    img1 = imread([filenameimg1 img1]);
    img2 = imread([filenameimg2 img2]);

    % Convertire a livelli di grigio
    img1 = 255 * mat2gray(img1);
    img2 = 255 * mat2gray(img2);

    % Trovare regioni ground truth
    val = unique(img2);

    % Trovare regioni layer
    valer= unique(img1);
    
    %for i=1:numel(valer)           
      %      subplot(6,6,i);
           %imshow(img1 == valer(i),[]); 
      % end    
     
     % Numero di regioni rilevanti (tolti gli 0) in ground truth
     n = (size(val,1)-1);

    % Definire matrice che contiene layer che hanno in comune pixels con
    % i layer dei ground truth
    livelli = zeros(size(img2,1),size(img2,2),n);

   for lt=1:n

        currentLayergt = img2 == val(lt+1);      

        for i=1:numel(valer)
            prova = img1 == valer(i);
            giro = and(prova, currentLayergt);
            %giro = sum(sum(giro));
           if sum(sum(giro)) ~= 0
               livelli(:,:,lt) = (~livelli(:,:,lt) | prova);
           end
            %subplot(6,6,i);
            %imshow(img1 == valer(i),[]); 
       end    
          
   end
   
   %Stampare i livelli finali
   figure(1);
   imshow(livelli(:,:,1),[]);
   figure(2);
   imshow(livelli(:,:,2),[]);
   
   % Matrice che salva TP, TN, FP, FN
   matrice = zeros(2,2,n);
   accuracy = zeros(1,1,n);
   
   for i=1:n
       matrice(1,1,i) = sum(sum(livelli(:,:,1) & img2 == val(i+1)));
       matrice(1,2,i) = sum(sum(livelli(:,:,1) & ~(img2 == val(i+1))));
       matrice(2,1,i) = sum(sum((~livelli(:,:,1)) & ~(img2 == val(i+1))));
       matrice(2,2,i) = sum(sum((~livelli(:,:,1)) & ~(img2 == val(i+1))));
       accuracy(1,1,i) = sum(matrice(1,1:2,i))/sum(sum(matrice(:,:,i)));
   end   
  
   
%end
   
   