function register_all_songs( foldername, database_filename )
%REGISTER_ALL_SONGS calls register_song on all mp3 files in the given
%folder. Outputs a message after each registered song.
%   Currently downsamples 

    files = dir([foldername '*.mp3']);

    disp(['Found ' num2str(length(files)) ' mp3 files in library.']);
    
    counter = 1;

    for file = files'
        if ~file.isdir
            
            filepath = [foldername file.name];
            
            disp(['Analysing song (' num2str(counter) '/' num2str(length(files)) '): ' filepath]);

            [D, sample_rate] = audioread(filepath);

            D = mean(D, 2); %stereo to mono

            target_sample_rate = 16000;

            if(sample_rate ~= target_sample_rate)
                %resample to target rate
                srgcd = gcd(sample_rate, target_sample_rate);
                D = resample(D,target_sample_rate/srgcd, sample_rate/srgcd); 
            end
            
            algorithms.constellation.register_song(database_filename, D, filepath);
            
            disp('Song successfully registered.');
            disp('-----');
            
            counter = counter + 1;
            
        end
    end
    
end

