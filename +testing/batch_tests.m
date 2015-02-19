%% Passthrough barcoder

% Make sure volume is at appropriate level before running this

match_file_function     = @algorithms.barcoder.match_file;
get_song_name_function  = @algorithms.barcoder.get_song_name;
database_filename       = 'barcoder.db';
clip_length             = 10;
test_clips_folder       = ['./test_clips/passthrough/' num2str(clip_length) 'sec/'];
input_folder            = './library/';
scoring_mode            = 'min';
m                       = 9;

bcp = testing.run_passthrough_tests(match_file_function, ...
                                    get_song_name_function, ...
                                    database_filename, ...
                                    test_clips_folder, ...
                                    input_folder, ...
                                    scoring_mode, ...
                                    clip_length, ...
                                    m);
                  
                  
% Passthrough constellation

% Make sure volume is at appropriate level before running this

match_file_function     = @algorithms.constellation.match_file;
get_song_name_function  = @algorithms.constellation.get_song_name;
database_filename       = 'constellation.db';
clip_length             = 10;
test_clips_folder       = ['./test_clips/passthrough/' num2str(clip_length) 'sec/'];
input_folder            = './library/';
scoring_mode            = 'max';
m                       = 9;

cop = testing.run_passthrough_tests(match_file_function, ...
                                    get_song_name_function, ...
                                    database_filename, ...
                                    test_clips_folder, ...
                                    input_folder, ...
                                    scoring_mode, ...
                                    clip_length, ...
                                    m);
                  
                  
%% Gaussian barcoder

                             
scoring_mode            = 'min';
m                       = 10;
input_folder            = './library/';
test_clips_base_folder  = './test_clips/gaussian_noise/';
database_filename       = 'barcoder.db';
match_file_function     = @algorithms.barcoder.match_file;
get_song_name_function  = @algorithms.barcoder.get_song_name;

snrs                    = [-9, -6, -3, 0, 3, 6, 9];
lengths                 = [5, 10, 15];

[snr, len, succ, tot] = testing.run_gaussian_batch(snrs, ...
                                                   lengths, ...
                                                   database_filename, ...
                                                   match_file_function, ...
                                                   get_song_name_function, ...
                                                   input_folder, ...
                                                   test_clips_base_folder, ...
                                                   scoring_mode, ...
                                                   m);
                                               
 save('gaussian_barcoder_results.mat', 'snr', 'len', 'succ', 'tot');
                  
                  
% Gaussian constellation

scoring_mode            = 'max';
m                       = 10;
input_folder            = './library/';
test_clips_base_folder  = './test_clips/gaussian_noise/';
database_filename       = 'constellation.db';
match_file_function     = @algorithms.constellation.match_file;
get_song_name_function  = @algorithms.constellation.get_song_name;

snrs                    = [-9, -6, -3, 0, 3, 6, 9];
lengths                 = [5, 10, 15];

[snr, len, succ, tot] = testing.run_gaussian_batch(snrs, ...
                                                   lengths, ...
                                                   database_filename, ...
                                                   match_file_function, ...
                                                   get_song_name_function, ...
                                                   input_folder, ...
                                                   test_clips_base_folder, ...
                                                   scoring_mode, ...
                                                   m);
                                               
                                               
 save('gaussian_constellation_results.mat', 'snr', 'len', 'succ', 'tot');
               
 
                  
%% Basic barcoder

match_file_function     = @algorithms.barcoder.match_file;
get_song_name_function  = @algorithms.barcoder.get_song_name;
database_filename       = 'barcoder.db';
clip_length             = 5;
test_clips_folder       = ['./test_clips/basic/' num2str(clip_length) 'sec/'];
input_folder            = './library/';
scoring_mode            = 'min';
m                       = 5;

testing.run_basic_tests(match_file_function, ...
                        get_song_name_function, ...
                        database_filename, ...
                        test_clips_folder, ...
                        input_folder, ...
                        scoring_mode, ...
                        clip_length, ...
                        m)
                  
                  
%% Basic constellation

match_file_function     = @algorithms.constellation.match_file;
get_song_name_function  = @algorithms.constellation.get_song_name;
database_filename       = 'constellation.db';
clip_length             = 5;
test_clips_folder       = ['./test_clips/basic/' num2str(clip_length) 'sec/'];
input_folder            = './library/';
scoring_mode            = 'max';
m                       = 5;

testing.run_basic_tests(match_file_function, ...
                        get_song_name_function, ...
                        database_filename, ...
                        test_clips_folder, ...
                        input_folder, ...
                        scoring_mode, ...
                        clip_length, ...
                        m)
                  
