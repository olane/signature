
cliplength = 5;
snr = 0; % dB
m = 5;


addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');
input_folder = './library/';
test_clips_folder = ['./test_clips/gaussian_noise/' num2str(cliplength) 'sec/' num2str(snr) 'db/'];
database_filename = 'constellation.db';

clips = testing.extract_clips(input_folder, test_clips_folder, ...
                              40, 40+cliplength, m, ...
                              @(a) utils.add_gaussian_noise(a, snr, true));


db_handle = sqlite3.open(database_filename);

result = testing.test_clips(clips, ...
                            @algorithms.constellation.match_file, ...
                            @algorithms.constellation.get_song_name, ...
                            'max', ...
                            db_handle);


disp(['Matched ' num2str(result) '/' num2str(length(clips)) ' correctly.']);


sqlite3.close(db_handle);