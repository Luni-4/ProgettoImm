 % Caricamento dei frame
    img1 = imread('images/frame01.png');
    img2 = imread('images/frame02.png');
    
    % Riduzione di 1/4 per fattori computazionali
    resize = 0.25;    
    if resize ~= 1
        img1 = imresize(img1, resize);
        img2 = imresize(img2, resize);
    end
    
    % Trasformazione in scala di grigio e a valori double per poter essere forniti in input
    % al calcolatore di flusso ottico
    img1 = double(rgb2gray(img1));
    img2 = double(rgb2gray(img2));
    
    %Definizione parametri Lucas-Kanade usando la libreria vision di Matlab
    optical_flow = vision.OpticalFlow(...
    'Method', 'Lucas-Kanade', ...
    'OutputValue', 'Horizontal and vertical components in complex form', ... %valor in output in forma complessa
    'ReferenceFrameSource', 'Input port'); %Usare come frame di riferimento un immagine in input

   
   % Kernel usato da Matlab per calcolo delle intensità lungo le x e y
   b = [-1 8 0 -8 1 ]/12; 
   
   % Convoluzione bidimensionale lungo le righe dell'immagine per trovare Ix
   Ix=conv2(img1,b,'same');  
   
   % Convoluzione bidimensionale lungo le colonne dell'immagine per trovare
   % Iy
   Iy=conv2(img1,b','same');  
   
   % Differenza tra pixel con stesse coordinate per trovare It
   It=img1-img2; 


% Calcolo del flusso ottico
flow = step(optical_flow, img1, img2);
% Estrazione di vettore ottico lungo le x
u = real(flow);
% Estrazione vettore ottico lungo le y
v = imag(flow);

res=(Ix.*u)+(Iy.*v)+It; %equazione di costanza della brightness
vi=-(Ix.*u)./Iy-It./Iy+res./Iy; %calcolo vettore di veloctà lungo colonne usando Ix e Iy calcolate precedentemente
diff=v-vi; %calcolo delle differenze tra vettore di flusso originale e quello calcolato