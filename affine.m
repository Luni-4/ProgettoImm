function [Hxi,Hyi] = affine(imgReg,uReg,vReg,sy,soglia,conto)
    sumr=0; 
    sumvx=0;
    sumvy=0;
    if conto <= soglia*sy
        rig=20*(soglia-1);
    end
    col=20*(mod((conto-1),sy));
    for x=1:size(imgReg,1)
        for y=1:size(imgReg,2)
            regressor = [1 x+rig y+col]';
            sumr=sumr+(regressor*regressor');
            sumvx=sumvx+regressor*uReg(x+rig,y+col);
            sumvy=sumvy+regressor*vReg(x+rig,y+col);            
        end
    end
    Hxi= sumr\sumvx;
    Hyi=sumr\sumvy;   
end


