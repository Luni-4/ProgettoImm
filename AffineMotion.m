%function AffineMotion(u,v)
    % Caricamento dei frame
    img1 = imread('images/cars1_05.jpg');
    img2 = imread('images/cars1_06.jpg');
    
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
    
    [u,v] = Optflow(img1,img2); 

    
    iterazione=0; %Variabile che salva numero di iterazioni compiute su frame
    
    %while iterazione <= 20 % Ciclare fino ad un numero euristico di iterazioni
    
        %Suddivisione di flusso ottico in regioni   
        if iterazione == 0
            [regioni, numregioni] = Image20x20Subdivider(u);
        end
             


        affiniX=zeros(numregioni,4); %Matrice usata per salvare parametri affini x e regione associata
        affiniY=zeros(numregioni,4); %Matrice usata per salvare parametri affini y e regione associata
        uStimato=u; %Vettore usato per salvare flusso ottico stimato lungo le x
        vStimato=v; %Vettore usato per salvare flusso stimato lungo le y
        regioniScartateX=affiniX; %Matrice usata per salvare parametri affini scartati x e regione associata
        regioniScartateY=affiniY; %Matrice usata per salvare parametri affini scartati y e regione associata

        threshold=50; %impostare soglia per eliminazione di valori troppo alti
        for i=1:numregioni
            [xt,yt]=find(regioni == i);
            [Axi, Ayi, uS, vS] = affine(u(regioni==i),v(regioni==i),xt,yt);
            uStimato(regioni == i)=uS;
            vStimato(regioni == i)=vS;
            if errorStima(u(regioni==i),v(regioni==i),uS,vS,threshold) == 1
                  affiniX(i,1:3)=Axi'; % Salvataggio dei parametri affini delle x
                  affiniX(i,4)=i; % Salvataggio della regione          
                  affiniY(i,1:3)=Ayi'; % Salvataggio dei parametri affini della y
                  affiniY(i,4)=i;  
            else
                  regioniScartateX(i,1:3)=Axi'; % Salvataggio dei parametri affini delle x
                  regioniScartateX(i,4)=i; % Salvataggio della regione          
                  regioniScartateY(i,1:3)=Ayi'; % Salvataggio dei parametri affini della y
                  regioniScartateY(i,4)=i;  
                  regioni(regioni == i)=0; %Regioni scartate vengono poste al valore 0
            end

        end     


        %Eliminazione di valori affini che non hanno superato la soglia
        affiniX((affiniX(:,4)==0),:)=[];
        affiniY((affiniY(:,4)==0),:)=[];  

        %Ripulitura vettori delle regioni scartati
        regioniScartateX((regioniScartateX(:,4)==0),:)=[];
        regioniScartateY((regioniScartateY(:,4)==0),:)=[];    

        %Kmeans adattivo
        [ccp1,ccp2]= kmean_adattivo(affiniX,affiniY);
        
        %Assegnameno regioni a cluster più vicino
        [newAffiniX, newAffiniY, newRegioni] = assegnaCluster(affiniX, affiniY, ccp1,ccp2,regioni);

%         % Elimino pixel con errore troppo alto da regioni 
%         newRegioni = residualError(newRegioni,newAffiniX,newAffiniY,u,v);
        
        % Separo le regioni non connesse
        newRegioni_2 = separaRegioni(newRegioni);
        
        % Elimino regioni troppo piccole
        newRegioni_2 = filtroRegioni(newRegioni_2);
        
        
        subplot(2,2,1);
         imshow(img1,[]);
         title('Immagine partenza.'); 
        
        subplot(2,2,2);
         imshow(regioni,[]);
         title(['Prima kmeans, cluster= ', num2str(numel(unique(regioni))), '.']);
    
        subplot(2,2,3);
        imshow(newRegioni,[]);
        title(['Dopo kmeans, cluster= ', num2str(numel(unique(newRegioni))), '.']);
        
        subplot(2,2,4);
        imshow(newRegioni_2,[]);
        title(['Dopo separa regioni e filtro, cluster= ', num2str(numel(unique(newRegioni_2))), '.']);
 
    %end % Fine iterazioni singolo frame
%end