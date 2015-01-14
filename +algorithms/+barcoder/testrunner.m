
                 
%% register_song 


addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

database_filename = 'barcoder.db';

db_handle = sqlite3.open(database_filename);

filename = 'library/01 - Love Me Again.mp3';

algorithms.barcoder.initialise_db(db_handle);

algorithms.barcoder.register_song(db_handle, filename);

algorithms.barcoder.cleanup_db(db_handle);


%% register_all_songs



addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

database_filename = 'barcoder.db';

folder = './library/';

utils.register_all_songs(database_filename, folder, ...
                         @algorithms.barcoder.initialise_db, ...
                         @algorithms.barcoder.register_song, ...
                         @algorithms.barcoder.cleanup_db)

                     
%% match clip

addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

database_filename = 'barcoder.db';
filename = './test_clips/basic/(11) - Calvin Harris - Pray to God  (feat. Haim)_sample_60-70.ogg';


db_handle = sqlite3.open(database_filename);

r = algorithms.barcoder.match_file(filename, db_handle);
