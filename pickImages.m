function imagename = pickImages()

    % Titolo di interfccia grafica
    title = 'Scegli la serie di immagini da usare per creare video';

    % Tipi di file che funzione può aprire
    type = {'*.jpg;*.JPG;*.jpeg;*.png;*.PNG',...
            'All image files (*.jpg;*.jpeg;*.png)'
            '*.jpg;*.JPG;*.jpeg', 'JPEG files (*.jpg;*.jpeg)';      
            '*.png;*.PNG', 'PNG files (*.png)'};


    % Scegliere la serie di immagini che comporranno il video
    [imagename, path] = uigetfile(type, title, 'MultiSelect', 'on');
    
    % Controllare se sono state selezionate immagini
    if iscell(imagename)
        % Crea array di celle che contiene, per ogni immagine, percorso e nomefile
        for i=1:size(imagename,2)
            imagename{i} = [path imagename{i}];
        end
    end
     

end
