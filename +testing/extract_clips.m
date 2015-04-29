function clips = extract_clips(input_foldername, output_foldername, cliplen, m, transform)
% Takes every mth song from input_foldername, extracts a random clip of
% length cliplen, runs it through the given transform function and saves it
% in output_foldername.  Note that the clip's random location is seeded
% from the clip name so that this function's output is deterministic.
%
% transform should take and return some mono audio as an array at the
% specified sample rate

    input_files = dir([input_foldername '*.mp3']);

    disp(['Found ' num2str(length(input_files)) ' mp3 files in library.']);

    mkdir(output_foldername);

    i = 1;
    c = 0;
    
    clips = [];

    while i <= length(input_files)

        file = input_files(i);

        disp(['Sampling "' file.name '"...']);

        path = testing.take_clip(input_foldername, file, ...
                                 output_foldername, cliplen, ...
                                 transform);

        i = i + m;
        c = c + 1;
        
        clips(c).original = [input_foldername file.name];
        clips(c).clip = path;

    end

    
    disp(['Sampled ' num2str(c) ' files.']);
    
end

