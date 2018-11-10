function [chain] = dream3 (area, s_number, Pos_MS,pos_x_source)

% Calculate the route following the DREAM protocol
% Input:
%   area ... [m^2]
%   s_number ... Number of mobile stations
%   Pos_MS ... Position of mobile stations
%   pos_x_source ... Position of the mobile station working as source
% Output:
%   chain ... Calculated chain that follows the PEGASIS protocol

Area_x =area;
Area_y=area;
Number_MS=s_number;
const(1) = 4; % minimum constrain in meters
const(2) = 1400; % maximum constrain in meters
hop_distance = 100;

%------------------------------------------------
x=Pos_MS(1,:);
y=Pos_MS(2,:);
x_source=x(pos_x_source);
y_source=y(pos_x_source);
pos_source=[x_source y_source];
sink = [Area_x Area_y];
chain(1)=pos_x_source;
Pos_MS = [Pos_MS sink'];


distance_to_sink = distance_2_points(sink', pos_source');

[~,index_start_chain]=max(distance_to_sink);

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

[~,index_leader_chain]=min(distance_to_sink);

chain(end) = [];
chain = chain;


% figure
% scatter(x,y);
% hold on
% scatter(x(pos_x_source),y(pos_x_source),'sm')
% hold on
% scatter(Area_x,Area_y,'xr')
% hold on
% plot(x_chosen,y_chosen);

end
