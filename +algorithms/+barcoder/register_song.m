function register_song( db_handle, song_filename )
%REGISTER_SONG Registers a song in the database.
%   Calculates a fingerprint and inserts it into the database. Takes mono
%   audio.

    %% Reading and resampling
    
    tic
    disp('Reading and resampling audio');
    
    [audio, sample_rate] = audioread(song_filename);

    audio = mean(audio, 2); %stereo to mono

    target_sample_rate = 5000;

    if(sample_rate ~= target_sample_rate)
        %resample to target rate
        srgcd = gcd(sample_rate, target_sample_rate);
        audio = resample(audio, target_sample_rate/srgcd, sample_rate/srgcd); 
    end
    toc

    %% Analysis
    
    tic
    disp('Analysing song');
    F = algorithms.barcoder.get_fingerprint(audio, target_sample_rate);
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
                    'INSERT INTO songs VALUES (NULL, ?)', song_filename);
    
    id = sqlite3.execute(db_handle, ...
                         'SELECT song_id FROM songs WHERE song_name=?', ...
                         song_filename);
    
    id = id(1).song_id;
    
    disp(['Inserted song and got song ID ' num2str(id)]);
    
    
    tic
    sqlite3.execute(db_handle, 'BEGIN TRANSACTION;');
    
    for i = 1:length(F_int)
       sqlite3.execute(db_handle, ...
                       'INSERT INTO hashes(song_id, hash, hash_number) VALUES (?, ?, ?)', ...
                       id, F_int(i), i);
    end
    
    sqlite3.execute(db_handle, 'END TRANSACTION;');
    
    disp('Inserted hashes');
    toc
    
    
    %% Cleanup
    
    disp('Song successfully registered.');
    

end

