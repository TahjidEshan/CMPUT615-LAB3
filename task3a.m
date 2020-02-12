function [] = task3a(numpoints)
     if ~exist('numpoints','var')
          numpoints = 4;
     elseif numpoints<4
           numpoints = 4; 
     end
    clc;
    close all;
%     image = imread('img2.png');
%     image1 = imread('img1.png');
    image = imread('key1.jpg');
    image1 = imread('key3.jpg');
    figure(1);
    imshow(image);
    image_gray = rgb2gray(image1);
    [rows cols] = size(image_gray);
    w = rows;
    h = cols;
    [x,y]=ginput(numpoints);
    figure(2);
    imshow(image1);
    [x1,y1]=ginput(numpoints);
    A = zeros(numpoints*2,9);
    Tnorm = inv([w+h 0 w/2; 0 w+h h/2; 0 0 1]);
    disp(Tnorm)
    for i=1:numpoints
        A(2*i, :) = [x(i),y(i), 1,0,0,0,-x(i)*x1(i), -x1(i)*y(i), -x1(i)];
        A(2*i-1, :) = [0,0,0,x(i), y(i),1,-x(i)*y1(i), -y1(i)*y(i), -y1(1)];
    end

    [~,~,V] = svd(A);
    h = V(:,9);
    h1 = reshape(h,3,3);
%     h1 = [h(1) h(2) h(3); h(4) h(5) h(6); h(7) h(8) h(9);];
    disp(h1);
    t = projective2d(h1);
    disp(t);
    imout = imwarp(image, t, 'OutputView',imref2d(size(image)));
    figure(3);
    imshow(imout);
    
    
end


