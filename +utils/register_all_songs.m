function register_all_songs( database_filename, input_foldername, initialise, register_song, cleanup )
%Calls register_song on each of the files in input_foldername.
%   initialise(db_handle) is a function called before starting,
%   register_song(db_handle, song_filename) is a function called for each
%   song, and cleanup(db_handle) is a function called when finished.  

    db_handle = sqlite3.open(database_filename);
    
    initialise(db_handle);
    
    disp('Checked and intialized database');
    
    
    files = dir([input_foldername '*.mp3']);

    disp(['Found ' num2str(length(files)) ' mp3 files in library.']);
    
    counter = 1;

    for file = files'
        if (~file.isdir)
            
            filepath = [input_foldername file.name];
            
            disp(['Analysing song (' num2str(counter) '/' num2str(length(files)) '): ' filepath]);
            
            register_song(db_handle, filepath);
            
            disp('-----');
            
            counter = counter + 1;
            
        end
    end
    
    disp('Cleaning up database');
    cleanup(db_handle);
    
    sqlite3.close(db_handle);

end

