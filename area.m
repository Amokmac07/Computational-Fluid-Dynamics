function [Area,l,h]= area(P_ext,P_int,n)
ext = calculate_polygon_area(P_ext(1,:), P_ext(2,:));
if ~isempty(P_int)
    int=calculate_polygon_area(P_int(1,:), P_int(2,:));
    Area=ext-int;
else
    Area =ext;
end
                                      %input the number of nodes
l=sqrt(Area/((sqrt(3)/4)*n));                 % side of equilateral tariangles
l=round(l,2);
% l=0.6;
h=sqrt(3)*l/2;                               % height of triangle
end
function a = calculate_polygon_area(x, y)
    % Shoelace formula for calculating area of a polygon
    a = abs(sum(x .* circshift(y, 1)) - sum(y .* circshift(x, 1))) / 2;
end