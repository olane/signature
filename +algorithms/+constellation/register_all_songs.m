function register_all_songs( foldername, database_filename )
%REGISTER_ALL_SONGS calls register_song on all mp3 files in the given
%folder. Outputs a message after each registered song.
%   Currently downsamples to 16kHz.

    
    %% Database initialisation
    
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
                                  'time INTEGER)']);
                      
         % Drop our hash index to improve speed (we'll re-make it at the
         % end)
         sqlite3.execute(db_handle, ...
                         'DROP INDEX IF EXISTS hash_index');
                
         sqlite3.execute(db_handle, ...
                         'CREATE INDEX songname_index ON songs(song_name)');
    end
    
    disp('Checked database');
    
    %% Registration
    
    files = dir([foldername '*.mp3']);

    disp(['Found ' num2str(length(files)) ' mp3 files in library.']);
    
    counter = 1;

    for file = files'
        if (~file.isdir)
    
            
            filepath = [foldername file.name];
            
            disp(['Analysing song (' num2str(counter) '/' num2str(length(files)) '): ' filepath]);
            
            
            c = sqlite3.execute(db_handle, ...
                                'SELECT song_id FROM songs WHERE song_name=?', ...
                                filepath);

            if(~isempty(c))
                disp('Not inserting, name already exists in database');
                counter = counter + 1;
                continue;
            end

            [D, sample_rate] = audioread(filepath);

            D = mean(D, 2); %stereo to mono

            target_sample_rate = 12000;

            if(sample_rate ~= target_sample_rate)
                %resample to target rate
                srgcd = gcd(sample_rate, target_sample_rate);
                D = resample(D,target_sample_rate/srgcd, sample_rate/srgcd); 
            end
            
            algorithms.constellation.register_song(db_handle, D, filepath);
            
            disp('-----');
            
            counter = counter + 1;
            
        end
    end
    
    tic
    disp('Remaking index')
    sqlite3.execute(db_handle, 'CREATE INDEX IF NOT EXISTS hash_index ON hashes(hash)');
    disp('Remade index')
    toc
    
    sqlite3.close(db_handle);
    
end

