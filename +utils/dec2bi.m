function bits = dec2bi( n )
%DEC2BI Converts a number into a binary vector

    if(n < 2)
        bits = n;
        return;
    end
    
    r = mod(n, 2);
    
    bits = [utils.dec2bi(idivide(n, 2)), r];

end

