function [ songScores ] = match_clip( audio, db_handle )
%MATCH_CLIP Takes some (mono, 5kHz) audio and matches it against the
%database. 

    %% Make sure index exists
    
    disp('Creating index if not exists');
    tic
    
    sqlite3.execute(db_handle, 'CREATE INDEX IF NOT EXISTS hash_index ON hashes(hash)');
    
    toc

    
    %% Calculate clip fingerprint
    
    disp('Getting clip fingerprint');
    tic
    
    F = algorithms.barcoder.get_fingerprint(audio, 5000);

    F_int = zeros(length(F(:,1)));
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
                candidates = [candidates; zeros(allocated, 4)];
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
    tic
    
    
    
    toc
    
end

