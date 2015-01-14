function [ songScores ] = match_clip( audio, db_handle )
%MATCH_CLIP Takes some (mono, 5kHz) audio and matches it against the
%database. Returns a set of [song_id, start_hash, score] rows. Lower scores
%are better.

    %% Make sure index exists
    
    disp('Creating index if not exists');
    tic
    
    sqlite3.execute(db_handle, 'CREATE INDEX IF NOT EXISTS hash_index ON hashes(hash)');
    
    toc

    
    %% Calculate clip fingerprint
    
    disp('Getting clip fingerprint');
    tic
    
    F = algorithms.barcoder.get_fingerprint(audio, 5000);

    F_int = zeros(length(F(:,1)), 1);
    for i=1:length(F(:,1))
        F_int(i) = utils.bi2dec(F(i,:));
    end
    
    toc
    
    %% Find candidate positions
    
    disp('Finding candidate positions');
    tic
    
    
    start_block_size = 1000;
    n = 0;
    allocated = start_block_size;
    candidates = zeros(start_block_size, 2);
    
    for i = 1:length(F_int)
        
        hashtime = i;
        hashval = F_int(i);
        hash_matches = sqlite3.execute(db_handle, 'SELECT * FROM hashes WHERE hash=?', hashval);

        for hash_match = hash_matches
            
            % Add this possible starting position to our list
            candidates(n+1, :) = [hash_match.song_id, hash_match.hash_number - i];
            n = n + 1;
            
            if(allocated == n)
                % We need more space, double the size
                candidates = [candidates; zeros(allocated, 2)];
                allocated = allocated * 2;
            end
            
        end
        
    end
    
    % Discard unused allocated space
    candidates((n+1):end, :) = [];
    
    % Remove duplicates
    candidates = unique(candidates, 'rows');
    
    toc
    
    %% Retrieve candidate position hashes and calculate scores
    
    disp('Scoring candidate positions');
    
    
    scores = zeros(length(candidates(:,1)), 3);
    
    for i = 1:length(candidates(:,1))
        tic
        song_id = candidates(i, 1);
        start_hash = candidates(i, 2);
        end_hash = start_hash + length(F_int);
        
        hashes = algorithms.barcoder.get_hash_section(db_handle, ...
                                                      song_id, ...
                                                      start_hash, ...
                                                      end_hash); 
        
        hashes_bi = zeros(length(hashes(:,1)), 32);
        
        for j = 1:length(hashes)
            hashes_bi(j, :) = bitget(hashes(j), 32:-1:1);
        end
                                                  
        distance = algorithms.barcoder.hamming_distance(hashes_bi, F);
        
        scores(i, 1) = song_id;
        scores(i, 2) = start_hash;
        scores(i, 3) = distance;
        
    toc
    end
    
    
    
    disp('Finding best score for each song');
    tic
    
    songScores = [];
    song_ids = unique(scores(:,1));
    
    for n = 1:length(song_ids)
        
        min = 1e100;
        
        for k = 1:length(scores(:,1))
            if(scores(k, 1) == song_ids(n) && min > scores(k, 3)) 
                min = scores(k, 3);
            end
        end
        
        songScores(n, 1) = song_ids(n);
        songScores(n, 2) = min;
        
    end
    
    
    toc
    
end

