
function AFM(x_exterior,y_exterior,x_interior,y_interior,l)
[P_ext,P_int] = boundary_generation(x_exterior,x_interior,y_exterior,y_interior);

[x,y,x_internal,y_internal]=boundary_nodalization(P_ext,P_int,l);
A=[x',y'];
% Initialize a logical array to mark duplicate rows
is_duplicate = false(size(A, 1), 1);

% Loop through the rows to mark duplicates
for i = 1:size(A, 1)
    if ~is_duplicate(i)
        for j = i+1:size(A, 1)
            if isequal(A(i,:), A(j,:))
                is_duplicate(j) = true;
            end
        end
    end
end

% Remove duplicate rows
unique_matrix = A(~is_duplicate, :);
x=(unique_matrix(:,1))';
y=(unique_matrix(:,2))';
x(1,end+1)=x(1);
y(1,end+1)=y(1);

y_min=min(y);
y_max=max(y);

h = sqrt(3)/2*l;
H = linspace(y_min,y_max,round((y_max-y_min)/h)); %H levels


inter_points_x=[];
inter_points_y=[];
[int_node_x,int_node_y]=interior_nodalization(x, y, x_internal, y_internal,l);

%%
plot(x_exterior , y_exterior)
hold on;
x_boundary  =  x;
y_boundary  =  y;
x_int_nodes = int_node_x;  %int refers to interior
y_int_nodes = int_node_y;


x_search_bound = x_boundary(1:end-1); %bound refers to boundary
y_search_bound = y_boundary(1:end-1);
%label_search_bound = label_boundary(1:end-1);

x_search_int  = x_int_nodes ;  %Int refers to interior nodes
y_search_int  = y_int_nodes ;
%label_search_int = label_int_nodes ;

Adv_Front_x =  x_boundary; %Initial Advancing Front is cyclic boundary nodes itself
Adv_Front_y =  y_boundary; 
%Adv_Front_label = label_boundary;

x_search_total_points = [x_search_bound ,x_search_int];
y_search_total_points = [y_search_bound ,y_search_int];

x_search_array = [x_search_bound ,x_search_int];
y_search_array = [y_search_bound ,y_search_int];
%label_search_array= [label_search_bound ,label_search_int];

N_search_bound = numel(x_search_bound);
N_search_int   = numel(x_search_int);
i=0;
while numel(Adv_Front_x) > 4
i=i+1;
[Refined_Scatter, Scatter_Index] = isInsideOrOnPolySegregator(x_search_total_points,y_search_total_points...
    , Adv_Front_x(1:end-1) , Adv_Front_y(1:end-1));

%Refined Scatter is 2 column vector whose points are within the AdvFront
%Scatter Index is the index of selected points from x_search_total

%flip is used to reverse an array. as the polygon needs to be in clockwise
%direction

[Point , Point_Index] = P_locator (Adv_Front_x(end-1),Adv_Front_y(end-1),Adv_Front_x(end),Adv_Front_y(end),...
    Refined_Scatter(:,1)' , Refined_Scatter(:,2)');

% Replace x_search_array and y_search_array above with
% isInsideorOnPolySegregator function and see what happens

P_x = Point(1) ;
P_y = Point(2) ;
%P_label= label_search_array(Scatter_Index(Point_Index));

%if Scatter_Index(Point_Index) > N_search_bound %if the point P is from interior node
if isPointPresent(Adv_Front_x(1:end-1), Adv_Front_y(1:end-1), P_x, P_y)==0
    plot([Adv_Front_x(end-1), P_x],[Adv_Front_y(end-1), P_y])
    hold on
    plot([P_x, Adv_Front_x(end)],[P_y, Adv_Front_y(end)])


    Adv_Front_x(end+1) = Adv_Front_x(end);
    Adv_Front_x(end-1) = P_x;

    Adv_Front_y(end+1) = Adv_Front_y(end);
    Adv_Front_y(end-1) = P_y;

    % Adv_Front_label(end+1) = Adv_Front_label(end);
    % Adv_Front_label(end-1) = P_label;

    % x_search_int(Point_Index - N_search_bound) = [];    
    % y_search_int(Point_Index - N_search_bound) = [];%removes the point P from int nodes search
    % label_search_int(Point_Index - N_search_bound) = [];

elseif isPointPresent(Adv_Front_x(1:end-1), Adv_Front_y(1:end-1), P_x, P_y) == 1 && P_x==Adv_Front_x(2)...
         && P_y==Adv_Front_y(2) %if the point P from boundary node
    plot([Adv_Front_x(end-1), P_x],[Adv_Front_y(end-1), P_y])


    Adv_Front_x(1) = [];
    Adv_Front_x(end) = P_x;

    Adv_Front_y(1) = [];
    Adv_Front_y(end) = P_y;

    % Adv_Front_label(1) = [];
    % Adv_Front_label(end) = P_label;

    % x_search_bound(Point_Index) = [];    
    % y_search_bound(Point_Index) = [];%removes the point P from int nodes search
    % label_search_bound(Point_Index) = [];
