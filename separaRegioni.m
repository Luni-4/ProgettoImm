function nuoveRegioni = separaRegioni(vecchieRegioni)
%Separa le regioni non adiacenti, e restituisce immagine con nuove label

% Definizione di matrice che conterrà nuove regioni
nuoveRegioni = zeros(size(vecchieRegioni));

%Contatore regioni
nRegioni = 1;

% Trovare regioni
reg = unique(vecchieRegioni);

% Eliminare regione contenente pixel scartati da analisi
reg=reg(2:size(reg,1));

for i=1:numel(reg)
    
    label = bwlabel(vecchieRegioni == reg(i));
    
    % Trovare sottoregioni
    reg1 = unique(label);
    
    % Eliminare sottoregione contenente pixel di altre regioni
    reg1=reg1(2:size(reg1,1));
    
    for k=1:numel(reg1)
        % Inserire le regioni separate come nuove regioni
        nuoveRegioni(label == reg1(k)) = nRegioni;
        
        % Aumentare contatore
        nRegioni = nRegioni+1;
    end
    
end

end