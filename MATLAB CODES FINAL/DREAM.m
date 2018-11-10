clear all
close all
Area_x =1000;
Area_y=1000;
Number_MS=100;
const(1) = 4; % minimum constrain in meters
const(2) = 1400; % maximum constrain in meters
hop_distance = 100;

%------------------------------------------------
Pos_MS = MS_position(Area_x,Area_y,Number_MS,const); % position of MS
x=Pos_MS(1,:);
y=Pos_MS(2,:);
pos_x_source=randi(length(x));
x_source=x(pos_x_source);
y_source=y(pos_x_source);
pos_source=[x_source y_source];
sink = [Area_x Area_y];
chain(1)=pos_x_source;
Pos_MS = [Pos_MS sink'];


distance_to_sink = distance_2_points(sink', pos_source');
j = 2;

while distance_to_sink > 0
    d = ones(1,length(x))*1e4;
    for i=1:Number_MS+1
        if Pos_MS(1,i) > Pos_MS(1,chain(j-1)) && Pos_MS(2,i)> Pos_MS(2,chain(j-1))
            dist = distance_2_points (Pos_MS(:,chain(j-1)),Pos_MS(:,i));
            if dist < hop_distance
                d(i) = point_to_line_distance(Pos_MS(:,i)', Pos_MS(:,chain(j-1)), sink);
            end
        end
    end
    [a,b] = min(d);
    chain(j)= b;
    if a==1e4
        hop_distance = hop_distance+50;
        j = j-1;
    else
        hop_distance = 100;
        distance_to_sink = distance_2_points(sink', Pos_MS(:,chain(j)));
    end
    j = j+1;
end

x_chosen = zeros(1,length(chain));
y_chosen = zeros(1,length(chain));
for i = 1:length(chain)
    x_chosen(i) = Pos_MS(1,chain(i));
    y_chosen(i) = Pos_MS(2,chain(i));
end
figure
scatter(x,y);
hold on
scatter(x(pos_x_source),y(pos_x_source),'sm')
hold on
scatter(Area_x,Area_y,'xr')
hold on
plot(x_chosen,y_chosen);
