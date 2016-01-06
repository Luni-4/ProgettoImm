 % Caricamento dei frame
    img1 = imread('images/frame01.png');
    img2 = imread('images/frame02.png');
    
    % Riduzione di 1/4 per fattori computazionali
    resize = 0.25;   
    img1 = imresize(img1, resize);
    img2 = imresize(img2, resize);
    
    % Trasformazione in scala di grigio e a valori double per poter essere forniti in input
    % al calcolatore di flusso ottico
    img1 = double(rgb2gray(img1));
    img2 = double(rgb2gray(img2));
    
    % Funzione che calcola flusso ottico tra 2 immagini e restituisce
    % derivata lungo le x,y e tempo più vettori di flusso ottico   
    
    [Ix,Iy,It,u,v] = Optflow(img1,img2);
    
    
    %Suddivisione di immagini in regioni 20x20    
    uReg = Image20x20Subdivider(u);
    vReg = Image20x20Subdivider(v);  
    

   affineRegX = cell(numel(uReg),1);
   affineRegY = cell(numel(uReg),1);
   uS=cell(numel(uReg),1);
   vS=cell(numel(uReg),1);
 
   uReg=uReg'; vReg=vReg';
   uReg=uReg(:); vReg=vReg(:);
   
   
   threshold=0.002;
   for i=1:numel(uReg)
       %Funzione che calcola i parametri affini e i vettori di flusso
       %affine 
       [affineRegX{i},affineRegY{i},uS{i},vS{i}]= affine(uReg{i},vReg{i});  
       [uS{i},vS{i}] = errorStima(uReg{i},vReg{i},uS{i},vS{i},threshold);
   end