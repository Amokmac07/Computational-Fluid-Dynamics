% clear all;clc;
% % x_exterior=[11,10.924,10.698,10.33,9.83,9.214,8.5,7.71,6.868,6,5.132,4.29,3.5,2.786,2.17,1.67,1.302,1.076,...
% %      1,1.076,1.302,1.67,2.17,2.786,3.5,4.29,5.132,6,6.868,7.71,8.5,9.214,9.83,10.33,10.698,10.924,11];
% % y_exterior = [7,7.868,8.71,9.5,10.214,10.83,11.33,11.698,11.924,12,11.924,11.698,11.33,10.83,10.214,9.5,...
% %     8.71,7.868,7,6.132,5.29,4.5,3.786,3.17,2.67,2.302,2.076,2,2.076,2.302,2.67,3.17,3.786,4.5,5.29,6.132,7];
% % 
% x_exterior=[1 2 2 1 1];
% y_exterior = [1 1 2 2 1];
% x_interior = [1.25 1.75 1.75 1.25 1.25]; % Specify interior boundary x-coordinates
% y_interior = [1.25 1.25 1.75 1.75 1.25];
%  % x_exterior=[2,3,4,5,5.5,6,7,8.5,9,7.5,6,5,4,3,2,1.5,1,0.5,1,2];
%  % y_exterior=[1,1,2,3,3.5,3,2.5,3.5,5.5,6.2,6.5,6.2,5.5,4.5,5,5.5,5,3.5,2,1];
% % x_interior = [1.25 1.75 1.75 1.25 1.25]; % Specify interior boundary x-coordinates
% % y_interior = [1.25 1.25 1.75 1.75 1.25];
% n=1000;

function [P,C]= Delaunay(x_exterior,y_exterior,x_interior,y_interior,l)
[P_ext,P_int] = boundary_generation(x_exterior,x_interior,y_exterior,y_interior);
% [area,l,h]= area(P_ext,P_int,n);
[x_nodes_exterior,y_nodes_exterior,x_nodes_interior,y_nodes_interior]=boundary_nodalization(P_ext,P_int,l);
hold on;
% interior_nodalization(x_nodes_exterior, y_nodes_exterior, x_nodes_interior, y_nodes_interior,l);
% % [intersection_points,c] = interior_generation(P_ext, P_int, h)
% % R = interior_nodalization(x_nodes_exterior, y_nodes_exterior, x_nodes_interior, y_nodes_interior,intersection_points, c, l)

[int_node_x,int_node_y]=interior_nodalization(x_nodes_exterior, y_nodes_exterior, x_nodes_interior, y_nodes_interior,l);

delaunay_x = [x_nodes_exterior(1:end-1),x_nodes_interior , int_node_x ]; %Last point is repeated to complete the cycle,
delaunay_y = [y_nodes_exterior(1:end-1),y_nodes_interior , int_node_y ];  % which is removed here
N_outer = numel(x_nodes_exterior)-1;  %After Mayank's compilation, replace x with the boundary nodes
%Edge Constraints %Inner refers to pit
C_outer = [(1:(N_outer-1))' (2:N_outer)'; N_outer 1]; %Boundary Constraint(See MATLAB Documentation)
P_outer = [x_nodes_exterior(1:end-1)',y_nodes_exterior(1:end-1)'] ; %Boundary Nodes
if numel(x_nodes_interior)>0
    N_inner = numel(x_nodes_interior)-1; %Same here for pit , replace x_internal with the boundary of internal
    C_inner = [((N_outer + 1): (N_outer + N_inner-1))' ,((N_outer + 2): (N_outer + N_inner))' ; N_outer + N_inner  ,N_outer+ 1 ];
    P_inner = [x_nodes_interior(1:end-1)',y_nodes_interior(1:end-1)'] ;%Pit

else
    N_inner=0;
    C_inner=[];
    P_inner=[];
end
P_interior_nodes = [int_node_x' ,int_node_y'];

C= [C_outer; C_inner];
P = [P_outer;P_inner;P_interior_nodes];
P=remove_duplicate_rows(P);
C=remove_duplicate_rows(C);
DT = delaunayTriangulation(P,C);
TF = isInterior(DT);
triplot(DT.ConnectivityList(TF,:),DT.Points(:,1),DT.Points(:,2))
hold on
plot(x_exterior,y_exterior,"r-",LineWidth=1.5)
hold on
plot(x_interior,y_interior,"r--",LineWidth=1.5)
title("Delaunay Triangulation")
% delaunay_x = [int_node_x , x_nodes_exterior(1:end-1)]; %Last point is repeated to complete the cycle,
% delaunay_y = [int_node_y , y_nodes_exterior(1:end-1)];  % which is removed here
% constraintEdges = [(1:length(x_exterior)-1)', [(2:length(x_exterior)-1), 1]'];
% % constraintEdges=[constraintEdges;((),())]
% % Convert constraintEdges to double if it's not already
% if ~isa(constraintEdges, 'double')
%     constraintEdges = double(constraintEdges);
% end
% DT = delaunayTriangulation(delaunay_x',delaunay_y', constraintEdges);
% triplot(DT);
% title('Delaunay Triangulation')
end
function P_unique = remove_duplicate_rows(P)
    [~, unique_indices, ~] = unique(P, 'rows', 'stable');
    P_unique = P(unique_indices, :);
end
