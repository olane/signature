function [matched, total] = run_passthrough_tests(match_file_function, get_song_name_function, database_filename, test_clips_folder, input_folder, scoring_mode, clip_length, m)

    addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');

    clips = testing.extract_clips(input_folder, test_clips_folder, ...
                                  clip_length, m, ...
                                  @(a, Fs) utils.microphone_passthrough(a, Fs, Fs, clip_length));

    db_handle = sqlite3.open(database_filename);

    matched = testing.test_clips(clips, ...
                                 match_file_function, ...
                                 get_song_name_function, ...
                                 scoring_mode, ...
                                 db_handle);

    total = length(clips);

    disp(['Matched ' num2str(matched) '/' num2str(total) ' correctly.']);

    sqlite3.close(db_handle);
    
end