function out = match_file( filename, db_handle )
%MATCH_FILE Reads an audio file, then calls match_clip on it

    [D, sample_rate] = audioread(filename);

    D = mean(D, 2); %stereo to mono

    target_sample_rate = 8000;

    if(sample_rate ~= target_sample_rate)
        %resample to target rate
        srgcd = gcd(sample_rate, target_sample_rate);
        D = resample(D,target_sample_rate/srgcd, sample_rate/srgcd); 
    end

    
    out = algorithms.constellation.match_clip(D, db_handle);
    
end

