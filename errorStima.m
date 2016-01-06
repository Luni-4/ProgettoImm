function [regX, regY] = errorStima(uReg,vReg,uS,vS,th)
magnitudeR =  hypot(uReg,vReg);
magnitudeRS = hypot(uS,vS);
sigma=(sum(sum((magnitudeR-magnitudeRS).^2)))/numel(uReg);
if sigma <= th
    regX=uS;
    regY=vS;
else
    regX=[];
    regY=[];
end

end