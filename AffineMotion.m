function AffineMotion(u,v, prima)

iterazione=0; %Variabile che salva numero di iterazioni compiute su frame

%Suddivisione di flusso ottico in regioni
if iterazione == 0 %&& prima == true
    [regioni, numregioni] = Image20x20Subdivider(u);
end

figure(3);

%subplot(5,5,1);
%imshow(img1,[]);
%subplot(5,5,2);
%imshow(img2,[]);

subplot(5,5,1);
imshow(regioni,[]);

while iterazione < 20 % Ciclare fino ad un numero euristico di iterazioni
    
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
              k = ceil(size(affini,1)/2);
            
    %
    %         % O si sceglie k usando la media del numero di parametri affini
    %         %k = floor(mean(1:size(affini,1)));
    %
            pass = affini(1:k, 1:6);
            [indx, cc] = kmeans(affini(:,1:6),[], 'EmptyAction','singleton',  'Start',pass);
    %        %[indx, cc] = kmeans(affini(:,1:6),k);
    %
    %Threshold-Based Clustering Algorithm
    %th = 0.2;
    %[cc] = thresholdClustering(affini,th);
    
    
    %Assegnameno regioni a cluster più vicino
    [regioni,distanza] = assegnaCluster(u, v,cc,regioni);
    
    
    % Elimino pixel con errore troppo alto da regioni
    % th rappresenta errore massimo
    th=1;
    regioni = residualError(regioni,distanza,th);
    
    % Separo le regioni non connesse
    regioni = separaRegioni(regioni);
    
    % Elimino regioni troppo piccole
    [regioni, numregioni] = filtroRegioni(regioni);
    
    % Incremento Contatore
    iterazione = iterazione +1;
    
    toc;
    
    % Mostro risultato iterazione
    %figure(1);
    subplot(5,5,iterazione+1);
    imshow(regioni,[]);
    title(['Iterazione ', num2str(iterazione),', cluster: ',num2str(numregioni),'.']);
    
    
end % Fine iterazioni singolo frame

end
