function [Hyi,Hxi] = affine(imgReg,uReg,vReg)
    sumr=0; 
    sumvx=0;
    sumvy=0;
    for x=1:size(imgReg,1)
        for y=1:size(imgReg,2)
            regressor = [1 x y]';
            sumr=sumr+(regressor*regressor');
            sumvx=sumvx+regressor*uReg(x,y
            sumvy=sumvy+regressor*vReg(x,y);
            
        end
    end
    sumr\sumvx;
    Hyi=sumvy/sumr;
    Hxi=sumvx/sumr;    
end