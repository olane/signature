%% Passthrough barcoder batch

% Pause before start to make sure tester doesn't disturb the first few
% clips. Length in seconds.
pause(1);

% Make sure volume is at appropriate level before running this

match_file_function     = @algorithms.barcoder.match_file;
get_song_name_function  = @algorithms.barcoder.get_song_name;
database_filename       = 'barcoder.db';
clip_lengths            = [5, 10, 15];
test_clips_base_folder  = './test_clips/passthrough/';
input_folder_base       = './test_clips/sets/';
scoring_mode            = 'min';

[set, len, succ, tot] = testing.run_passthrough_tests_batch ...
                            (match_file_function, ...
                             get_song_name_function, ...
                             database_filename, ...
                             test_clips_base_folder, ...
                             input_folder_base, ...
                             scoring_mode, ...
                             clip_lengths);
                  
save('passthrough_barcoder_results.mat', 'set', 'len', 'succ', 'tot');
                  
% Passthrough constellation batch

% Make sure volume is at appropriate level before running this

match_file_function     = @algorithms.constellation.match_file;
get_song_name_function  = @algorithms.constellation.get_song_name;
database_filename       = 'constellation.db';
clip_lengths            = [5, 10, 15];
test_clips_base_folder  = './test_clips/passthrough/';
input_folder_base       = './test_clips/sets/';
scoring_mode            = 'max';

[set, len, succ, tot] = testing.run_passthrough_tests_batch ...
                            (match_file_function, ...
                             get_song_name_function, ...
                             database_filename, ...
                             test_clips_base_folder, ...
                             input_folder_base, ...
                             scoring_mode, ...
                             clip_lengths);
                  
save('passthrough_constellation_results.mat', 'set', 'len', 'succ', 'tot');
                  
                  
%% Natural barcoder

                             
scoring_mode            = 'min';
input_folder_base       = './test_clips/sets/';
test_clips_base_folder  = './test_clips/natural_noise/';
database_filename       = 'barcoder.db';
match_file_function     = @algorithms.barcoder.match_file;
get_song_name_function  = @algorithms.barcoder.get_song_name;
noise_filename          = './noise_clips/shopping_mall_ambience.wav';

snrs                    = [-9, -6, -3, 0, 3, 6, 9];
lengths                 = [5, 10, 15];

[set, snr, len, succ, tot] = testing.run_natural_noise_batch ...
                                            (snrs, ...
                                             lengths, ...
                                             database_filename, ...
                                             match_file_function, ...
                                             get_song_name_function, ...
                                             input_folder_base, ...
                                             test_clips_base_folder, ...
                                             scoring_mode, ...
                                             noise_filename)
                                               
 save('natural_barcoder_results.mat', 'set', 'snr', 'len', 'succ', 'tot');
 
% Natural constellation

                             
scoring_mode            = 'max';
input_folder_base       = './test_clips/sets/';
test_clips_base_folder  = './test_clips/natural_noise/';
database_filename       = 'constellation.db';
match_file_function     = @algorithms.constellation.match_file;
get_song_name_function  = @algorithms.constellation.get_song_name;
noise_filename          = './noise_clips/shopping_mall_ambience.wav';

snrs                    = [-9, -6, -3, 0, 3, 6, 9];
lengths                 = [5, 10, 15];

[set, snr, len, succ, tot] = testing.run_natural_noise_batch ...
                                            (snrs, ...
                                             lengths, ...
                                             database_filename, ...
                                             match_file_function, ...
                                             get_song_name_function, ...
                                             input_folder_base, ...
                                             test_clips_base_folder, ...
                                             scoring_mode, ...
                                             noise_filename)
                                               
 save('natural_constellation_results.mat', 'set', 'snr', 'len', 'succ', 'tot');
 
 
%% Gaussian barcoder

                             
scoring_mode            = 'min';
input_folder_base       = './test_clips/sets/';
test_clips_base_folder  = './test_clips/gaussian_noise/';
database_filename       = 'barcoder.db';
match_file_function     = @algorithms.barcoder.match_file;
get_song_name_function  = @algorithms.barcoder.get_song_name;

snrs                    = [-9, -6, -3, 0, 3, 6, 9];
lengths                 = [5, 10, 15];

[set, snr, len, succ, tot] = testing.run_gaussian_batch(snrs, ...
                                                   lengths, ...
                                                   database_filename, ...
                                                   match_file_function, ...
                                                   get_song_name_function, ...
                                                   input_folder_base, ...
                                                   test_clips_base_folder, ...
                                                   scoring_mode);
                                               
 save('gaussian_barcoder_results.mat', 'set', 'snr', 'len', 'succ', 'tot');
                  
                  
% Gaussian constellation

scoring_mode            = 'max';
input_folder_base       = './test_clips/sets/';
test_clips_base_folder  = './test_clips/gaussian_noise/';
database_filename       = 'constellation.db';
match_file_function     = @algorithms.constellation.match_file;
get_song_name_function  = @algorithms.constellation.get_song_name;

snrs                    = [-9, -6, -3, 0, 3, 6, 9];
lengths                 = [5, 10, 15];

[set, snr, len, succ, tot] = testing.run_gaussian_batch(snrs, ...
                                                   lengths, ...
                                                   database_filename, ...
                                                   match_file_function, ...
                                                   get_song_name_function, ...
                                                   input_folder_base, ...
                                                   test_clips_base_folder, ...
                                                   scoring_mode);
                                               
                                               
 save('gaussian_constellation_results.mat', 'set', 'snr', 'len', 'succ', 'tot');
               
 
                  
%% Basic barcoder

match_file_function     = @algorithms.barcoder.match_file;
get_song_name_function  = @algorithms.barcoder.get_song_name;
database_filename       = 'barcoder.db';
clip_lengths            = [5];
test_clips_folder       = './test_clips/basic/';
input_folder_base       = './test_clips/sets/';
scoring_mode            = 'min';


[set, len, succ, tot] = testing.run_basic_tests_batch(match_file_function, ...
                                                      get_song_name_function, ...
                                                      database_filename, ...
                                                      test_clips_folder, ...
                                                      input_folder_base, ...
                                                      scoring_mode, ...
                                                      clip_lengths)
                  
                  
%% Basic constellation

match_file_function     = @algorithms.constellation.match_file;
get_song_name_function  = @algorithms.constellation.get_song_name;
database_filename       = 'constellation.db';
clip_lengths            = [5];
test_clips_folder       = './test_clips/basic/';
input_folder_base       = './test_clips/sets/';
scoring_mode            = 'max';

[set, len, succ, tot] = testing.run_basic_tests_batch(match_file_function, ...
                                                      get_song_name_function, ...
                                                      database_filename, ...
                                                      test_clips_folder, ...
                                                      input_folder_base, ...
                                                      scoring_mode, ...
                                                      clip_lengths)
                  
