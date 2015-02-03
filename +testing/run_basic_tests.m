
addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');


input_folder = './library/';

test_clips_folder = './test_clips/basic/5sec/';

basic_clips = testing.extract_basic_clips(input_folder, test_clips_folder, ...
                                          40, 45, 9, ...
                                          @(a) a);

% 'min' or 'max' corresponding to which is the best score
scoring = 'max';

database_filename = 'constellation-8000.db';

db_handle = sqlite3.open(database_filename);


i = 0;
s = 0;
n = length(basic_clips);
results = repmat(struct('original', [], 'matched', [], ...
                        'score', [], 'correct', []), ...
                 n, ...
                 1);

for test = basic_clips
    
    i = i + 1;
    
    disp([num2str(i) '/' num2str(n)]);
    disp(['Matching ' test.clip])
    
    r = algorithms.constellation.match_file(test.clip, db_handle);
    
    if(isempty(r))
        disp('NO MATCHES');
        disp('---------');
        continue;
    end
    
    if(strcmp(scoring, 'min'))
        [val, ind] = min(r(:, 2));
    else
        [val, ind] = max(r(:, 2));
    end

    results(i).original = test.original;
    results(i).matched = algorithms.constellation.get_song_name(r(ind,1), db_handle);
    results(i).score = val;
    
    results(i).correct = strcmp(results(i).original, results(i).matched);
    
    if(results(i).correct)
        s = s + 1;
        disp('MATCH');
        disp(['Matched correctly as  ' results(i).matched ...
              ' with score ' num2str(results(i).score) ]);
    else
        disp('MISMATCH');
        disp(['Matched as  ' results(i).matched ...
              ' with score ' num2str(results(i).score) ...
              ' but should have been ' results(i).original ]);
    end
    
    disp('---------');
    
end

disp(['Matched ' num2str(s) '/' num2str(i) ' correctly.']);


sqlite3.close(db_handle);