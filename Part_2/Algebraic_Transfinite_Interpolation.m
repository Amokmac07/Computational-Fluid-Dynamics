%% Question 5 a
clear all;
clc;

% Define radius and center of the circle
radius = 4; % cm
center = [0, 0]; % Center coordinates (x, y)

% Define angles for plotting (from 90 to 270 degrees)
theta = linspace(pi/2, 2*pi, 100); % Angles in radians

% Generate x and y coordinates for the circle
x_circle = center(1) + radius * cos(theta);
y_circle = center(2) + radius * sin(theta);

% Plot the circle
figure;
plot(x_circle, y_circle, 'b', 'LineWidth', 2);
hold on;

% Generate x and y coordinates for the straight line representing the cut-off
x_line = [0, radius];
y_line = [radius, 0];

% Plot the straight line
plot(zeros(length(x_line)), x_line, 'b', 'LineWidth', 2);
plot(y_line,zeros(length(y_line)), 'b', 'LineWidth', 2);

% adding the points at 15 degree
theta_2 =pi/2:pi/12:2*pi;
x_points = center(1) + radius * cos(theta_2);
y_points = center(2) + radius * sin(theta_2);
% adding verical points as well 
x_points=[x_points 3 2 1 0 0 0 0];
y_points=[y_points 0 0 0 0 1 2 3];
plot(x_points, y_points, 'or', 'MarkerFaceColor', 'r', 'MarkerSize', 3, 'LineWidth', 2);

points=[x_points;y_points]';
hold on;
for i = 1:6
  % Extract points for current line
  x1 = x_points(6-i+1);
  y1 = y_points(6-i+1);
  x2 = x_points(14+i-1);
  y2 = y_points(14+i-1);

  % Calculate slope (m) and y-intercept (c) for the line equation y = mx +c
  m = (y2 - y1) / (x2 - x1);
  c = y1 - m*x1;
 horz_line(i,:)=[m c];
 x=-5:0.1:5;
 y=m.*x+c;
 plot(x,y,'--k','LineWidth',0.1)
 M(:, 1, i) = x;  % Store x values in the first column
 M(:, 2, i) = y;   % Store y values in the second column
end
for i=1:8
    % along line AI 
   
    % Extract points for current line
  x1 = x_points(14-i+1);
  y1 = y_points(14-i+1);
  x2 = x_points(19+i-1);
  y2 = y_points(19+i-1);

  % Calculate slope (m) and y-intercept (c) for the line equation y = mx +c
  m = (y2 - y1) / (x2 - x1);
  c = y1 - m*x1;
 vert_line(i,:)=[m c];
  x=-5:0.1:5;
 y=m.*x+c;
 plot(x,y,'--k','LineWidth',0.1)
 N(:, 1, i) = x;  % Store x values in the first column
 N(:, 2, i) = y;   % Store y values in the second column
end
 cx=[x_points(6),x_points(1)];
 cy=[y_points(6),y_points(1)];
 % Calculate slope (m) and y-intercept (c) for the line equation y = mx +c
 mc= ((cy(2) - cy(1)) / (cx(2) - cx(1)));
 cc= cy(1) - mc*cx(1);
 vert_line(end+1,:)=[mc cc];
 ccx=-5:0.1:5;
 ccy=mc.*ccx+cc;
 plot(ccx,ccy,'--k','LineWidth',0.1)
 N(:, 1, 9) = ccx;  % Store x values in the first column
 N(:, 2,9) = ccy;   % Store y values in the second column


% Initialize an array to store the intersection points
intersection_points = zeros(size(horz_line, 1), size(vert_line, 1), 2); % Rows correspond to horizontal lines, columns to vertical lines

