

%% Fingerprinter 


filename = 'library/01 - Love Me Again.mp3';

inf = audioinfo(filename);
sample = [0 50] * inf.SampleRate + 1;

[D, sample_rate] = audioread(filename, sample);

D = mean(D, 2); %stereo to mono

target_sample_rate = 16000;

if(sample_rate ~= target_sample_rate)
    %resample to target rate
    srgcd = gcd(sample_rate, target_sample_rate);
    D = resample(D,target_sample_rate/srgcd, sample_rate/srgcd); 
end



algorithms.constellation.fingerprinter.get_fingerprint(D);

