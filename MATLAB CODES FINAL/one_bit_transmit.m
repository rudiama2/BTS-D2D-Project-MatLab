function [size,T_bit] = one_bit_transmit (capacity)

capacity = capacity*1e6; % in bits/s
T_bit = 1./capacity; %time to transmit 1 bit
size = 1/sum(T_bit); %size of data transmited in 1 second

end