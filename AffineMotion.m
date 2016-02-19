function [regioniOut,regioniErr] =  AffineMotion(u,v, prima, regioniIn)

%Variabile che salva numero di iterazioni compiute su frame
iterazione=1;

% Suddivisione di flusso ottico in regioni
% Se siamo alla prima iterazione tra i primi due frame, l'immagine viene
% suddivisa in blocchi 20x20.
if prima == true
    [regioni, numregioni] = Image20x20Subdivider(u);
else
    regioni = regioniIn;
    numregioni = numel(unique(regioniIn));
end

% figure(3);

%subplot(5,5,1);
%imshow(img1,[]);
%subplot(5,5,2);
%imshow(img2,[]);

% subplot(5,5,1);
% imshow(regioni,[]);

% Ciclare fino ad un numero euristico di iterazioni
while (true)
    
    % Durata esecuzione ciclo
    tic;
    
    affini = zeros(numregioni,7); %Matrice usata per salvare parametri affini e regione ad essi associata
    uStimato=u; %Vettore usato per salvare flusso ottico stimato lungo le x
    vStimato=v; %Vettore usato per salvare flusso stimato lungo le y
    
    threshold=1; %impostare soglia per eliminazione di valori troppo alti
    for i=1:numregioni
        [xt,yt]=find(regioni == i);
        [Axi, Ayi, uS, vS] = affine(u(regioni==i),v(regioni==i),xt,yt);
        uStimato(regioni == i)= uS;
        vStimato(regioni == i)= vS;
        if errorStima(u(regioni==i),v(regioni==i),uS,vS,threshold) == 1
            affini(i, 1:3) = Axi';  % Salvataggio dei parametri affini delle x
            affini(i, 4:6) = Ayi'; % Salvataggio dei parametri affini della y
            affini(i,7) = i; % Salvataggio della regione a cui sono associati
        end
    end
    
    
    %Eliminazione di valori affini che non hanno superato la soglia
    affini((affini(:,7) ==0),:) = [];
    
    
    %     %Kmenas classico
    %     % nCentri rappresenta il numero di cluster resistuiti
    %     % nCentri = input('Inserite il numero di regioni da trovare: ');
    %     nCentri =  10;
    %     cc = kmeansClassico(affini,nCentri);
    %
    
    %         %Kmeans adattivo
    %         % Th rappresenta distanza massima tra centri(0.75)
    %         th=0.75;
    %         [cc]= kmean_adattivo(affini,th);
    
    %         %Kmeans di matlab
    %
    %         % O si sceglie k usando sempre la metà dei parametri affini
    %         % disponibili
    %     if(size(affini,1))>10
    %         k = 10;
    %     else
    %         k = size(affini,1);
    %     end;
    
    %
    %         % O si sceglie k usando la media del numero di parametri affini
    %         %k = floor(mean(1:size(affini,1)));
    %
    %     pass = affini(1:k, 1:6);
    %     [indx, cc] = kmeans(affini(:,1:6),[], 'EmptyAction','singleton',  'Start',pass);
    %[indx, cc] = kmeans(affini(:,1:6),k);
    %     %
    
    % Valore di threshold per algoritmo clustering, il cui valore dipende
    % fortemente da video in analisi
    th = 0.05;
    
    %Threshold-Based Clustering Algorithm
    [cc] = thresholdClustering(affini,th);
    
    
    %Assegnameno regioni a cluster più vicino
    [regioni,distanza] = assegnaCluster(u, v,cc,regioni);
    
    
    
    % Elimino pixel con errore troppo alto da regioni
    % th rappresenta errore massimo
    th= 1;
    regioniErr = residualError(regioni,distanza,th);
    
    
    % Controllo sul numero delle iterazioni del calcolo affine motion
    % I valori max di iterazioni sono trovati euristicamente
    if (prima== true && iterazione > 5) || (prima== false && iterazione > 2)
        disp(iterazione);
        toc;
        break;
    end
    
    
    % Separazione regioni non connesse
    regioni = separaRegioni(regioniErr);
    
    % Eliminazione regioni troppo piccole
    [regioni, numregioni] = filtroRegioni(regioni);
    
    disp(iterazione);
    
    toc;
    
    % Mostro risultato iterazione
    %     figure(2);
    %     subplot(5,5,iterazione+1);
    %     imshow(regioni,[]);
    %     title(['Iterazione ', num2str(iterazione),', cluster: ',num2str(numregioni),'.']);
    
    % Incremento Contatore
    iterazione = iterazione +1;
    
    
end % Fine iterazioni singolo frame

% Regioni finali
regioniOut = regioni;

end
