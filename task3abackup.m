function [] = task3abackup()
    clc;
    close all;
    image = imread('img1.png');
    image_gray = rgb2gray(image);
    image1 = imread('img2.png');
    image1_gray = rgb2gray(image1);
    [rows cols] = size(image_gray);
    x = (1:cols)';
    y = (1:rows)';
    figure(1);
    imshow(image);
    [x,y]=ginput(4);
    x1 = [x(1) y(1) 1;
          x(2) y(2) 1;
          x(3) y(3) 1;
          x(4) y(4) 1];
    figure(2);
    imshow(image1);
    [x_1,y_1]=ginput(4);
    x2 = [x_1(1) y_1(1) 1;
          x_1(2) y_1(2) 1;
          x_1(3) y_1(3) 1;
          x_1(4) y_1(4) 1];
    A = zeros(8,9);
    B = [];
    for i=1:4
        A(2*i, :) = [x(i),y(i), 1,0,0,0,-x(i)*x1(i), -x_1(i)*y(i), -x_1(i)];
        A(2*i-1, :) = [0,0,0,x(i), y(i),1,-x(i)*y_1(i), -y_1(i)*y(i), -y_1(1)];
        B= [0 -x2(i,3)*x1(i,1) x2(i,2)*x1(i,1); x2(i,3)*x1(i,1) 0 -x2(i,1)*x1(i,1); -x2(i,2)*x1(i,1) x2(i,1)*x1(i,1) 0;];
        disp(size(B))
    end
    disp(A)
    disp(B)
%     H = homography(x1, x2);
%     disp(H);
    
end

function [H] = homography(X1, X2)
    n = 4;
    C = [];
    for i=1:n
        x1 = X1(i,:)';
        x2 = X2(i,:)';
        x2_hat = skew(x2);
        a = kron(x1, x2_hat);
        C = [C; a']; 
    end
    [U,S,V] =svd(C);
    Hs = V(:,9);
    HL = reshape(Hs, 3,3);
    S = svd(HL);
    H = HL /S(2);
    fix = 0;
    for i=1:4
        test = X2(i, :)* H* X1(i,:)';
        if(test<0)
            fix = fix+1;
        end
    end
    if(fix == 4)
        H = -H;
    end
end
