function register_song( db_handle, audio, sample_rate, song_name )
%REGISTER_SONG Registers a song in the database.
%   Calculates a fingerprint and inserts it into the database. Takes mono
%   audio.

    %% Analysis
    
    tic
    F = algorithms.barcoder.get_fingerprint(audio, sample_rate);
    
    disp('Analysed song');
    toc
    
    
    tic
    F_int = zeros(length(F(:,1)));
    
    for i=1:length(F(:,1))
        F_int(i) = utils.bi2dec(F(i,:));
    end
    
    disp('Packed hashes');
    toc
    
    
    %% DB insertion

    sqlite3.execute(db_handle, ...
                    'INSERT INTO songs VALUES (NULL, ?)', song_name);
    
    id = sqlite3.execute(db_handle, ...
                         'SELECT song_id FROM songs WHERE song_name=?', ...
                         song_name);
    
    id = id(1).song_id;
    
    disp(['Inserted song and got song ID ' num2str(id)]);
    
    
    tic
    sqlite3.execute(db_handle, 'BEGIN TRANSACTION;');
    
    for i = 1:length(F_int)
       sqlite3.execute(db_handle, ...
                       'INSERT INTO hashes(song_id, hash, hash_number) VALUES (?, ?, ?)', ...
                       id, F(i), i);
    end
    
    sqlite3.execute(db_handle, 'END TRANSACTION;');
    
    disp('Inserted hashes');
    toc
    
    
    %% Cleanup
    
    disp('Song successfully registered.');
    

end

