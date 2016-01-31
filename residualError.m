function [newRegioni] = residualError(newRegioni,distanza,th)

  % Se non viene restituito nessun valore di th, imposto ad 1 
  if nargin<3
    th =1;
  end

  % Elimino valori supperiori distanza th
  newRegioni(distanza>=th) = 0;
  
    % Riordino la numerazione delle regioni prima kmeans
    vecchiValori = unique(newRegioni);
    for i=0:(size(vecchiValori,1))-1

        newRegioni(newRegioni == vecchiValori(i+1,1)) = i;
    end
    
  
%   %Preparo matrici per errore
%   sz = size(newRegioni);
%   errX = zeros(sz);
%   errY = errX;
%   
%   %Calcolo errore 
%   for i=1:size(newAffiniX,1)
%       errX(newRegioni==i) = u(newRegioni==i)-uStimato(i);
%       errY(newRegioni==i) = v(newRegioni==i)-vStimato(i);
%   end
%   
% %   err = (errX+errY)./2;
%   
%   %Se errore troppo grande, elimino pixel da regione
%   daScartareX = errX>=1;
%   daScartareY = errY>=1;
%     
%   %Aggiorno regioni
%   newRegioni(daScartareX) = 0;
%   newRegioni(daScartareY) = 0;
  
    
end