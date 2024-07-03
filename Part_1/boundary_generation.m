function [P_ext,P_int] = boundary_generation(x_exterior,x_interior,y_exterior,y_interior)
    tot0=0;
    del=0.05; % delta to generate splines between 2 points
    for i=(1:length(x_exterior)-1)
        % finding the distance between the boundary points
        dx_exterior = x_exterior(i+1) - x_exterior(i);
        dy_exterior = y_exterior(i+1) - y_exterior(i);
        % There are 2 cases of having straight line with same x or same y
        % coordinates hence dx=0 or dy=0 between current and next point
        if dx_exterior~=0
            % first find whether the next point is ahead or behind the
            % current point on the 1D direction
            step = sign(dx_exterior) * del;
            % Then generate multiple points in bewteen the current and next
            % point so that we get more accuracy for spline interpolation
            xq = x_exterior(i):step:x_exterior(i+1);
            yq = spline(x_exterior(i:i+1),y_exterior(i:i+1),xq);    
        else
            step = sign(dy_exterior) * del;
            yq = (y_exterior(i):step:y_exterior(i+1));
            xq =spline(y_exterior(i:i+1),x_exterior(i:i+1),yq);           
        end
        % Storing the generated splines in between current and next point
        A=[xq;yq];
        a=length(A);
        % Now combining all the splines to btwn all points for final shape
        if i==1
            tot(i)=tot0+a;
            P_ext(:,1:tot(i))=A;
        else
            tot(i)=tot(i-1)+a;
            P_ext(:,(tot(i-1)+1):tot(i))=A;
        end
    end
    
    if P_ext(:,end)~=P_ext(:,1)
       P_ext(:,length(P_ext)+1)=P_ext(:,1);
    end
    x_ext = P_ext(1,:);% x-exterior of spline points
    y_ext = P_ext(2,:); % y-exterior of spline points
    figure;
    plot(x_ext, y_ext, 'b-', 'LineWidth', 2);
    hold on;
    % Now repeating the same for the interior nodes by checking if interior
    % boundary exists or not
    if ~isempty(x_interior) && ~isempty(y_interior)
        for i=(1:length(x_interior)-1)
            dx_interior = x_interior(i+1) - x_interior(i);
            dy_interior = y_interior(i+1) - y_interior(i);
            if dx_interior~=0
                step = sign(dx_interior) *del;
                xq = x_interior(i):step:x_interior(i+1);
                yq = spline(x_interior(i:i+1),y_interior(i:i+1),xq);
            else
                step = sign(dy_interior) * del;
                yq = (y_interior(i):step:y_interior(i+1));
                xq =spline(y_interior(i:i+1),x_interior(i:i+1),yq);
            end
            A=[xq;yq];
            a=length(A);

            if i==1
                tot(i)=tot0+a;
                P_int(:,1:tot(i))=A;
            else
                tot(i)=tot(i-1)+a;
                P_int(:,(tot(i-1)+1):tot(i))=A;
            end
        end
        x_int = P_int(1,:);% x-interior of spline points
        y_int = P_int(2,:); % y-interior of spline points
         plot(x_int, y_int, 'b-', 'LineWidth', 2);
    else
        P_int=[];
    end
end
