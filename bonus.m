function [] = bonus()
    clc;
    close all;
    success = mexMTF2('init','pipeline v img_source f')
    [~, first_frame] = mexMTF2('get_frame');
    figure;
    imshow(first_frame);
    hold on
    [x,y]=ginput(4);
    p1 = [x(1) y(1)];
    p2 = [x(2) y(2)];
    p3 = [x(3) y(3)];
    p4 = [x(4) y(4)];
    plot([p1(1) p2(1)], [p1(2) p2(2)], 'r');
    plot([p2(1) p3(1)], [p2(2) p3(2)], 'r');
    plot([p3(1) p4(1)], [p3(2) p4(2)], 'r');
    plot([p4(1) p1(1)], [p4(2) p1(2)], 'r');
    plot([p3(1) p1(1)], [p3(2) p1(2)], 'b');
    plot([p4(1) p2(1)], [p4(2) p2(2)], 'b');
    close all;
    tracker = mexMTF2('create_tracker','mtf_sm esm mtf_am ssd mtf_ssm 6', cat(2,x,y)');
    while true
        [~, current_frame] = mexMTF2('get_frame');
        [~, corners] = mexMTF2('get_region', tracker);
        x1 = corners(1, :);
        y1 = corners(2,:);
        [a,b] = caclcenter(x1, y1);
        H = homography(x,y,x1,y1);
        [newX, newY] = getnewcord(a,b,H);
        drawhomographyregion(current_frame, newX, newY, a, b, x1, y1);
%         disp("x")
%         disp(a)
%         disp(newX)
%         disp("y")
%         disp(b)
%         disp(newY)
%         [p1,p2,p3,p4] = getpoint(x1, y1);
%         image(current_frame)
%         [a1,b1]=getnewcord(p1(1), p1(2), H);
%         disp(a1)
%         disp(b1)
% %         drawhomographyregion(current_frame, a1, b1, p1(1), p1(2));
%         [a2,b2]=getnewcord(p2(1), p2(2), H);
%         disp(a2)
%         disp(b2) 
%         drawhomographyregion(current_frame, a2, b2, p2(1), p2(2));
%         [a3,b3]=getnewcord(p3(1), p3(2), H);
%         disp(a3)
%         disp(b3)
% %         drawhomographyregion(current_frame, a3, b3, p3(1), p3(2));
%         [a4,b4]=getnewcord(p4(1), p4(2), H);
%         disp(a4)
%         disp(b4)
%         drawhomographyregion(current_frame, a4, b4, p4(1), p4(2));
        x = x1;
        y = y1;
    end
end

function [newX, newY] = getnewcord(a,b,H)
    new = [a b 1]*H;
    newX = new(1)/new(3);
    newY = new(2)/new(3);

end
function [] = drawhomographyregion(image, x,y, x1,y1, cordx, cordy)
%     [p1,p2,p3,p4] = getpoint(cordx, cordy);
    subplot(2,2,1);
    imshow(image);
    hold on;
%     rect=rectangle('Position',[a,b,c, d],'Edgecolor', 'r');
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


