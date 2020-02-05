function [] = task2()
    clc;
    close all;
    image = imread('football_field.jpg');
    imshow(image);
    hold on
    [x,y]=ginput(4);
    p1 = [x(1) y(1) 1];
    p2 = [x(2) y(2) 1];
    p3 = [x(3) y(3) 1];
    p4 = [x(4) y(4) 1];
    plot([p1(1) p2(1)], [p1(2) p2(2)], 'r');
    plot([p2(1) p3(1)], [p2(2) p3(2)], 'r');
    plot([p3(1) p4(1)], [p3(2) p4(2)], 'r');
    plot([p4(1) p1(1)], [p4(2) p1(2)], 'r');
    plot([p3(1) p1(1)], [p3(2) p1(2)], 'b');
    plot([p4(1) p2(1)], [p4(2) p2(2)], 'b');
    l1 = cross(p1, p3);
    l2 = cross(p2,p4);
    l3 = cross(p1, p2);
    l4 = cross(p3,p4);
    pm = cross(l1, l2);
    pinf = cross(l3, l4);
    lm = cross(pm, pinf);
    plot(pm(1)/pm(3), pm(2)/pm(3),'x','LineWidth',2,'Color','yellow');
    plot(pinf(1)/pinf(3), pinf(2)/pinf(3),'x','LineWidth',2,'Color','yellow');
    plot([pinf(1)/pinf(3) p1(1)], [pinf(2)/pinf(3) p1(2)], 'b');
    plot([pinf(1)/pinf(3) p4(1)], [pinf(2)/pinf(3) p4(2)], 'b');
    plot([pinf(1)/pinf(3) pm(1)/pm(3)], [pinf(2)/pinf(3) pm(2)/pm(3)], 'b');
    drawnow;
    hold off;
end


