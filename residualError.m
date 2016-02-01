function newRegioni = residualError(regioni,distanza,th)
  regioni(distanza > th) = 0; 
  newRegioni = regioni;
end