% Calculate intersection points
for i = 1:size(horz_line, 1)
    for j = 1:size(vert_line, 1)
        % Extract slopes and intercepts for the current horizontal and vertical lines
        m_horz = horz_line(i, 1);
        c_horz = horz_line(i, 2);
        m_vert = vert_line(j, 1);
        c_vert = vert_line(j, 2);
        
        % Calculate x-coordinate of the intersection point
        x_intersect = (c_vert - c_horz) / (m_horz - m_vert);
        
        % Calculate y-coordinate of the intersection point
        y_intersect = m_horz * x_intersect + c_horz;
        
        % Store the intersection point
        intersection_points(i, j, 1) = x_intersect;
        intersection_points(i, j, 2) = y_intersect;
    end
    % plot(intersection_points(i,:,2),intersection_points(i,:,1),'ok')

end

 % Adjust plot limits and aspect ratio
axis equal;
xlim([-radius - 0.5, radius + 0.5]);
ylim([-radius - 0.5, radius + 0.5]);
%%
% Creating the computational plane
psi=linspace(0,1,9);
eta=linspace(0,1,6);
comp_points(:,:,1)=psi.*ones(6,9);
comp_points(:,:,2)=eta'.*ones(6,9);
figure;
title("Computational Plane")
hold on;
for i=1:6
    % x1=comp_points(i,1,1);
    % y1=comp_points(i,1,2);
    % x2=comp_points(i,6,1);
    % y2=comp_points(i,6,2);
    plot(comp_points(i,:,1),comp_points(i,:,2),'k');
    plot(comp_points(i,:,1),comp_points(i,:,2),'or');
end
for i=1:9
    plot(comp_points(:,i,1),comp_points(:,i,2),'k');
end
 % Adjust plot limits and aspect ratio
axis equal;
xlim([-0.1, 1.1]);
ylim([-0.1,1.1]);
%%
% Calculating the corrected coordinates along eta ie horizontal lines
% Plot the circle
figure;
plot(x_circle, y_circle, 'b', 'LineWidth', 2);
hold on;
% Plot the straight line
plot(zeros(length(x_line)), x_line, 'b', 'LineWidth', 2);
plot(y_line,zeros(length(y_line)), 'b', 'LineWidth', 2);

for i=9:-1:2
    x1 = x_points(14-(9-i));
    y1 = y_points(14-(9-i));
    x2 = x_points(19+(9-i));
    y2 = y_points(19+(9-i));
    % target - actual 
    dxlv(i)=x1-intersection_points(1,i,2);
    dylv(i)=y1-intersection_points(1,i,1);
    dxrv(i)=x2-intersection_points(6,i,2);
    dyrv(i)=y2-intersection_points(6,i,1);
end
dxlv(1)=cx(1)-intersection_points(1,1,2);
dylv(1)=cy(1)-intersection_points(1,1,1);
dxrv(1)=cx(2)-intersection_points(6,1,2);
dyrv(1)=cy(2)-intersection_points(6,1,1);
Dv=[dxlv' dylv' dxrv' dyrv'];

for i = 1:length(horz_line)
    for j = 1:length(vert_line)
        intersection_points_1(i,j,1)=intersection_points(i,j,2)+(1-eta(i))*dxlv(j)+(eta(i)*dxrv(j));
        intersection_points_1(i,j,2)=intersection_points(i,j,1)+(1-eta(i))*dylv(j)+(eta(i)*dyrv(j));
    end
    % plot(intersection_points_1(i,:,1),intersection_points_1(i,:,2),'ok')
    
end
 %Calculating the corrected coordinates along eta ie horizontal lines

for i=1:length(horz_line)
    x1 = x_points(6-i+1);
    y1 = y_points(6-i+1);
    x2 = x_points(14+i-1);
    y2 = y_points(14+i-1);
    % target - actual 
    dxl(i)=x1-intersection_points_1(i,1,1);
    dyl(i)=y1-intersection_points_1(i,1,2);
    dxr(i)=x2-intersection_points_1(i,9,1);
    dyr(i)=y2-intersection_points_1(i,9,2);
end
D=[dxl' dyl' dxr' dyr'];

