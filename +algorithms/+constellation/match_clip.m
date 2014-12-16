function [ song_name ] = match_clip( audio, database_filename )
%MATCH_SONG Takes some (mono, 16kHz) audio and matches it against the
%database to find the song.
    
    hlist = algorithms.constellation.fingerprinter.get_fingerprint(audio);

    sqlite3.open(database_filename);
    
    songMap = containers.Map('KeyType','int32','ValueType','any');
    
    for h = hlist'
        
        hashtime = h(1);
        hashval = h(2);
        
        hash_matches = sqlite3.execute('SELECT * FROM hashes WHERE hash=?', hashval);
        
        for hash_match = hash_matches
            
            if(songMap.isKey(hash_match.song_id))
                
                songMap(hash_match.song_id) = ...
                    [songMap(hash_match.song_id) ...
                     struct('songtime', hash_match.time, 'cliptime', hashtime)];
            
            else
                
                songMap(hash_match.song_id) = ...
                    [struct('songtime', hash_match.time, 'cliptime', hashtime)];
            
            end
            
        end
        
    end

    
    sqlite3.close();
    
end

