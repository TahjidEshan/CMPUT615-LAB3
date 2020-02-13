function [] = task3normalized(numpoints)
     if ~exist('numpoints','var')
          numpoints = 4;
     elseif numpoints<4
           numpoints = 4; 
     end
    clc;
    close all;
    image = imread('key1.jpg');
    image1 = imread('key3.jpg');
    figure(1);
    imshow(image);
    [x,y]=ginput(numpoints);
    Tnorm = Tnorm(image);
%     disp(x)
    X = [x'; y'; 1 1 1 1;];
    disp(X')
    disp(X'*Tnorm)
    figure(2);
    imshow(image1);
    [x1,y1]=ginput(numpoints);

    A = zeros(numpoints*2,9);
    for i=1:numpoints
        A(2*i, :) = [x(i),y(i), 1,0,0,0,-x(i)*x1(i), -x1(i)*y(i), -x1(i)];
        A(2*i-1, :) = [0,0,0,x(i), y(i),1,-x(i)*y1(i), -y1(i)*y(i), -y1(1)];
    end

    [~,~,V] = svd(A);
    h = V(:,9);
    h1 = reshape(h,3,3);
    disp(h1)
    t = projective2d(h1);
    imout = imwarp(image, t, 'OutputView',imref2d(size(image)));
    figure(3);
    imshow(imout, []);    
end

function [Tnorm] = Tnorm(image)
w = size(image,1);
h = size(image,2);
Tnorm = [ w+h 0 w/2; 
          0 w+h h/2;
          0  0   1;
         ];
end

function [x, y] = getcoord(A)
x = [];
y = [];
for i = 1:4
    
end

end