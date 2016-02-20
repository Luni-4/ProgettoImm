function nuoveRegioni = separaRegioni(vecchieRegioni)

% Funzione per la separazione delle regioni tra loro non connesse, che
% restituisce una nuova immagine formata dalle nuove regioni separate e con
% nuove lable.

% Definizione di matrice che conterrà nuove regioni
nuoveRegioni = zeros(size(vecchieRegioni));

%Contatore regioni
nRegioni = 1;

% Trovare regioni esistenti prima della loro separazione se non connesse.
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