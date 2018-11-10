%Testing Random Waypoint mobility model.
clear all
clc
close all;
nodes_numb=150;



%Initial positions
x_start=rand(1,150)*800;
y_start=rand(1,150)*800;

%Area
Area_start=0;
Area_end=800;





s_input = struct('V_POSITION_X_INTERVAL',[Area_start Area_end],...%(m)
                 'V_POSITION_Y_INTERVAL',[Area_start Area_end],...%(m)
                 'V_SPEED_INTERVAL',[0.2 10],...%(m/s)
                 'V_PAUSE_INTERVAL',[1 1],...%pause time (s)
                 'V_WALK_INTERVAL',[1.00 1.00],...%walk time (s)
                 'V_DIRECTION_INTERVAL',[-180 180],...%(degrees)
                 'SIMULATION_TIME',50,...%(s)
                 'NB_NODES',nodes_numb);
s_mobility = Generate_Mobility(s_input,x_start,y_start);

timeStep = 1;%(s)
test_Animate(s_mobility,s_input,timeStep,Area_start,Area_end,'o','r');
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
times=coor_help(1).V_TIME;

    

sss=3;