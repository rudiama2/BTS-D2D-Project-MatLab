function [Total_energy_LEACH_random_b, Total_energy_Direct_b, Total_energy_pegasis_b, Total_energy_dream_b...
    ,Efficiency_DIRECT_a, Efficiency_PEGASIS_a, Efficiency_LEACH_a, Efficiency_DREAM_a...
    ,Total_energy_LEACH_random_a,Total_energy_Direct_a,Total_energy_pegasis_a,Total_energy_dream_a,clustersss]=main_over_drops_final(Area,sim_time)
%% Declaration of Main simulations parameters
Number_MS = 150; % Number of CUE in the system
Number_CH = 10; % Number of cluster heads in system
const(1) = 4; % minimum constrain in meters
const(2) = 1400; % maximum constrain in meters
f = 2; % carrier frequency in GHz
Pt_full = 20;  %transmission power in dBm
BW = 20*10.^6;  % channel bandwidth
Data = 20e6; % packet size

%% calculation of noise
N_W = (BW*4*10.^-12)/10.^9; % noise [W]
N_dBm = 10*log10(N_W/0.001); % noise [dBm]

%% matrix for faster computation
Total_energy_LEACH_random = zeros(1,length(Area));
Total_energy_Direct = zeros(1,length(Area));
Total_energy_pegasis = zeros(1,length(Area));
Total_energy_dream = zeros(1,length(Area));

Total_energy_LEACH_random_b = zeros(1,sim_time+1);
Total_energy_Direct_b = zeros(1,sim_time+1);
Total_energy_pegasis_b = zeros(1,sim_time+1);
Total_energy_dream_b = zeros(1,sim_time+1);

Efficiency_DIRECT = zeros(1,length(Area));
Efficiency_PEGASIS = zeros(1,length(Area));
Efficiency_LEACH = zeros(1,length(Area));
Efficiency_DREAM = zeros(1,length(Area));