for i = 1:length(vert_line)
    for j = 1:length(horz_line)
        intersection_points_2(j,i,1)=intersection_points_1(j,i,1)+(1-psi(i))*dxl(j)+(psi(i)*dxr(j));
        intersection_points_2(j,i,2)=intersection_points_1(j,i,2)+(1-psi(i))*dyl(j)+(psi(i)*dyr(j));
    end
    plot(intersection_points_2(:,i,1),intersection_points_2(:,i,2),'r','LineWidth',1)
end
for i = 1:length(horz_line)
     plot(intersection_points_2(i,:,1),intersection_points_2(i,:,2),'r','LineWidth',1)
     plot(intersection_points_2(i,:,1),intersection_points_2(i,:,2),'ok','LineWidth',1)
end

 % Adjust plot limits and aspect ratio
axis equal;
xlim([-radius - 0.5, radius + 0.5]);
ylim([-radius - 0.5, radius + 0.5]);

%% Question 5 b
% we have to find metrics of transformation at each internal gridpoint 4*7

for i=2:8
    for j=2:5
       
        dx1=(intersection_points_2(j,i,1)-intersection_points_2(j,i-1,1));
        dx2=(intersection_points_2(j,i+1,1)-intersection_points_2(j,i,1));
        
        dy1=(intersection_points_2(j,i,2)-intersection_points_2(j-1,i,2));
        dy2=(intersection_points_2(j+1,i,2)-intersection_points_2(j,i,2));

        psi_x(i-1,j-1)=((comp_points(j,i+1,1)*(dx1^2))-(comp_points(j,i-1,1)*(dx2^2))+(dx2^2-dx1^2)*comp_points(j,i,1))/(dx1*dx2*(dx1+dx2));
        psi_y(i-1,j-1)=((comp_points(j+1,i,1)*(dy1^2))-(comp_points(j-1,i,1)*(dy2^2))+(dy2^2-dy1^2)*comp_points(j,i,1))/(dy1*dy2*(dy1+dy2));
        eta_x(i-1,j-1)=((comp_points(j,i+1,2)*(dx1^2))-(comp_points(j,i-1,2)*(dx2^2))+(dx2^2-dx1^2)*comp_points(j,i,2))/(dx1*dx2*(dx1+dx2));
        eta_y(i-1,j-1)=((comp_points(j+1,i,2)*(dy1^2))-(comp_points(j-1,i,2)*(dy2^2))+(dy2^2-dy1^2)*comp_points(j,i,2))/(dy1*dy2*(dy1+dy2));
        
        psi_xx(i-1,j-1)=2*((comp_points(j,i+1,1)*(dx1))-(comp_points(j,i-1,1)*(dx2))-(dx2+dx1)*comp_points(j,i,1))/(dx1*dx2*(dx1+dx2));
        psi_yy(i-1,j-1)=2*((comp_points(j+1,i,1)*(dy1))-(comp_points(j-1,i,1)*(dy2))-(dy2+dy1)*comp_points(j,i,1))/(dy1*dy2*(dy1+dy2));
        eta_xx(i-1,j-1)=2*((comp_points(j,i+1,2)*(dx1))-(comp_points(j,i-1,2)*(dx2))-(dx2+dx1)*comp_points(j,i,2))/(dx1*dx2*(dx1+dx2));
        eta_yy(i-1,j-1)=2*((comp_points(j+1,i,2)*(dy1))-(comp_points(j-1,i,2)*(dy2))-(dy2+dy1)*comp_points(j,i,2))/(dy1*dy2*(dy1+dy2));
        
    end
end
psi_x=psi_x';
psi_y=psi_y';
eta_x=eta_x';
eta_y=eta_y';
psi_xx=psi_xx';
psi_yy=psi_yy';
eta_xx=eta_xx';
eta_yy=eta_yy';

%% Question 5c

% finding the coefficients 
a=psi_x.^2+psi_y.^2;
b=eta_x.^2+eta_y.^2;
c=2*(psi_x.*eta_x+psi_y.*eta_y);
d=psi_xx+psi_yy;
e=eta_xx+eta_yy;

