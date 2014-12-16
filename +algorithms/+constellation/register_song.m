function register_song( database_filename, audio, song_name )
%REGISTER_SONG Registers a song in the database.
%   Calculates a fingerprint and inserts it into the database. Takes mono,
%   16kHz audio (to match the sample rate that the matcher expects, since
%   all times are in samples, not seconds).

    hlist = algorithms.constellation.fingerprinter.get_fingerprint(audio);
    
    disp('Analysed song');

    %% Database initialisation
    
    sqlite3.open(database_filename);
    
    exists = sqlite3.execute(['SELECT count(*) FROM sqlite_master '...
                              'WHERE type=''table'' AND name=''hashes''']);
                          
    if(exists.count ~= 1)
         sqlite3.execute(['CREATE TABLE IF NOT EXISTS '...
                          'songs (song_id INTEGER PRIMARY KEY, '...
                                 'song_name VARCHAR)']);
                      
         sqlite3.execute(['CREATE TABLE IF NOT EXISTS '...
                          'hashes (song_id INTEGER, '...
                                  'hash INTEGER, '...
                                  'time INTEGER)']);
                      
         sqlite3.execute('CREATE INDEX hash_index ON hashes(hash)');
    end
    
    disp('Checked database');
    
    %% Database insertion
    
    sqlite3.execute('INSERT INTO songs(song_name) VALUES (?)', song_name);
    
    id = sqlite3.execute('SELECT song_id FROM songs WHERE song_name=?', song_name);
    
    id = id(1).song_id;
    
    disp('Inserted song and got song ID');
    
    sqlite3.execute('BEGIN TRANSACTION;');
    
    for i = 1:length(hlist(:,1))
       sqlite3.execute('INSERT INTO hashes(song_id, time, hash) VALUES (?, ?, ?)', ...
                       id, hlist(i, 1), hlist(i, 2));
    end
    
    sqlite3.execute('END TRANSACTION;');
    
    disp('Inserted hashes');
    
    %% Cleanup
    
    sqlite3.close();
    
end

