function num_matched = test_clips(clip_filenames, match_function, id_to_songname, scoring_dir, db_handle)
%TEST_CLIPS Runs all of the given clips through the match function. Returns
%the number of clips which were matched correctly.

%   match_function should take a test clip filename and a db handle, and
%   return a set of [song_id, score] results

%   id_to_songname should take a song id and a db handle and return the
%   song name with that id

%   scoring_dir should be 'min' or 'max' corresponding to which is the best
%   score 

    i = 0;
    s = 0;
    n = length(clip_filenames);
    results = repmat(struct('original', [], 'matched', [], ...
                            'score', [], 'correct', []), ...
                     n, ...
                     1);
                 
    for test = clip_filenames

        i = i + 1;

        disp([num2str(i) '/' num2str(n)]);
        disp(['Matching ' test.clip])

        r = match_function(test.clip, db_handle);

        if(isempty(r))
            disp('NO MATCHES');
            disp('---------');
            continue;
        end

        if(strcmp(scoring_dir, 'min'))
            [val, ind] = min(r(:, 2));
        else
            [val, ind] = max(r(:, 2));
        end


        results(i).original = utils.strip_folder(test.original);
        results(i).matched = utils.strip_folder(id_to_songname(r(ind,1), db_handle));
        results(i).score = val;

        results(i).correct = strcmp(results(i).original, results(i).matched);

        if(results(i).correct)
            s = s + 1;
            disp('MATCH');
            disp(['Matched correctly as  ' char(results(i).matched) ...
                  ' with score ' num2str(results(i).score) ]);
        else
            disp('MISMATCH');
            disp(['Matched as  ' char(results(i).matched) ...
                  ' with score ' num2str(results(i).score) ...
                  ' but should have been ' char(results(i).original) ]);
        end

        disp('---------');

    end
    
    num_matched = s;
    
end

