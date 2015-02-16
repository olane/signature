function result = run_gaussian_tests(match_file_function, get_song_name_function, database_filename, test_clips_folder, input_folder, scoring_mode, clip_length, m, snr)

    addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');
   
    clips = testing.extract_clips(input_folder, test_clips_folder, ...
                                  40, 40+clip_length, m, ...
                                  @(a, Fs) utils.add_gaussian_noise(a, snr, true));

    db_handle = sqlite3.open(database_filename);

    result = testing.test_clips(clips, ...
                                match_file_function, ...
                                get_song_name_function, ...
                                scoring_mode, ...
                                db_handle);


    disp(['Matched ' num2str(result) '/' num2str(length(clips)) ' correctly.']);

    sqlite3.close(db_handle);

end