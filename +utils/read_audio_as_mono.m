function audio = read_audio_as_mono( filename, sample_rate )
%READ_AUDIO_AS_MONO reads an audio file, converts it to mono and resamples
%to the specified sample rate.

    [audio, file_sample_rate] = audioread(filename);

    audio = mean(audio, 2); %stereo to mono

    if(file_sample_rate ~= sample_rate)
        %resample to target rate
        srgcd = gcd(file_sample_rate, sample_rate);
        audio = resample(audio, sample_rate/srgcd, file_sample_rate/srgcd); 
    end
    
end

