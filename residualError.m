function newRegioni = residualError(newRegioni,distanza,th)
  % Elimino valori supperiori distanza th
  newRegioni(distanza >= th) = 0;    
end