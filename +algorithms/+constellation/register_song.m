function register_song( database_handle, audio, song_name )
%REGISTER_SONG Registers a song in the database.
%   Calculates a fingerprint and inserts it into the database. Takes mono,
%   16kHz audio (to match the sample rate that the matcher expects, since
%   all times are in samples, not seconds).

    
    c = sqlite3.execute(database_handle, ...
                        'SELECT song_id FROM songs WHERE song_name=?', ...
                        song_name);
    
    if(~isempty(c))
        disp('Not inserting, name already exists in database');
        return;
    end
    
    tic
    hlist = algorithms.constellation.fingerprinter.get_fingerprint(audio);
    
    disp('Analysed song');
    toc
    
    %% Database initialisation
    
    
    exists = sqlite3.execute(database_handle, ...
                             ['SELECT count(*) FROM sqlite_master '...
                              'WHERE type=''table'' AND name=''hashes''']);
                          
    if(exists.count ~= 1)
         sqlite3.execute(database_handle, ...
                         ['CREATE TABLE IF NOT EXISTS '...
                          'songs (song_id INTEGER PRIMARY KEY AUTOINCREMENT, '...
                                 'song_name VARCHAR)']);
                      
         sqlite3.execute(database_handle, ...
                         ['CREATE TABLE IF NOT EXISTS '...
                          'hashes (song_id INTEGER, '...
                                  'hash INTEGER, '...
                                  'time INTEGER)']);
                      
         sqlite3.execute(database_handle, ...
                         'CREATE INDEX hash_index ON hashes(hash)');
                     
         sqlite3.execute(database_handle, ...
                         'CREATE INDEX songname_index ON songs(song_name)');
    end
    
    disp('Checked database');
    
    %% Database insertion
    
    sqlite3.execute(database_handle, ...
                    'INSERT INTO songs VALUES (NULL, ?)', song_name);
    
    id = sqlite3.execute(database_handle, ...
                         'SELECT song_id FROM songs WHERE song_name=?', ...
                         song_name);
    
    id = id(1).song_id;
    
    disp(['Inserted song and got song ID ' num2str(id)]);
    
    
    tic
    sqlite3.execute(database_handle, 'BEGIN TRANSACTION;');
    
    for i = 1:length(hlist(:,1))
       sqlite3.execute(database_handle, ...
                       'INSERT INTO hashes(song_id, time, hash) VALUES (?, ?, ?)', ...
                       id, hlist(i, 1), hlist(i, 2));
    end
    
    sqlite3.execute(database_handle, 'END TRANSACTION;');
    
    disp('Inserted hashes');
    toc
    
    %% Cleanup
    
    disp('Song successfully registered.');
    
end

