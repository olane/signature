function n = bi2dec( bits )
%BI2DEC Converts a binary vector to a number

    l = length(bits);
    n = 0;
    
    for i = 1:length(bits)
        n = n + 2.^(i-1) * bits(l - i + 1);
    end

end

