
%% Register all songs

    
addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

database_filename = 'constellation-new.db';

folder = './library/';

utils.register_all_songs(database_filename, folder, ...
                         @algorithms.constellation.initialise_db, ...
                         @algorithms.constellation.register_song, ...
                         @algorithms.constellation.cleanup_db)



%% Match clip


addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

database_filename = 'constellation.db';
filename = './test_clips/basic/(01) - Calvin Harris - Faith_sample_60-70.ogg';

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

