
addpath('/Users/olane/Documents/MATLAB/matlab-sqlite3-driver/');
input_folder = './library/';
test_clips_folder = './test_clips/gaussian_noise/3sec/3db/';
database_filename = 'constellation-8000.db';

clips = testing.extract_basic_clips(input_folder, test_clips_folder, ...
                                    40, 43, 9, ...
                                    @(a) utils.add_gaussian_noise(a, 3, true));


db_handle = sqlite3.open(database_filename);

result = testing.test_clips(clips, ...
                            @algorithms.constellation.match_file, ...
                            @algorithms.constellation.get_song_name, ...
                            'max', ...
                            db_handle);


disp(['Matched ' num2str(result) '/' num2str(length(clips)) ' correctly.']);


sqlite3.close(db_handle);