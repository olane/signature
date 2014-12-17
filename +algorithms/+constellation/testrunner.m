

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

database_filename = 'constellation_test.db';
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

algorithms.constellation.register_song(database_filename, D, 'Love ''Me Again');

delete(database_filename);


%% Register all songs

    
addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

database_filename = 'constellation.db';

foldername = './library/';

algorithms.constellation.register_all_songs(foldername, database_filename);



%% Match clip


addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

database_filename = 'constellation.db';
filename = './test_clips/basic/(11) - Calvin Harris - Pray to God  (feat. Haim)_sample_60-70.ogg';

db_handle = sqlite3.open(database_filename);

tic
r = algorithms.constellation.match_file(filename, db_handle)
toc

sqlite3.close(db_handle);
