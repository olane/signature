
%% Fingerprinter 


filename = 'library/Backstreet Boys - Everybody (Backstreets Back) - Radio Edit.mp3';

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

database_filename = 'constellation-nnnn.db';

folder = './library/';

utils.register_all_songs(database_filename, folder, ...
                         @algorithms.constellation.initialise_db, ...
                         @algorithms.constellation.register_song, ...
                         @algorithms.constellation.cleanup_db)



%% Match clip


addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

database_filename = 'constellation-new.db';
filename = './test_clips/basic/5sec/(01) - Calvin Harris - Faith_40-45.ogg';

db_handle = sqlite3.open(database_filename);

r = algorithms.constellation.match_file(filename, db_handle);

[val, ind] = max(r(:, 2));

track = algorithms.constellation.get_song_name(r(ind,1), db_handle)
score = val

sqlite3.close(db_handle);




%% run basic tests

match_file_func = @algorithms.constellation.match_file;
get_song_func = @algorithms.constellation.get_song_name;
input_folder = './library/';
test_clips_folder = './test_clips/basic/5sec/';
database_filename = 'constellation.db'
scoring_mode = 'max';
clip_length = 5;
m = 1;
    
testing.run_basic_tests(match_file_func, ...
                        get_song_func, ...
                        database_filename, ...
                        test_clips_folder, ...
                        input_folder, ...
                        scoring_mode, ...
                        clip_length, ...
                        m);

