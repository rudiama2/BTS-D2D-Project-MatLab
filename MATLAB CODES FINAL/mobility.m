function coordinates_movers = mobility(Pos_MS, Area, sim_time)

% Generate mobility of mobile stations
% input:
%   Pos_MS ... position of mobile stations
%   Area ... size of simulation area
%   sim_time ... time of simulation
% output:
%   coordinates_movers ... coordinates of the mobile stations in order to
%   generate mobility


x_start=Pos_MS(1,:);
y_start=Pos_MS(2,:);
nodes_numb = length(Pos_MS);

Area_start=0;
Area_end=Area;


s_input = struct('V_POSITION_X_INTERVAL',[Area_start Area_end],...%(m)
    'V_POSITION_Y_INTERVAL',[Area_start Area_end],...%(m)
    'V_SPEED_INTERVAL',[0.2 10],...%(m/s)
    'V_PAUSE_INTERVAL',[1 1],...%pause time (s)
    'V_WALK_INTERVAL',[1.00 1.00],...%walk time (s)
    'V_DIRECTION_INTERVAL',[-180 180],...%(degrees)
    'SIMULATION_TIME',sim_time,...%(s)
    'NB_NODES',nodes_numb);
s_mobility = Generate_Mobility(s_input,x_start,y_start);

close
coor_help=s_mobility.VS_NODE;


length_values=zeros(1,nodes_numb);
for index=1:nodes_numb
    length_values(index)=length(coor_help(index).V_TIME);
end
chosen_length=min(length_values);

for index2=1:nodes_numb
    if length(coor_help(index2).V_TIME)>chosen_length
        for index_deleting=1: length(coor_help(index2).V_TIME)-chosen_length
            coor_help(index2).V_TIME(end-1)=[];
            coor_help(index2).V_POSITION_X(end-1)=[];
            coor_help(index2).V_POSITION_Y(end-1)=[];
        end
    end
end


%-----------------results
coordinates_movers=zeros(2,chosen_length,nodes_numb);
for iiii=1:nodes_numb
    coordinates_movers(1,:,iiii)=coor_help(iiii).V_POSITION_X'  ;
    coordinates_movers(2,:,iiii)=coor_help(iiii).V_POSITION_Y' ;
end
end