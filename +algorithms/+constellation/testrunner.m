

%% Fingerprinter 


filename = 'library/01 - Love Me Again.mp3';
sample = [0 50];

try
    inf = audioinfo(filename);
    sample = sample * inf.SampleRate + 1;
catch 
    sample = [0 20];
end


[D, sample_rate] = audioread(filename, sample);

D = mean(D, 2); %stereo to mono

target_sample_rate = 44100;

if(sample_rate ~= target_sample_rate)
    srgcd = gcd(sample_rate, target_sample_rate);
    D = resample(D,target_sample_rate/srgcd, sample_rate/srgcd); %resample to target rate
end



algorithms.constellation.fingerprinter.get_fingerprint(D);

