function bits = dec2bi( n, k )
%DEC2BI Converts a number into a k-bit binary vector

    if(k == 1)
        if(n < 2)
            bits = n;
            return;
        else
            throw error;
        end
    end
    
    r = mod(n, 2);
    
    bits = [utils.dec2bi(idivide(n, 2), k-1), r];

end

