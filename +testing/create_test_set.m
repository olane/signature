function create_test_set( library_folder, new_test_set_folder, proportion )
%create_test_set Creates a new test set by taking a random proportion of
%songs from the library folder and copying them to the new test set folder


    input_files = dir([library_folder '*.mp3']);
    
    n = length(input_files);
    k = round(proportion * n);

    disp(['Found ' num2str(n) ' mp3 files in library.']);
    disp(['Extracting ' num2str(k) ' random files.']);
    
    indices = randperm(n, k);
    files_to_move = input_files(indices);
    
    
    mkdir(new_test_set_folder);
    
    for i = 1:length(files_to_move)
        
        from = [library_folder files_to_move(i).name];
        to = [new_test_set_folder files_to_move(i).name];
        
        copyfile(from, to);
        
    end
    
end

