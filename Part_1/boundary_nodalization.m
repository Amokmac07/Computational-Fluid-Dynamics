function [x_nodes_exterior, y_nodes_exterior, x_nodes_interior, y_nodes_interior] = boundary_nodalization(P_ext, P_int, l)
    x_exterior = P_ext(1, :); % x-coordinates of exterior spline points
    y_exterior = P_ext(2, :); % y-coordinates of exterior spline points

    % Initialize arrays to store nodalized x and y coordinates
    x_nodes_exterior = [];
    y_nodes_exterior = [];
    x_nodes_interior = [];
    y_nodes_interior = [];

    % Perform boundary nodalization for exterior spline points
    [x_nodes_exterior, y_nodes_exterior] = nodalization_segment(x_exterior, y_exterior, l);

    % Plot boundary nodalization for exterior points
    plot_boundary_nodalization(x_exterior, y_exterior, x_nodes_exterior, y_nodes_exterior);

    if ~isempty(P_int)
        x_interior = P_int(1, :); % x-coordinates of interior spline points
        y_interior = P_int(2, :); % y-coordinates of interior spline points

        % Perform boundary nodalization for interior spline points
        [x_nodes_interior, y_nodes_interior] = nodalization_segment(x_interior, y_interior, l);

        % Plot boundary nodalization for interior points
        plot_boundary_nodalization(x_interior, y_interior, x_nodes_interior, y_nodes_interior);
    else
        x_nodes_interior = [];
        y_nodes_interior = [];
    end
end

function [x_nodes, y_nodes] = nodalization_segment(x, y, l)
    % Initialize arrays to store nodalized x and y coordinates
    x_nodes = [];
    y_nodes = [];

    i = 1;
    while i < length(x)
        % Calculate the distance between consecutive points
        dist = hypot(x(i+1) - x(i), y(i+1) - y(i));

        % If distance is less than l, find the point where it first exceeds l
        if dist < l
            remaining_dist = l - dist;
            j = i + 1;
            while j < length(x) && remaining_dist > hypot(x(j) - x(j+1), y(j) - y(j+1))
                remaining_dist = remaining_dist - hypot(x(j) - x(j+1), y(j) - y(j+1));
                j = j + 1;
            end

            % Calculate the x and y increments for each node
            dx = (x(j) - x(i)) / 1;
            dy = (y(j) - y(i)) / 1;

            % Add node
            x_nodes(end+1) = x(i) + dx;
            y_nodes(end+1) = y(i) + dy;

            % Update loop index i to start from the new point found
            i = j;
        else
            % Calculate the number of nodes to add based on the segment length
            num_nodes = ceil(dist / l);

            % Calculate the x and y increments for each node
            dx = (x(i+1) - x(i)) / num_nodes;
            dy = (y(i+1) - y(i)) / num_nodes;

            % Add nodes along the segment
            for j = 0:num_nodes-1
                x_nodes(end+1) = x(i) + j*dx;
                y_nodes(end+1) = y(i) + j*dy;
            end

            % Move to the next segment
            i = i + 1;
        end
    end

    % Add the last point
    x_nodes(end+1) = x(end);
    y_nodes(end+1) = y(end);
end

% function [x_nodes, y_nodes] = nodalization_segment(x, y, l)
%     % Initialize arrays to store nodalized x and y coordinates
%     x_nodes = [];
%     y_nodes = [];
% 
%     i = 1;
%     while i < length(x)
%         % Calculate the distance between consecutive points
%         dist = hypot(x(i+1) - x(i), y(i+1) - y(i));
% 
%         % If distance is less than l, find the point where it first exceeds l
%         if dist < l
%             remaining_dist = l - dist;
%             j = i + 1;
%             while j < length(x) && remaining_dist > hypot(x(j) - x(j+1), y(j) - y(j+1))
%                 remaining_dist = remaining_dist - hypot(x(j) - x(j+1), y(j) - y(j+1));
%                 j = j + 1;
%             end
% 
%             % Calculate the x and y increments for each node
%             dx = (x(j) - x(i)) / 1;
%             dy = (y(j) - y(i)) / 1;
% 
%             % Add node
%             x_nodes(end+1) = x(i) + dx;
%             y_nodes(end+1) = y(i) + dy;
% 
%             % Update loop index i to start from the new point found
%             i = j;
%         else
%             % Calculate the number of nodes to add based on the segment length
%             num_nodes = ceil(dist / l);
% 
%             % Calculate the x and y increments for each node
%             dx = (x(i+1) - x(i)) / num_nodes;
%             dy = (y(i+1) - y(i)) / num_nodes;
% 
%             % Add nodes along the segment
%             for j = 0:num_nodes-1
%                 x_nodes(end+1) = x(i) + j*dx;
%                 y_nodes(end+1) = y(i) + j*dy;
%             end
%         end
% 
%         % Move to the next segment
%         i = i + 1;
%     end
% 
%     % Add the last point
%     x_nodes(end+1) = x(end);
%     y_nodes(end+1) = y(end);
% end

