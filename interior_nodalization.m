
function [int_node_x,int_node_y] = interior_nodalization(x_nodes_exterior, y_nodes_exterior, x_nodes_interior, y_nodes_interior,l)
    if ~isempty(x_nodes_interior) && ~isempty(y_nodes_interior)
        x=[x_nodes_exterior,x_nodes_exterior(1)];
        y=[y_nodes_exterior,y_nodes_exterior(1)];
        y_min=min(y);
        y_max=max(y);
        h = sqrt(3)/2*l;
        H = linspace(y_min,y_max,round((y_max-y_min)/h)); %H levels
        inter_points_x=[];
        inter_points_y=[];
        %Drawing Horizontal lines and finding the points of intersection with the
        %curve
        for i=2:numel(H)-1
            x_intersection=[];
            y_intersection=[];
            for j =1:numel(x)-1
                if ((y(j)-H(i))*(y(j+1)-H(i))<0) || ((y(j)-H(i))*(y(j+1)-H(i))==0 && ((H(i)>y(j)) || H(i)>y(j+1)))
                    x_intersection =[x_intersection, x(j) + (H(i)-y(j)) * (x(j+1)-x(j)) / (y(j+1)-y(j))];
                    y_intersection =[y_intersection, H(i)];
    
                end
            end
            for k =1:numel(x_nodes_interior)-1
                if ((y_nodes_interior(k)-H(i))*(y_nodes_interior(k+1)-H(i))<0) || ((y_nodes_interior(k)-H(i))*(y_nodes_interior(k+1)-H(i))==0 && ((H(i)>y_nodes_interior(k)) || H(i)>y_nodes_interior(k+1)))
                    x_intersection =[x_intersection, x_nodes_interior(k) + (H(i)-y_nodes_interior(k)) * (x_nodes_interior(k+1)-x_nodes_interior(k)) / (y_nodes_interior(k+1)-y_nodes_interior(k))];
                    y_intersection =[y_intersection, H(i)];
    
                end
            end
                sorted_x_intersection = sort(x_intersection);
                inter_points_x = [inter_points_x,  sorted_x_intersection];
                inter_points_y = [inter_points_y, y_intersection];
        end
            int_node_x=[];
            int_node_y=[];
    
            %Finding interior nodes by segmenting the horizontal lines
    
            for i=1:numel(inter_points_x)-1
                if inter_points_y(i)==inter_points_y(i+1) && mod(i,2)~=0
    
                    %a=min(inter_points_x(i),inter_points_x(i+1));
                    %b=max(inter_points_x(i),inter_points_x(i+1));
    
                    a = inter_points_x(i);
                    b = inter_points_x(i+1);
    
                    horizontal_segment = linspace(a,b, round((b-a)/l)+1);
                    hortrim = horizontal_segment(2:end-1); % Eliminting the points which lie in the boundary
    
    
                    int_node_x = [int_node_x,hortrim];
                    int_node_y = [int_node_y,inter_points_y(i)*ones(1,numel(hortrim))];
                end
            end
            % plot(inter_points_x,inter_points_y,'o')
            plot(int_node_x,int_node_y,'r.')
            % legend("","Intersection of horizontal Line with the domain","Interior Nodes")
            title("Interior Nodalization")
    else
        x=[x_nodes_exterior,x_nodes_exterior(1)];
        y=[y_nodes_exterior,y_nodes_exterior(1)];
        y_min=min(y);
        y_max=max(y);
        h = sqrt(3)/2*l;
        H = linspace(y_min,y_max,round((y_max-y_min)/h)); %H levels
        inter_points_x=[];
        inter_points_y=[];
        %Drawing Horizontal lines and finding the points of intersection with the
        %curve
        for i=2:numel(H)-1
            x_intersection=[];
            y_intersection=[];
            for j =1:numel(x)-1
                if ((y(j)-H(i))*(y(j+1)-H(i))<0) || ((y(j)-H(i))*(y(j+1)-H(i))==0 && ((H(i)>y(j)) || H(i)>y(j+1)))
                    x_intersection =[x_intersection, x(j) + (H(i)-y(j)) * (x(j+1)-x(j)) / (y(j+1)-y(j))];
                    y_intersection =[y_intersection, H(i)];
    
                end
            end
                sorted_x_intersection = sort(x_intersection);
                inter_points_x = [inter_points_x,  sorted_x_intersection];
                inter_points_y = [inter_points_y, y_intersection];
        end
            int_node_x=[];
            int_node_y=[];
    
            %Finding interior nodes by segmenting the horizontal lines
    
            for i=1:numel(inter_points_x)-1
                if inter_points_y(i)==inter_points_y(i+1) && mod(i,2)~=0
    
                    %a=min(inter_points_x(i),inter_points_x(i+1));
                    %b=max(inter_points_x(i),inter_points_x(i+1));
    
                    a = inter_points_x(i);
                    b = inter_points_x(i+1);
    
                    horizontal_segment = linspace(a,b, round((b-a)/l)+1);
                    hortrim = horizontal_segment(2:end-1); % Eliminting the points which lie in the boundary
    
    
                    int_node_x = [int_node_x,hortrim];
                    int_node_y = [int_node_y,inter_points_y(i)*ones(1,numel(hortrim))];
                end
            end
            % plot(inter_points_x,inter_points_y,'o')
            plot(int_node_x,int_node_y,'r.')
            % legend("","Intersection of horizontal Line with the domain","Interior Nodes")
            title("Interior Nodalization")
    end
end


% my nodalization
% function R = interior_nodalization(x_nodes_exterior, y_nodes_exterior, x_nodes_interior, y_nodes_interior,intersection_points, c, l)
%     nodes_between = [];  % Initialize array to store interior nodes
% 
%     % Iterate through each pair of intersection points
%     for i = 1:length(c)
%         % Extract x and y coordinates of the first intersection point
%         x1 = intersection_points(i, 1);
%         y1 = intersection_points(i, 2);
% 
%         % Extract x and y coordinates of the second intersection point
%         x2 = intersection_points(i + length(c), 1);
%         y2 = intersection_points(i + length(c), 2);
% 
%         % Calculate the distance between the two intersection points
%         dist = sqrt((x2 - x1)^2 + (y2 - y1)^2);
% 
%         % Calculate the number of nodes to add based on the distance between intersection points
%         num_nodes = max(1, ceil(dist / l));
% 
%         % Calculate the x and y increments for each node
%         dx = (x2 - x1) / num_nodes;
%         dy = (y2 - y1) / num_nodes;
% 
%         % Add nodes between the two intersection points
%         for j = 1:num_nodes-1
%             x_node = x1 + j * dx;
%             y_node = y1 + j * dy;
%             nodes_between = [nodes_between; [x_node, y_node]];
%         end
% 
%         % Add the second intersection point if the distance is greater than l
%         if dist > l
%             nodes_between = [nodes_between; [x2, y2]];
%         end
%     end
%     BN=[([x_nodes_exterior,x_nodes_interior]);([y_nodes_exterior,y_nodes_interior])];
%     R=unique([BN';nodes_between], 'rows');
%     plot(nodes_between(:,1), nodes_between(:,2), 'ko', 'MarkerSize', 5);
% end
