function [] = superimpose()
    clc;
    close all;
    image1 = imread('key1.jpg');
    image2 = imread('key3.jpg');
%     figure(1)
%     imshow(image2)
    figure(2)
    imshow(image1)
    [x,y]=ginput(4)
    bw = poly2mask(x,y, size(image2,1), size(image2,2))
    wb = imcomplement(bw);
    disp(size(image2(bw ~= 0)))
%     image2(bw ~= 0) = image1(bw ~= 0);
    r = image2(:,:,1);
    g = image2(:,:,2);
    b = image2(:,:,3);
    r(bw ~= 0) = image1(bw ~= 0);
    g(bw ~= 0) = image1(bw ~= 0);
    b(bw ~= 0) = image1(bw ~= 0);
    image2(:,:,1) = r;
    image2(:,:,2) = g;
    image2(:,:,3) = b;
    imshow(image2)
end
