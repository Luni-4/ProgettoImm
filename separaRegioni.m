function nuoveRegioni = separaRegioni(vecchieRegioni)

% Funzione usata per separare le regioni/layer di movimento tra loro non connessi. Restituisce 
% una nuova immagine, contentente le regioni/layer di movimento che sono
% stati separati, assegnado a ciascuno di loro nuove label

% Definizione della matrice che conterrà i nuovi layer
nuoveRegioni = zeros(size(vecchieRegioni));

% Contatore layer
nRegioni = 1;

% Trovare layer esistenti prima della loro separazione.
reg = unique(vecchieRegioni);

% Il layer formato da tutti i pixel aventi errore residuo troppo alto non
% viene considerato
reg=reg(2:size(reg,1));

% Scorrimento di tutti i layer trovati 
for i=1:numel(reg)
    
    % Ogni layer viene suddiviso da bwlable
    label = bwlabel(vecchieRegioni == reg(i));
    
    % Trovare sottoregioni
    reg1 = unique(label);
    
    % Eliminare sottoregione composta dai pixel degli altri layer
    reg1=reg1(2:size(reg1,1));
    
    for k=1:numel(reg1)
        % Inserire i layer che sono stati separati come nuovi layer
        nuoveRegioni(label == reg1(k)) = nRegioni;
        
        % Aumentare contatore
        nRegioni = nRegioni + 1;
    end
    
end

end