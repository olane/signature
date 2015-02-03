function [ songScores ] = match_clip( audio, db_handle )
%MATCH_SONG Takes some audio (mono, at the same sample rate as was
%registered to the database) and matches it against the database. Returns a
%matrix where each row is a [songid, score] pair where a higher score means
%a closer match. 
%   What constitutes a 'good' score is dependent on the input audio, the
%   song and particularly on the length of the input clip.
    
    
    disp('Creating index if not exists');
    tic
    sqlite3.execute(db_handle, 'CREATE INDEX IF NOT EXISTS hash_index ON hashes(hash)');
    toc
    
    
    disp('Getting fingerprint for clip');
    tic
    hlist = algorithms.constellation.fingerprinter.get_fingerprint(audio);
    toc
    
    
    disp('Getting matching hashes and binning according to song id');
    tic
    
    songsToHashMatches = containers.Map('KeyType','int32','ValueType','any');
    
    for h = hlist'
        
        hashtime = h(1);
        hashval = h(2);
        
        hash_matches = sqlite3.execute(db_handle, 'SELECT * FROM hashes WHERE hash=?', hashval);
        
        for hash_match = hash_matches
            
            if(songsToHashMatches.isKey(hash_match.song_id))
                
                songsToHashMatches(hash_match.song_id) = ...
                    [songsToHashMatches(hash_match.song_id) ...
                     struct('songtime', hash_match.time, 'cliptime', hashtime)];
            
            else
                
                songsToHashMatches(hash_match.song_id) = ...
                    [struct('songtime', hash_match.time, 'cliptime', hashtime)];
            
            end
            
        end
        
    end
    
    toc
    
    
    disp('Calculating scores from hashes');
    tic
    
    % If a song matches less than this number of hashes, it is not
    % considered for matching. Gives speed at the cost of increased
    % probability of false negatives
    match_threshold = 1;
    
    songScores = zeros(length(keys(songsToHashMatches)), 2);
    
    i = 1;
    
    
    for songid = cell2mat(keys(songsToHashMatches))
        
        matches = songsToHashMatches(songid);
        
        if(length(matches) < match_threshold)
            continue;
        end
        
        hist = [];
        
        for match = matches
            dt = match.songtime - match.cliptime;
            
            % Don't accept negative values -- this means we can't recognise
            % songs that start part way through the clip, but makes dealing
            % with the data structure easier.
            if(dt > 0)
                % Bin values
                if(length(hist) < dt)
                    hist(dt) = 1;
                else
                    hist(dt) = hist(dt) + 1;
                end
            end
        end
        
        score = max(hist);
        
        songScores(i, 1) = songid;
        songScores(i, 2) = score;
        i =  i + 1;
    end

    songScores(i:end, :) = [];
    
    toc
    
end

