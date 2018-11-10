
function [Total_energy_LEACH_random_a,Total_energy_Direct_a]=main_over_drops(do_it)
%% Declaration of Main simulations parameters
if do_it==1
Area = [1000,1250,1500,1750,2000]; % area size
end
Number_MS = 150; % Number of CUE in the system
Number_CH = 3; % Number of cluster heads in system
const(1) = 4; % minimum constrain in meters
const(2) = 1400; % maximum constrain in meters
f = 2; % carrier frequency in GHz
Pt_full = 20;  %transmission power in dBm
BW = 20*10.^6;  % channel bandwidth
Data = 20e6; % packet size
interference = 0; % 1 - on, 0 - off
sim_time = 50; % number of drops
SINRth = -10; %treshold for computing the transmitting power, in dB

%%%% testing parameters
%Area = 1000;
%sim_time = 1;


%% calculation of noise
N_W = (BW*4*10.^-12)/10.^9; % noise [W]
N_dBm = 10*log10(N_W/0.001); % noise [dBm]

%% matrix for faster computation
Total_energy_LEACH_random = zeros(1,length(Area));
Total_energy_LEACH_kmeans = zeros(1,length(Area));
Total_energy_LEACH_random_PC = zeros(1,length(Area)); % PC - power control
Total_energy_LEACH_kmeans_PC = zeros(1,length(Area));
Total_energy_Direct = zeros(1,length(Area));
Total_energy_Direct_PC = zeros(1,length(Area));
Data_CH = zeros(1,Number_CH);


%% simulation
for a = 1:length(Area)
            Area_x = Area(a); % Definition of Area in meters (x-axes)
        Area_y = Area(a); % Definition of Area in meters (y-axes)
        
        %%%% generation of position
        Pos_MS = MS_position(Area_x,Area_y,Number_MS,const); % position of MS
%         Pos_sink = [Area_x/2; Area_y/2]; % position of sink
        Pos_sink = [Area_x; Area_y]; % position of sink
        used_clusters=[];
    for b = 1:sim_time
        
%         Area_x = Area(a); % Definition of Area in meters (x-axes)
%         Area_y = Area(a); % Definition of Area in meters (y-axes)
%         
%         %%%% generation of position
%         Pos_MS = MS_position(Area_x,Area_y,Number_MS,const); % position of MS
% %         Pos_sink = [Area_x/2; Area_y/2]; % position of sink
%         Pos_sink = [Area_x; Area_y]; % position of sink
        
        
%                 figure (1)
%                 plot (Pos_MS(1,:),Pos_MS(2,:),'rx')
%                 hold on
%                 plot (Pos_sink(1),Pos_sink(2),'gx')
%                 axis([0 Area_x 0 Area_y])
        
        
        %% direct transmition with power control
        % distance and pathloss are the same as in direct with full power
        d_to_sink = distance_2_points(Pos_sink,Pos_MS);
        Path_loss = pathloss(Number_MS,d_to_sink,f);
        Pt = power_control (N_dBm, Path_loss, SINRth);
        Pr = Pt - Path_loss;
        SNR_to_sink = Pt - Path_loss - N_dBm; % in dB
        SNR = 10.^(SNR_to_sink/10);
        C_to_sink = capacity(BW,SNR); % capacity to sink
        
        %%%% calculation of power consumption
        Pcon_Direct_PC = Pcon_function(Pt,Pr,C_to_sink,1,0); 
        %%%% calculation of consumed energy
        T_Direct_PC = Data./(C_to_sink*1e6); % transmission time in seconds
        Energy_Direct_PC = T_Direct_PC.*Pcon_Direct_PC;
        Total_energy_Direct_PC(a) = Total_energy_Direct_PC(a) + sum(Energy_Direct_PC);
        
        %% direct transmition with full power
        Pr = Pt_full - Path_loss;
        SNR_to_sink = Pt_full - Path_loss - N_dBm; % in dB
        SNR = 10.^(SNR_to_sink/10);
        C_to_sink = capacity(BW,SNR); % capacity to sink
        
        %%%% calculation of power consumption
        Pcon_Direct = Pcon_function(Pt_full,Pr,C_to_sink,1,0); 
        %%%% calculation of consumed energy
        T_Direct = Data./(C_to_sink*1e6); % transmission time in seconds
        Energy_Direct = T_Direct.*Pcon_Direct;
        Total_energy_Direct(a) = Total_energy_Direct(a) + sum(Energy_Direct);
        
        %% LEACH random choose of cluster - full power
        cluster = zeros(1,Number_CH);
%         for k = 1:Number_CH
k=1;
used_this_round=[];
        while ismember(0,cluster)==1
            sss=0;
            cluster(k) = round(rand*Number_MS);
            if cluster(k) ==0
                cluster(k)=1;
            end
            if ismember(cluster(k),used_clusters )==1     ||      ismember(cluster(k),used_this_round )==1

                cluster(k)=0;                
                k=k-1;
                sss=2;
            
           
            end
            if sss~=2
            used_this_round=[used_this_round,cluster(k)];
            end
                        k=k+1;

        end
        used_clusters=[used_clusters,cluster];
        disp(cluster);
