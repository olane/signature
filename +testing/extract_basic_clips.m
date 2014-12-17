function clips = extract_basic_clips(input_foldername, output_foldername)

    input_files = dir([input_foldername '*.mp3']);

    disp(['Found ' num2str(length(input_files)) ' mp3 files in library.']);

    mkdir(output_foldername);

    i = 1;
    c = 0;
    
    clips = [];

    while i < length(input_files)

        file = input_files(i);

        disp(['Sampling "' file.name '"...']);

        path = testing.take_basic_clip(input_foldername, file, ...
                                       output_foldername, 60, 70);

        i = i + 10;
        c = c + 1;
        
        clips(c).original = [input_foldername file.name];
        clips(c).clip = path;

    end

    
    disp(['Sampled ' num2str(c) ' files.']);
    
end

