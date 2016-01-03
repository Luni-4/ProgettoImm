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
    imgReg = Image20x20Subdivider(img1);
    uReg = Image20x20Subdivider(u);
    vReg = Image20x20Subdivider(v);    
    
    affineRegX = cell(size(imgReg,1),size(imgReg,2));
    affineRegY = cell(size(imgReg,1),size(imgReg,2));
    soglia=1; m=0;
    for i=1:size(imgReg,1)
        for j=1:size(imgReg,2)
            m=m+1;
            [Hyi,Hxi]= affine(imgReg{i,j},u,v,size(imgReg,2),soglia,m);
            affineRegX{i,j}=Hxi;
            affineRegY{i,j}=Hyi;                     
        end
    soglia=soglia+1;
    end   
    
    affineRegX1 = cell(size(imgReg,1),size(imgReg,2));
    affineRegY1 = cell(size(imgReg,1),size(imgReg,2));   
    for i=1:size(imgReg,1)
        for j=1:size(imgReg,2)          
            [Hyi,Hxi]= affine1(imgReg{i,j},uReg{i,j},vReg{i,j});
            affineRegX1{i,j}=Hxi;
            affineRegY1{i,j}=Hyi;                     
        end
    end     