%                 plot (Pos_MS(1,cluster),Pos_MS(2,cluster),'bx')
%                 legend('MS','sink','cluster')
% disp(cluster);
        
        [d_to_CH CH_assoc] = MS_association (Pos_MS, cluster);
        Path_loss = pathloss(Number_MS,d_to_CH,f);
        Pr = Pt_full - Path_loss;
        SNR_to_CH = Pt_full - Path_loss - N_dBm; % in dB
        SNR = 10.^(SNR_to_CH/10);
        C_to_CH = capacity(BW,SNR); % capacity to cluster head
        Data_CH = data_CH (CH_assoc, Data, Number_CH); % data from each CH to sink
        for k = 1:Number_CH
            Cap_to_sink (k) = C_to_sink(cluster(k)); % capacity from CH to sink
        end
        
        %%%% calculation of power consumption
        Pcon_LEACH_random_to_CH = Pcon_function(Pt_full,Pr,C_to_CH,1,0,cluster);
        Pcon_LEACH_random_to_sink = Pcon_function(Pt_full,Pr,Cap_to_sink,1,0,cluster);
        for i = 1:length(cluster)
            Pcon_LEACH_random_to_CH(cluster(i)) = Pcon_LEACH_random_to_sink(i);
        end
        Pcon_LEACH_random = Pcon_LEACH_random_to_CH;
        %%%% calculation of consumed energy
        T_LEACH_random_to_CH = Data./(C_to_CH*1e6); % transmission time in seconds
        T_LEACH_random_to_sink = Data_CH./(Cap_to_sink*1e6); % transmission time in seconds
        for i = 1:length(cluster)
            T_LEACH_random_to_CH(cluster(i)) = T_LEACH_random_to_sink(i);
        end
        T_LEACH_random = T_LEACH_random_to_CH;
        Energy_LEACH_random = T_LEACH_random.*Pcon_LEACH_random;
        Total_energy_LEACH_random(a) = Total_energy_LEACH_random(a) + sum(Energy_LEACH_random);
        
        %% LEACH random choose of cluster - power control
        Pt = power_control (N_dBm, Path_loss, SINRth);
        Pr = Pt - Path_loss;
        SNR_to_CH = Pt - Path_loss - N_dBm; % in dB
        SNR = 10.^(SNR_to_CH/10);
        C_to_CH = capacity(BW,SNR); % capacity to cluster head
        Data_CH = data_CH (CH_assoc, Data, Number_CH); % data from each CH to sink
        
        %%%% calculation of power consumption
        Pcon_LEACH_random_PC_to_CH = Pcon_function(Pt,Pr,C_to_CH,1,0,cluster);
        Pcon_LEACH_random_PC_to_sink = Pcon_function(Pt,Pr,Cap_to_sink,1,0,cluster);
        for i = 1:length(cluster)
            Pcon_LEACH_random_PC_to_CH(cluster(i)) = Pcon_LEACH_random_PC_to_sink(i);
        end
        Pcon_LEACH_random_PC = Pcon_LEACH_random_PC_to_CH;
        %%%% calculation of consumed energy
        T_LEACH_random_PC_to_CH = Data./(C_to_CH*1e6); % transmission time in seconds
        T_LEACH_random_PC_to_sink = Data_CH./(Cap_to_sink*1e6); % transmission time in seconds
        for i = 1:length(cluster)
            T_LEACH_random_PC_to_CH(cluster(i)) = T_LEACH_random_PC_to_sink(i);
        end
        T_LEACH_random_PC = T_LEACH_random_PC_to_CH;
        Energy_LEACH_random_PC = T_LEACH_random_PC.*Pcon_LEACH_random_PC;
        Total_energy_LEACH_random_PC(a) = Total_energy_LEACH_random_PC(a) + sum(Energy_LEACH_random_PC);
        
        %% LEACH k-means++ cluster with - full power
        cluster = choose_point_with_probability(Pos_MS,Number_MS,Number_CH);
        [d_to_CH CH_assoc] = MS_association (Pos_MS, cluster);
        Path_loss = pathloss(Number_MS,d_to_CH,f);
        Pr = Pt_full - Path_loss;
        SNR_to_CH = Pt_full - Path_loss - N_dBm; % in dB
        SNR = 10.^(SNR_to_CH/10);
        C_to_CH = capacity(BW,SNR); % capacity to cluster head
        Data_CH = data_CH (CH_assoc, Data, Number_CH); % data from each CH to sink
        for k = 1:Number_CH
            Cap_to_sink (k) = C_to_sink(cluster(k)); % capacity from CH to sink
        end
        
        %%%% calculation of power consumption
        Pcon_LEACH_kmeans_to_CH = Pcon_function(Pt_full,Pr,C_to_CH,1,0,cluster);
        Pcon_LEACH_kmeans_to_sink = Pcon_function(Pt_full,Pr,Cap_to_sink,1,0,cluster);
        for i = 1:length(cluster)
            Pcon_LEACH_kmeans_to_CH(cluster(i)) = Pcon_LEACH_kmeans_to_sink(i);
        end
        Pcon_LEACH_kmeans = Pcon_LEACH_kmeans_to_CH;
        %%%% calculation of consumed energy
        T_LEACH_kmeans_to_CH = Data./(C_to_CH*1e6); % transmission time in seconds
        T_LEACH_kmeans_to_sink = Data_CH./(Cap_to_sink*1e6); % transmission time in seconds
        for i = 1:length(cluster)
            T_LEACH_kmeans_to_CH(cluster(i)) = T_LEACH_kmeans_to_sink(i);
        end
        T_LEACH_kmeans = T_LEACH_kmeans_to_CH;
        Energy_LEACH_kmeans = T_LEACH_kmeans.*Pcon_LEACH_kmeans;
        Total_energy_LEACH_kmeans(a) = Total_energy_LEACH_kmeans(a) + sum(Energy_LEACH_kmeans);
        
        %% LEACH k-means++ cluster with - power control
        Pt = power_control (N_dBm, Path_loss, SINRth);
        Pr = Pt - Path_loss;
        SNR_to_CH = Pt - Path_loss - N_dBm; % in dB
        SNR = 10.^(SNR_to_CH/10);
        C_to_CH = capacity(BW,SNR); % capacity to cluster head
        
        %%%% calculation of power consumption
        Pcon_LEACH_kmeans_PC_to_CH = Pcon_function(Pt,Pr,C_to_CH,1,0,cluster);
        Pcon_LEACH_kmeans_PC_to_sink = Pcon_function(Pt,Pr,Cap_to_sink,1,0,cluster);
        for i = 1:length(cluster)
            Pcon_LEACH_kmeans_PC_to_CH(cluster(i)) = Pcon_LEACH_kmeans_PC_to_sink(i);
        end
        Pcon_LEACH_kmeans_PC = Pcon_LEACH_kmeans_PC_to_CH;
        %%%% calculation of consumed energy
        T_LEACH_kmeans_PC_to_CH = Data./(C_to_CH*1e6); % transmission time in seconds
        T_LEACH_kmeans_PC_to_sink = Data_CH./(Cap_to_sink*1e6); % transmission time in seconds
        for i = 1:length(cluster)
            T_LEACH_kmeans_PC_to_CH(cluster(i)) = T_LEACH_kmeans_PC_to_sink(i);
        end
        T_LEACH_kmeans_PC = T_LEACH_kmeans_PC_to_CH;
        Energy_LEACH_kmeans_PC = T_LEACH_kmeans_PC.*Pcon_LEACH_kmeans_PC;
        Total_energy_LEACH_kmeans_PC(a) = Total_energy_LEACH_kmeans_PC(a) + sum(Energy_LEACH_kmeans_PC);
        
    
