

%% Fingerprinter 


filename = 'library/01 - Love Me Again.mp3';

inf = audioinfo(filename);
sample = [0 100] * inf.SampleRate + 1;

[D, sample_rate] = audioread(filename, sample);

D = mean(D, 2); %stereo to mono

target_sample_rate = 8000;

if(sample_rate ~= target_sample_rate)
    %resample to target rate
    srgcd = gcd(sample_rate, target_sample_rate);
    D = resample(D,target_sample_rate/srgcd, sample_rate/srgcd); 
end



h = algorithms.constellation.fingerprinter.get_fingerprint(D);


%% Register all songs

    
addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

database_filename = 'constellation-8000.db';

foldername = './library/';

algorithms.constellation.register_all_songs(foldername, database_filename);



%% Match clip


addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

database_filename = 'constellation-8000.db';
filename = './test_clips/basic/Caravan Palace - Beatophone (Club Mix)_sample_60-70.ogg';

db_handle = sqlite3.open(database_filename);

r = algorithms.constellation.match_file(filename, db_handle);

[val, ind] = max(r(:, 2));

track = algorithms.constellation.get_song_name(r(ind,1), db_handle)
score = val

sqlite3.close(db_handle);
