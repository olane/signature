function output_path = take_clip(input_foldername, file, output_foldername, cliplen, transform )
%take_basic_clip Extracts a basic test clip
%   Takes a random clip of length cliplen and saves it to a new file
%   in the output folder after running it through the passed transform
%   function. Saves in the .ogg format. Skips if the destination file
%   already exists. 
%
%   transform should take and return some mono audio as an array at the
%   specified sample rate
%   
%   Note that the clip's random location is seeded from the file name so
%   that this function's output is deterministic. 

    input_path = [input_foldername file.name];
    
    [~, file_name, ~] = fileparts(input_path);
    
    % Seed for the random number generator based on the sum of the ascii
    % codes of the file name string
    rng_seed = mod(sum(double(file.name)), 2^32);
    rng(rng_seed, 'twister');
    
    % Get information about the audio file
    inf = audioinfo(input_path);

    % Get the start sample and end sample
    cliplen_samples = inf.SampleRate * cliplen;
    start_sample = floor((inf.TotalSamples - cliplen_samples) * rand);
    end_sample = start_sample + cliplen_samples;
        
               
    output_path = [output_foldername ...
                   file_name '_' num2str(start_sample) '-' num2str(end_sample) ...
                   '.ogg' ];
           
               
    % If this clip doesn't already exist
    if(exist(output_path, 'file') ~= 2)
    
        % Read the audio
        [audio, sample_rate] = audioread(input_path, ...
                                         [start_sample end_sample]);
                                     
        % Stereo to mono         
        audio = mean(audio, 2); 
                                     
        % Transform the audio
        audio = transform(audio, sample_rate);

        % Output it with its new name
        audiowrite(output_path, audio, sample_rate);
        
    end
    
end

