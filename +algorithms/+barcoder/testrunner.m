


%% Database initialisation

addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

database_filename = 'barcoder.db';

db_handle = sqlite3.open(database_filename);

exists = sqlite3.execute(db_handle, ...
                         ['SELECT count(*) FROM sqlite_master '...
                          'WHERE type=''table'' AND name=''hashes''']);

if(exists.count ~= 1)
     sqlite3.execute(db_handle, ...
                     ['CREATE TABLE IF NOT EXISTS '...
                      'songs (song_id INTEGER PRIMARY KEY AUTOINCREMENT, '...
                             'song_name VARCHAR)']);

     sqlite3.execute(db_handle, ...
                     ['CREATE TABLE IF NOT EXISTS '...
                      'hashes (song_id INTEGER, '...
                              'hash INTEGER, '...
                              'hash_number INTEGER)']);


     sqlite3.execute(db_handle, ...
                     'CREATE INDEX songname_index ON songs(song_name)');
end

 % Drop our hash index to improve speed (we'll re-make it at the
 % end)
 sqlite3.execute(db_handle, ...
                 'DROP INDEX IF EXISTS hash_index');

                 
%% register_song 


addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

database_filename = 'barcoder.db';

db_handle = sqlite3.open(database_filename);

filename = 'library/01 - Love Me Again.mp3';

[D, sample_rate] = audioread(filename);

D = mean(D, 2); %stereo to mono

target_sample_rate = 5000;

if(sample_rate ~= target_sample_rate)
    %resample to target rate
    srgcd = gcd(sample_rate, target_sample_rate);
    D = resample(D,target_sample_rate/srgcd, sample_rate/srgcd); 
end


algorithms.barcoder.register_song(db_handle, D, target_sample_rate, filename);
