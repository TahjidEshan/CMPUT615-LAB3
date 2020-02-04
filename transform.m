function [] = transform(point, translation, rotation)
    Rz = [cos(rotation(1)) -sin(rotation(1)) 0; sin(rotation(1)) cos(rotation(1)) 0; 0 0 1];
    Ry = [cos(rotation(2)) 0 sin(rotation(2)); 0 1 0; -sin(rotation(2)) 0 cos(rotation(2))];
    Rx = [1 0 0; 0 cos(rotation(3)) -sin(rotation(3)); 0 sin(rotation(3)) cos(rotation(3))];
    R = Rz*Ry*Rx;
    T = translation';
%     disp(size(R))
%     disp(size(T))
    M = [R T; 0 0 0 1];
    disp(size(M))
    disp(size(point))
    disp(M*[point';1]);
end

%transform([10 10 10], [0 20 0], [30 -10 0]);