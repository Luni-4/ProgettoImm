    % Caricamento dei frame
    img1 = imread('images/cars1_01.jpg');
    img2 = imread('images/cars1_02.jpg');
    
    % Riduzione di 1/4 per fattori computazionali
    %resize = 1;   
   % img1 = imresize(img1, resize);
    %img2 = imresize(img2, resize);
    
    % Trasformazione in scala di grigio e a valori double per poter essere forniti in input
    % al calcolatore di flusso ottico
    img1 = double(rgb2gray(img1));
    img2 = double(rgb2gray(img2));
    
    % Funzione che calcola flusso ottico tra 2 immagini e restituisce
    % derivata lungo le x,y e tempo più vettori di flusso ottico   
    
    [Ix,Iy,It,u,v] = Optflow(img1,img2);
    
    
    %Suddivisione di flusso ottico in regioni 20x20    
    [regioni, numregioni] = Image20x20Subdivider(u); 
    
    
   
   
   
    
    %for i=1:numel(uReg)
       %Funzione che calcola i parametri affini e i vettori di flusso
       %affine 
       %[affineRegX{i},affineRegY{i},uS{i},vS{i}]= affine(uReg{i},vReg{i}); 
       % Funzione che calcola errore nei parametri affini appena calcolati 
      %[uS{i},vS{i}] = errorStima(uReg{i},vReg{i},uS{i},vS{i},threshold);
   % end
    
    affiniX=zeros(numregioni,3);
    affiniY=zeros(numregioni,3);
    uStimato=u;
    vStimato=v;
    
    threshold=0.002; %impostare soglia per eliminazione di valori troppo alti
    for i=1:numregioni
        [xt,yt]=find(regioni == i);
        [Axi, Ayi, uS, vS] = affine(u(regioni==i),v(regioni==i),xt,yt);
        uStimato(regioni == i)=uS;
        vStimato(regioni == i)=vS;
        errorStima(u(regioni==i),v(regioni==i),uStimato(regioni == i),vStimato(regioni == i),threshold);
        affiniX(i,1:3)=Axi';
        affiniY(i,1:3)=Ayi';
       
    end  
    
     %Diplay il numero delle regioni
    %nr = numel(unique(regioni));
    %disp(['Il numero delle regioni prima k-menas è: ' num2str(nr) '.'] );
    
%     % Eliminarle dai vettori di flusso affini
%     affineRegX(eliminaCelle) = [ ];
%     affineRegY(eliminaCelle) = [ ];
    
    %kmeans
    % afc = kmean_adattivo_test(affineRegX,affineRegY,sizeX,sizeY);
     
     %Numero regioni dopo kmeans
     %nr = numel(unique(afc));
    % disp(['Il numero delle regioni dopo k-menas è: ' num2str(nr) '.'] );
     
    %% Mostro regioni dopo k means
    
   % i=1;
    %regioni_new = cell(size(uS,1), size(uS,2));
    %afc_v = afc(:);
    
   % while(i<=numel(afc_v))
        
     %   regioni_new{i,1} = afc_v(i,1)*ones(size(uReg{i,1},1),size(uReg{i,1},2)) ;
     %   i=i+1;
    
   % end
    
   % regioni_new = (regioni_new)';
    
    %regioni_new = reshape(regioni_new, [size(afc,1),size(afc,2)]);
    %regioni_new = cell2mat(regioni_new);
    
    %% Mostra a che punto siamo arrivati
   % figure(1);
    
    %subplot(2,2,1);
   % imshow(img1,[]);
    %title('Originale 1.')
         
    %subplot(2,2,2);
   % imshow(img2,[]);
    %title('Originale 2.')
    
   % subplot(2,2,3);
   % imshow(regioni,[]);
   % title('Regioni prima kmeans.');
    
   % subplot(2,2,4);
   % imshow(regioni_new,[]);
    %title('Regioni dopo kmeans.');