%% computation of the average energy
% Total_energy_LEACH_random_all(b,:) = Total_energy_LEACH_random/sim_time;
% Total_energy_LEACH_kmeans_all(b,:) = Total_energy_LEACH_kmeans/sim_time;
% Total_energy_LEACH_random_PC_all(b,:) = Total_energy_LEACH_random_PC/sim_time;
% Total_energy_LEACH_kmeans_PC_all(b,:) = Total_energy_LEACH_kmeans_PC/sim_time;
% Total_energy_Direct_all(b,:) = Total_energy_Direct/sim_time;
% Total_energy_Direct_PC_all(b,:) = Total_energy_Direct_PC/sim_time;    
end
end


%% computation of the average energy
sim_time=1;
Total_energy_LEACH_random_a = Total_energy_LEACH_random/sim_time;
Total_energy_LEACH_kmeans_a = Total_energy_LEACH_kmeans/sim_time;
Total_energy_LEACH_random_PC_a =Total_energy_LEACH_random_PC/sim_time;
Total_energy_LEACH_kmeans_PC_a = Total_energy_LEACH_kmeans_PC/sim_time;
Total_energy_Direct_a = Total_energy_Direct/sim_time;
Total_energy_Direct_PC_a =  Total_energy_Direct_PC/sim_time;    

%% results
% figure
% plot (Area, Total_energy_LEACH_random_a)
% hold on
% % plot (Area, Total_energy_LEACH_random_PC_a)
% % plot (Area, Total_energy_LEACH_kmeans_a)
% % plot (Area, Total_energy_LEACH_kmeans_PC_a)
% plot (Area, Total_energy_Direct_a)
% % plot (Area, Total_energy_Direct_PC_a)
% % axis([0 Area(length(Area))+500 0 Inf])
% xlim([Area(1) Area(end)]);
% grid on
% % legend('LEACH random','LEACH random - PC','LEACH k-means++','LEACH k-means++ - PC','Direct full power','Direct power control')
% 
% legend('LEACH random','Direct full power')
% title ('Total energy consumption for different protocols')
% xlabel ('Area size')
% ylabel ('Energy consumption')
end
% stop=3;