function plot_boundary_nodalization(x_boundary, y_boundary, x_nodes, y_nodes)
    plot(x_boundary, y_boundary, 'b-', 'LineWidth', 2);
    hold on;
    plot(x_nodes, y_nodes, 'ko', 'MarkerSize', 5); % Nodalized boundary
    xlabel('X');
    ylabel('Y');
    title('Boundary Nodalization');
    axis equal;
    
end

% Below is TRIAL 1
% function [x_nodes_exterior,y_nodes_exterior,x_nodes_interior,y_nodes_interior]=boundary_nodalization(P_ext,P_int,l)
% x_exterior = P_ext(1,:);% x-coordinates of  exterior spline points
% y_exterior = P_ext(2,:); % y-coordinates of exterior spline points
% 
% % Initialize arrays to store nodalized x and y coordinates
% x_nodes_exterior = [];
% y_nodes_exterior = [];
% x_nodes_interior = [];
% y_nodes_interior = [];
% 
%     for i = 1:length(x_exterior)-1
%         % Calculate the distance between consecutive points
%         dist = sqrt((x_exterior(i+1) - x_exterior(i))^2 + (y_exterior(i+1) - y_exterior(i))^2);
% 
%         % Calculate the number of nodes to add based on the segment length
%         num_nodes = max(1, ceil(dist / l));
% 
%         % Calculate the x and y increments for each node
%         dx = (x_exterior(i+1) - x_exterior(i)) / num_nodes;
%         dy = (y_exterior(i+1) - y_exterior(i)) / num_nodes;
% 
%         % Add nodes along the segment
%         for j = 1:num_nodes-1
%             x_nodes_exterior = [x_nodes_exterior, x_exterior(i) + j*dx];
%             y_nodes_exterior = [y_nodes_exterior, y_exterior(i) + j*dy];
%         end
% 
%         % Add a point at a distance of l from the previous point if needed
%         if dist > l
%             x_nodes_exterior = [x_nodes_exterior, x_exterior(i+1)];
%             y_nodes_exterior = [y_nodes_exterior, y_exterior(i+1)];
%         else
%             % Calculate the last point such that the distance is almost l
%             x_last = x_exterior(i) + (num_nodes - 1) * dx;
%             y_last = y_exterior(i) + (num_nodes - 1) * dy;
%             x_nodes_exterior = [x_nodes_exterior, x_last];
%             y_nodes_exterior = [y_nodes_exterior, y_last];
%         end
%     end
%     figure;
%     plot(x_exterior, y_exterior, 'b-', 'LineWidth', 2);
%     hold on;
%     % BN=[x_nodes;y_nodes];
%     plot(x_nodes_exterior, y_nodes_exterior, 'ko', 'MarkerSize', 5); % Nodalized boundary
%     xlabel('X');
%     ylabel('Y');
%     title('Boundary Nodalization');
%     if ~isempty(P_int)
%         x_interior = P_int(1,:);% x-coordinates of interior spline points
%         y_interior = P_int(2,:); % y-coordinates of interior spline points
%         for i = 1:length(x_interior)-1
%             % Calculate the distance between consecutive points
%             dist = sqrt((x_interior(i+1) - x_interior(i))^2 + (y_interior(i+1) - y_interior(i))^2);
% 
%             % Calculate the number of nodes to add based on the segment length
%             num_nodes = max(1, ceil(dist / l));
% 
%             % Calculate the x and y increments for each node
%             dx = (x_exterior(i+1) - x_exterior(i)) / num_nodes;
%             dy = (y_exterior(i+1) - y_exterior(i)) / num_nodes;
% 
%             % Add nodes along the segment
%             for j = 1:num_nodes-1
%                 x_nodes_interior = [x_nodes_interior, x_interior(i) + j*dx];
%                 y_nodes_interior = [y_nodes_interior, y_interior(i) + j*dy];
%             end
% 
%             % Add a point at a distance of l from the previous point if needed
%             if dist > l
%                 x_nodes_interior = [x_nodes_interior, x_interior(i+1)];
%                 y_nodes_interior = [y_nodes_interior, y_interior(i+1)];
%             else
%                 % Calculate the last point such that the distance is almost l
%                 x_last = x_interior(i) + (num_nodes - 1) * dx;
%                 y_last = y_interior(i) + (num_nodes - 1) * dy;
%                 x_nodes_interior = [x_nodes_interior, x_last];
%                 y_nodes_interior = [y_nodes_interior, y_last];
%             end
%         end
%         plot(x_interior, y_interior, 'b-', 'LineWidth', 2);
%         plot(x_nodes_interior, y_nodes_interior, 'ko', 'MarkerSize', 5); % Nodalized Interior boundary
%     else
%         x_nodes_exterior=[];
%         x_nodes_interior=[];
%     end
% end
% 

