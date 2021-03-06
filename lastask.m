function [] = lastask()
    clc;
    close all;
    success = mexMTF2('init','pipeline v img_source f')
    [~, first_frame] = mexMTF2('get_frame');
    template = imresize(imread('img2.png'), [size(first_frame,1) size(first_frame,2)]);
    figure(1);
    imshow(first_frame);
    [x,y]=ginput(4);
    figure(2);
    imshow(template);
    [tx, ty] = ginput(4);
    H = homography( tx,ty, x,y);
    t =  projective2d(H);
    newimage = imwarp(template, t, 'OutputView',imref2d(size(first_frame)));
    bw = poly2mask(x,y, size(newimage,1), size(newimage,2));
    r = first_frame(:,:,1);
    g = first_frame(:,:,2);
    b = first_frame(:,:,3);
    r(bw ~= 0) = newimage(bw ~= 0);
    g(bw ~= 0) = newimage(bw ~= 0);
    b(bw ~= 0) = newimage(bw ~= 0);
    first_frame(:,:,1) = r;
    first_frame(:,:,2) = g;
    first_frame(:,:,3) = b;
    figure(3);
    hold on
    imshow(first_frame)
    
    tracker = mexMTF2('create_tracker','mtf_sm esm mtf_am ssd mtf_ssm 6', cat(2,x,y)');

    while true
        [~, current_frame] = mexMTF2('get_frame');
        [~, corners] = mexMTF2('get_region', tracker);
        x1 = corners(1, :);
        y1 = corners(2,:);
        H = homography( tx, ty, x1,y1);
        t = projective2d(H);
        newimage = imwarp(template, t, 'OutputView',imref2d(size(current_frame)));
        bw = poly2mask(x1,y1, size(newimage,1), size(newimage,2));
        r = current_frame(:,:,1);
        g = current_frame(:,:,2);
        b = current_frame(:,:,3);
        r(bw ~= 0) = newimage(bw ~= 0);
        g(bw ~= 0) = newimage(bw ~= 0);
        b(bw ~= 0) = newimage(bw ~= 0);
        current_frame(:,:,1) = r;
        current_frame(:,:,2) = g;
        current_frame(:,:,3) = b;
        imshow(current_frame);
        disp('Go')
    end
end

function [newX, newY] = getnewcord(a,b,H)
    new = [a b 1]*H;
    newX = new(1)/new(3);
    newY = new(2)/new(3);

end
function [] = drawhomographyregion(image, x,y, x1,y1, cordx, cordy)
    subplot(2,2,1);
    imshow(image);
    hold on;
    plot(x, y,'x','LineWidth',2,'Color','yellow');
    plot(x1, y1,'x','LineWidth',2,'Color','red');
    drawnow;
    hold off;
    
    mask = poly2mask(cordx, cordy, size(image,1), size(image,2))
    subplot(2,2,1);
    imshow(mask)
end
function [p1,p2,p3,p4] = getpoint(x,y)
    p1 = [x(1) y(1) 1];
    p2 = [x(2) y(2) 1];
    p3 = [x(3) y(3) 1];
    p4 = [x(4) y(4) 1];
end
function [x, y] = caclcenter(x,y)
    [p1, p2, p3, p4] = getpoint(x,y);
    l1 = cross(p1, p3);
    l2 = cross(p2,p4);
    pm = cross(l1, l2);
    x = pm(1)/pm(3);
    y = pm(2)/pm(3);
end


function [H] = homography(x, y, x1, y1)
    numpoints = 4;
    A = zeros(numpoints*2,9);
    for i=1:numpoints
        A(2*i, :) = [x(i),y(i), 1,0,0,0,-x(i)*x1(i), -x1(i)*y(i), -x1(i)];
        A(2*i-1, :) = [0,0,0,x(i), y(i),1,-x(i)*y1(i), -y1(i)*y(i), -y1(1)];
    end

    [~,~,V] = svd(A);
    h = V(:,9);
    H = reshape(h,3,3);
    
end

% function [image] = imresize(inputImage, rows, cols)
%     scale = [rows cols];              %# The resolution scale factors: [rows columns]
%     oldSize = size(inputImage);                   %# Get the size of your image
%     newSize = max(floor(scale.*oldSize(1:2)),1);  %# Compute the new image size
% 
%     %# Compute an upsampled set of indices:
% 
%     rowIndex = min(round(((1:newSize(1))-0.5)./scale(1)+0.5),oldSize(1));
%     colIndex = min(round(((1:newSize(2))-0.5)./scale(2)+0.5),oldSize(2));
% 
%     %# Index old image to get new image:
% 
%     outputImage = inputImage(rowIndex,colIndex,:);
% end
