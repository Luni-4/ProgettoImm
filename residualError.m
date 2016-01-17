function [newRegioni] = residualError(newRegioni,newAffiniX,newAffiniY,u,v)

  %Trovo valori u e v delle regioni
  uStimato = (sum(newAffiniX(:,1:3),2));
  vStimato = (sum(newAffiniY(:,1:3),2));
  
  %Preparo matrici per errore
  sz = size(newRegioni);
  errX = zeros(sz);
  errY = errX;
  
  %Calcolo errore 
  for i=1:size(newAffiniX,1)
      errX(newRegioni==i) = u(newRegioni==i)-uStimato(i);
      errY(newRegioni==i) = v(newRegioni==i)-vStimato(i);
  end
  
%   err = (errX+errY)./2;
  
  %Se errore troppo grande, elimino pixel da regione
  daScartareX = errX>=1;
  daScartareY = errY>=1;
    
  %Aggiorno regioni
  newRegioni(daScartareX) = 0;
  newRegioni(daScartareY) = 0;
  
    
end