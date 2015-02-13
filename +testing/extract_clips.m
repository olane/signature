function clips = extract_clips(input_foldername, output_foldername, clipstart, clipend, m, transform)
% Takes every mth song from input_foldername, extracts a clip from
% clipstart to clipend, runs it through the given transform function and
% saves it in output_foldername. 

    input_files = dir([input_foldername '*.mp3']);

    disp(['Found ' num2str(length(input_files)) ' mp3 files in library.']);

    mkdir(output_foldername);

    i = 1;
    c = 0;
    
    clips = [];

    while i < length(input_files)

        file = input_files(i);

        disp(['Sampling "' file.name '"...']);

        path = testing.take_clip(input_foldername, file, ...
                                 output_foldername, clipstart, clipend, ...
                                 transform);

        i = i + m;
        c = c + 1;
        
        clips(c).original = [input_foldername file.name];
        clips(c).clip = path;

    end

    
    disp(['Sampled ' num2str(c) ' files.']);
    
end

