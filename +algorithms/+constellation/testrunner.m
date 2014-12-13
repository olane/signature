

%% Fingerprinter 


filename = 'library/01 - Love Me Again.mp3';

inf = audioinfo(filename);
sample = [0 50] * inf.SampleRate + 1;

[D, sample_rate] = audioread(filename);

D = mean(D, 2); %stereo to mono

target_sample_rate = 16000;

if(sample_rate ~= target_sample_rate)
    %resample to target rate
    srgcd = gcd(sample_rate, target_sample_rate);
    D = resample(D,target_sample_rate/srgcd, sample_rate/srgcd); 
end



h = algorithms.constellation.fingerprinter.get_fingerprint(D);

%% register song

database_filename = 'constellation.db';
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

algorithms.constellation.register_song(database_filename, D, 'Love Me Again');

delete(database_filename);


%% Register all songs

foldername = './library/';
files = dir([foldername '*.mp3']);

disp(['Found ' num2str(length(files)) ' mp3 files in library.']);

for file = files'
    if ~file.isdir
        algorithms.constellation.register_song(database_filename, D, file.name);
        disp(['Registered song ' file.name]);
    end
end