else
     Adv_Front_x(1) = [];
     Adv_Front_x(end+1)=Adv_Front_x(1);
     Adv_Front_y(1) = [];
     Adv_Front_y(end+1)=Adv_Front_y(1);

end
Adv_Front_x;
Adv_Front_y;
%Adv_Front_label

movieVec(i)=getframe;
end 

% myWriter=VideoWriter('AFM Triangulation','MPEG-4');
% myWriter.FrameRate=10;
% open(myWriter);
% writeVideo(myWriter,movieVec);
% close(myWriter);
end

%% isLeft Function
function f = isLeft ( xA , yA , xB , yB , xP , yP ) 
%This Functions checks if the point P(xP,yP) is twoards the line segment AB
%If true, it returens 1, if not, it returns 0.
sign = (xB-xA)*(yP-yA) - (yB - yA)*(xP - xA);
if sign > 0
    f=1;
else
    f=0;
end
end

%% isInsideOrOnPolySegregator Function

function [Refined_Scatter, Scatter_Index] = isInsideOrOnPolySegregator(xScatter,yScatter,xPoly,yPoly)
% it takes the values of xScatter and yScatter and returns only the points
% which are Inside or on the Polygon as a 2 column array (1st ,2nd
% Column)=(x,y) coordinates. It also return the correspondix index of
% points
RefinedScatter_x = [];
RefinedScatter_y = [];
RefinedScatter_Index=[];
for i= 1:numel(xScatter,yScatter)
    if inpolygon(xScatter(i) ,yScatter(i) , xPoly , yPoly)==1
        RefinedScatter_x = [RefinedScatter_x,xScatter(i)];
        RefinedScatter_y = [RefinedScatter_y,yScatter(i)];
        RefinedScatter_Index = [RefinedScatter_Index,i];  %Returns array of Index of selected scatter points
    end
end

Refined_Scatter =[RefinedScatter_x',RefinedScatter_y'];
Scatter_Index = RefinedScatter_Index;

end

%% isInsideOrOnPoly Function

function f=isInsideOrOnPoly(xPoly,yPoly,xP,yP)
%This function checks if point P is inside or on the closed Polygon and returns 1
%if true. Note :(xPoly , yPoly) points must be arranged in clockwise
%manner.

NumEdgesInRight=0;  %Number of Edges such that point P is in right or On the edge.(Note direction is clockwise)
NumEdges =numel(xPoly)-1; %ABCDA is a 4 sided polygon

for i=1:NumEdges
    if isLeft(xPoly(i),yPoly(i),xPoly(i+1),yPoly(i+1),xP,yP)==0
        NumEdgesInRight=NumEdgesInRight+1;
    end
end


if NumEdgesInRight==NumEdges
    f=1;
else
    f=0;
end


end

%% two_side_sum Function

function f=two_side_sum(xA , yA , xB , yB , xP ,yP)
%This Functions finds the sum of the edges AP and BP and adds them.
%In AFM , point P must be chosen such that this length is minimum.
AP = sqrt((xP-xA)^2+(yP-yA)^2);
BP = sqrt((xP-xB)^2+(yP-yB)^2);
f = AP + BP;
end

%% P_locator function

function [Point , Point_Index] = P_locator (xA , yA, xB , yB , x_search_array , y_search_array)

%Point locates the nearest point subject to conditions (nearest and left)
%as an 1 row , 2 column array.

%Point_Index gives the index of the point in x_search array (or equivalently y_search_array)

d_array=[]; %two side sum of sides of triangle formed

% Available points after satisfying the "left" condition
available_search_points_x=[] ; 
available_search_points_y=[] ; 
available_search_points_index=[];

for i=1:numel(x_search_array)
    
    if isLeft(xA , yA , xB , yB , x_search_array(i) , y_search_array (i))==1
        available_search_points_x = [available_search_points_x , x_search_array(i)];
        available_search_points_y = [available_search_points_y , y_search_array(i)];
        available_search_points_index = [available_search_points_index , i];
    end

end



for i=1:numel(available_search_points_x)
    d = two_side_sum(xA , yA , xB , yB , available_search_points_x(i) ,available_search_points_y(i));
    d_array = [d_array, d];
end


%Finding the minimum value of two side length (Finding P such that Triangle
%ABP has lowest perimeter.

[minValue_d_array, minIndex_d_array] = min(d_array);
Actual_P_Index = available_search_points_index(minIndex_d_array); % Find the index corresponding to x_search_array of the desired point P
Point = [x_search_array(Actual_P_Index) , y_search_array(Actual_P_Index)];
Point_Index = Actual_P_Index;

end
%% isPointPresent function

function isPresent = isPointPresent(x_array, y_array, x, y)
  % Checks if the point (x, y) is present in any element of both arrays.
   b=[];
  combined_matrix = [x_array', y_array'];
  for i=1:numel(x_array)
      a=combined_matrix(i,:)==[x,y];
      if sum(a)==2
          b=[b,i];
      end
  end
if numel(b)>0
    isPresent=1;
else
       isPresent=0;
  end
 
end    

