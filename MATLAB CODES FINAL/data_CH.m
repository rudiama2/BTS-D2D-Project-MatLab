function Data_CH = data_CH (CH_assoc, Data, Number_CH)
% compute how much data cluster head have to transmit

Data_CH = ones(1,Number_CH);
Data_CH = Data_CH*Data;
Data_CH (1) = Data*(Number_CH-1);

for i = 1:length(CH_assoc)
    for j = 1:Number_CH
        if CH_assoc (i) == j 
            Data_CH(j) = Data_CH(j) + Data;
        end
    end
end
end