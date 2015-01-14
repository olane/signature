function distance = hamming_distance( bits1, bits2 )
%HAMMING_DISTANCE Finds the hamming distance between two vectors of bits.
%The two lists should be equal length.

    distance = 0;

    for i = 1:length(bits1)
        if(bits1(i) ~= bits2(i))
            distance = distance + 1;
        end
    end

end