clustersss=zeros(sim_time,Number_CH);
%% simulation
for a = 1:length(Area)
    
    Area_x = Area(a); % Definition of Area in meters (x-axes)
    Area_y = Area(a); % Definition of Area in meters (y-axes)
    
    %%%% generation of position
    Pos_MS = MS_position(Area_x,Area_y,Number_MS,const); % position of MS
    Pos_sink = [Area_x; Area_y]; % position of sink
    coordinates_movers = mobility(Pos_MS, Area_x, sim_time);
    
    for b = 1:sim_time+1
        used_clusters=[];
        for i = 1:length(Pos_MS)
            Pos_MS(1,i)=coordinates_movers(1,b,i);
            Pos_MS(2,i)=coordinates_movers(2,b,i);
            if Pos_MS(1,i) == Area_x
                Pos_MS(1,i) = Area_x - 0.001;
            elseif Pos_MS(2,i) == Area_x
                Pos_MS(2,i) = Area_x - 0.001;
            end
        end
        %% dream
        if b == 1
            [chain,pos_x_source] = dream2 (Area_x, Number_MS, Pos_MS);
        else
            [chain] = dream3 (Area_x, Number_MS, Pos_MS, pos_x_source);
        end
        PL_first = PL_dream (chain,Pos_MS,Area_x,f);
        Pr_1 = Pt_full - PL_first;
        SNR_first_chain = Pt_full - PL_first - N_dBm; % in dB
        SNR_1 = 10.^(SNR_first_chain/10);
        C_1 = capacity(BW,SNR_1);
        [size,~] = one_bit_transmit (C_1);
        Pcon_dream = Pcon_function(Pt_full,Pr_1,C_1,1,0,1,1);
        T_dream = Data./(C_1*1e6); % transmission time in seconds
        T_bit = size./(C_1*1e6); 
        Energy_DREAM = T_dream.*Pcon_dream;
        Energy_DREAM_1bit = T_bit.*Pcon_dream;
        Total_energy_dream(a) = Total_energy_dream(a) + sum(Energy_DREAM);
        Efficiency_DREAM(a) = Efficiency_DREAM(a) + (size/sum(Energy_DREAM_1bit));
        if a == 1
            Total_energy_dream_b(b) = sum(Energy_DREAM);
        end
        
        %% direct transmition with full power
        d_to_sink = distance_2_points(Pos_sink,Pos_MS(:,pos_x_source));
        Path_loss = pathloss(1,d_to_sink,f);
        Pr = Pt_full - Path_loss;
        SNR_to_sink = Pt_full - Path_loss - N_dBm; % in dB
        SNR = 10.^(SNR_to_sink/10);
        C = capacity(BW,SNR); % capacity to sink
        %%%% calculation of power consumption
        Pcon_Direct = Pcon_function(Pt_full,Pr,C,1,0);
        %%%% calculation of consumed energy
        [size,~] = one_bit_transmit (C);
        T_Direct = Data/(C*1e6); % transmission time in seconds
        T_bit = size./(C*1e6);
        Energy_Direct = T_Direct*Pcon_Direct;
        Energy_DIRECT_1bit = T_bit*Pcon_Direct;
        Total_energy_Direct(a) = Total_energy_Direct(a) + sum(Energy_Direct);
        Efficiency_DIRECT(a) = Efficiency_DIRECT(a) + size/sum(Energy_DIRECT_1bit);
        if a == 1
            Total_energy_Direct_b(b) = sum(Energy_Direct);
        end
        
        %% LEACH random choose of cluster - full power
        probability=zeros(1,Number_MS);
        for i_proc=1:Number_MS
            probability(i_proc)=1/(Number_MS-((1-1)*Number_CH));
            if ismember(i_proc,used_clusters )==1
                probability(i_proc)=0;
            end
        end
        cluster = choose_point_with_probability2(Pos_MS,Number_CH,probability);
        if a==1
            clustersss(1,:)=cluster;
        end
        [d_to_CH ,CH_assoc] = MS_association (Pos_MS, cluster);
        Path_loss = pathloss(1,d_to_CH(pos_x_source),f);
        Pr1 = Pt_full - Path_loss;
        SNR = Pr1 - N_dBm;
        SNR_to_CH = 10.^(SNR/10);
        C_to_CH = capacity(BW,SNR_to_CH);
        pom = CH_assoc(pos_x_source);
        pom = cluster(pom);
        d_to_sink = distance_2_points(Pos_sink,Pos_MS(:,pom));
        Path_loss = pathloss(1,d_to_sink,f);
        Pr = Pt_full-Path_loss;
        SNR = Pr - N_dBm;
        SNR_to_sink = 10.^(SNR/10);
        C_to_sink=capacity(BW,SNR_to_sink);
        C_source_to_CH_to_sink = [C_to_CH C_to_sink];
        Pr_to_sink = [Pr1 Pr];
        if d_to_CH(pos_x_source) == 1e5
            C_source_to_CH_to_sink = C_to_sink;
            Pr_to_sink = Pr;
        end
        [size,~] = one_bit_transmit (C_source_to_CH_to_sink);
        Pcon_LEACH_random = Pcon_function(Pt_full,Pr_to_sink,C_source_to_CH_to_sink,1,0,1,1);
        T_LEACH_random = Data./(C_source_to_CH_to_sink*1e6); % transmission time in seconds
        T_bit = size./(C_source_to_CH_to_sink*1e6);
        Energy_LEACH_random = T_LEACH_random.*Pcon_LEACH_random;
        Energy_LEACH_1bit = T_bit.*Pcon_LEACH_random;
        Total_energy_LEACH_random(a) = Total_energy_LEACH_random(a) + sum(Energy_LEACH_random);
        Efficiency_LEACH(a) = Efficiency_LEACH(a) + size/sum(Energy_LEACH_1bit);
        if a == 1
            Total_energy_LEACH_random_b(b) = sum(Energy_LEACH_random);
        end
        
        %% pegasis
        [first_chain,second_chain] = pegasis2 (Area_x, Number_MS, Pos_MS);
        PL_first = PL_pegasis (first_chain,Pos_MS,Area_x,f);
        if ismember(pos_x_source,first_chain)==1
            Pr_1 = Pt_full - PL_first;
            SNR_first_chain = Pt_full - PL_first - N_dBm; % in dB
            SNR_1 = 10.^(SNR_first_chain/10);
            C_1 = capacity(BW,SNR_1);
            C_source = 0;
            for k = 1:length(C_1)
                C_source = C_source + C_1(k);
            end
            p_r_used=Pr_1(find(first_chain==pos_x_source):end);
            C_used=C_1(find(first_chain==pos_x_source):end);
            [size,~] = one_bit_transmit (C_used);
            Pcon_PEGASIS_first = Pcon_function(Pt_full,p_r_used,C_used,1,0,1,1);
            T_PEGASIS_first = Data./(C_used*1e6); % transmission time in seconds
            T_bit = size./(C_used*1e6);
            Energy_PEGASIS1 = T_PEGASIS_first.*Pcon_PEGASIS_first;
            Energy_PEGASIS_1bit = T_bit.*Pcon_PEGASIS_first;
            Total_energy_pegasis(a) = Total_energy_pegasis(a) + sum(Energy_PEGASIS1);
            Efficiency_PEGASIS(a) = Efficiency_PEGASIS(a) + size/sum(Energy_PEGASIS_1bit);
            if a == 1
                Total_energy_pegasis_b(b) = sum(Energy_PEGASIS1);
            end
        else
            PL_second = PL_pegasis (second_chain,Pos_MS,Area_x,f);
            Pr_2 = Pt_full - PL_second;
            SNR_second_chain = Pt_full - PL_second - N_dBm; % in dB
            SNR_2 = 10.^(SNR_second_chain/10);
            C_2 = capacity(BW,SNR_2);
            C_source = 0;
            for k = 1:length(C_2)
                C_source = C_source + C_2(k);
            end
            p_r_used=Pr_2(find(second_chain==pos_x_source):end);
            C_used=C_2(find(second_chain==pos_x_source):end);
            [size,~] = one_bit_transmit (C_used);
            Pcon_PEGASIS_first = Pcon_function(Pt_full,p_r_used,C_used,1,0,1,1);
            T_PEGASIS_first = Data./(C_used*1e6); % transmission time in seconds
            T_bit = size./(C_used*1e6);
            Energy_PEGASIS2 = T_PEGASIS_first.*Pcon_PEGASIS_first;
            Energy_PEGASIS_1bit = T_bit.*Pcon_PEGASIS_first;
            Total_energy_pegasis(a) = Total_energy_pegasis(a) + sum(Energy_PEGASIS2);
            Efficiency_PEGASIS(a) = Efficiency_PEGASIS(a) + size/sum(Energy_PEGASIS_1bit);
            if a == 1
                Total_energy_pegasis_b(b) = sum(Energy_PEGASIS2);
            end
        end
    end
end
Total_energy_LEACH_random_a = Total_energy_LEACH_random/(sim_time+1);
Total_energy_Direct_a = Total_energy_Direct/(sim_time+1);
Total_energy_pegasis_a = Total_energy_pegasis/(sim_time+1);
Total_energy_dream_a = Total_energy_dream/(sim_time+1);

Efficiency_DIRECT_a = Efficiency_DIRECT/(sim_time+1);
Efficiency_PEGASIS_a = Efficiency_PEGASIS/(sim_time+1);
Efficiency_LEACH_a = Efficiency_LEACH/(sim_time+1);
Efficiency_DREAM_a = Efficiency_DREAM/(sim_time+1);



end


