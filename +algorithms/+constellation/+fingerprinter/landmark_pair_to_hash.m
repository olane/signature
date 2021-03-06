function H = landmark_pair_to_hash( L )
%landmark_pair_to_hash takes a landmark pair in the form [anchor_time,
%anchor_freq, time_delta, frequency_delta] and packs it into a pair of the
%form [time, hash] where hash is a packed uint32 representing the pair, and
%time is a uint32.

    anchor_time = L(1,1);
    anchor_freq = L(1,2);
    time_delta = L(1,3);
    frequency_delta= L(1,4);
    
    % 12 bits for anchor frequency
    anchor_freq = rem(anchor_freq, 2^12);
    
    % 10 bits for time delta 
    time_delta = rem(time_delta, 2^10);
    
    % 10 bits for frequency delta
    frequency_delta = rem(frequency_delta, 2^10);
    
    packed = anchor_freq * 2^20 + time_delta * 2^10 + frequency_delta;
    
    H = [uint32(anchor_time), uint32(packed)];
    
end

