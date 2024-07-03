clear all;clc;
x_exterior = [2, 3, 4, 5, 5.5, 6,7,8.5,9,7.5,6,5,4,3,2,1.5,1,0.5,1,2];
y_exterior= [1, 1, 2, 3, 3.5, 3,2.5,3.5,5.5,6.2,6.5,6.2,5.5,4.5,5,5.5,5,3.5,2,1];
x_interior=[];
y_interior=[];
% x_interior=[7 8 8 7 7];
% y_interior=[4 4 5 5 4];
% x_exterior=[11,10.924,10.698,10.33,9.83,9.214,8.5,7.71,6.868,6,5.132,4.29,3.5,2.786,2.17,1.67,1.302,1.076,...
%       1,1.076,1.302,1.67,2.17,2.786,3.5,4.29,5.132,6,6.868,7.71,8.5,9.214,9.83,10.33,10.698,10.924,11];
% y_exterior = [7,7.868,8.71,9.5,10.214,10.83,11.33,11.698,11.924,12,11.924,11.698,11.33,10.83,10.214,9.5,...
%    8.71,7.868,7,6.132,5.29,4.5,3.786,3.17,2.67,2.302,2.076,2,2.076,2.302,2.67,3.17,3.786,4.5,5.29,6.132,7];
% x_interior=[5 7 7 5 5];
% y_interior=[6 6 8 8 6];
% x_exterior=[1 2 2 1 1];
% y_exterior = [1 1 2 2 1];
% x_interior = [1.25 1.75 1.75 1.25 1.25]; % Specify interior boundary x-coordinates
% y_interior = [1.25 1.25 1.75 1.75 1.25];
% l=0.3;
n=100;

%% Boundary Generation and Nodalization
[P_ext,P_int] = boundary_generation(x_exterior,x_interior,y_exterior,y_interior);
[area,l,h]= area(P_ext,P_int,n);
%%
figure;
[x_nodes_exterior,y_nodes_exterior,x_nodes_interior,y_nodes_interior]=boundary_nodalization(P_ext,P_int,l);

%%
figure;
[int_node_x,int_node_y]=interior_nodalization(x_nodes_exterior, y_nodes_exterior, x_nodes_interior, y_nodes_interior,l);
hold on;
plot( P_ext(1,:), P_ext(2,:), 'b-', 'LineWidth', 2);
if ~isempty(x_interior)
    plot(P_int(1,:), P_int(2,:), 'b-', 'LineWidth', 2)
end
%% Advancing Front Method
AFM(x_exterior,y_exterior,x_interior,y_interior,l)
title("AFM Triangulation");
%% Delaunay Triangulation
[P,C]=Delaunay(x_exterior,y_exterior,x_interior,y_interior,l);
