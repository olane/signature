
%% Register all songs

    
addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

database_filename = 'constellation.db';

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
