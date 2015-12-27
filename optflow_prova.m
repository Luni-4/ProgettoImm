 % Load the frames that will be interpolated.
    img1 = imread('images/frame01.jpg');
    img2 = imread('images/frame05.jpg');
    
    % For computational efficiency, we may resize the frames before
    % computing optical flow and performing frame interpolation.
    resize = 0.25;    
    if resize ~= 1
        img1 = imresize(img1, resize);
        img2 = imresize(img2, resize);
    end
    
    img1 = double(rgb2gray(img1));
    img2 = double(rgb2gray(img2));
    
    b = [-1 8 0 -8 1 ]/12;
   Ix=filter(b,1,img1);
   m=b';
   Iy=filter(m,1,img1);
   It=img1-img2;
   iso=[1 4 6 4 1]/16;
   Ix=filter(iso,1,Ix);
   Iy=filter(iso,1,Iy);
   It=filter(iso,1,It);
   
   
optical_flow = vision.OpticalFlow(...
    'Method', 'Lucas-Kanade', ...
    'OutputValue', 'Horizontal and vertical components in complex form', ...
    'ReferenceFrameSource', 'Input port');

flow = step(optical_flow, img1, img2);
%flow = double(flow);
u = real(flow);
v = imag(flow);
res=(Ix.*u)./Iy-(It./Iy);