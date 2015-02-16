function output_path = take_clip(input_foldername, file, output_foldername, start_time, end_time, transform )
%take_basic_clip Extracts a basic test clip
%   Takes the audio from start_time to end_time and saves it to a new file
%   in the output folder after running it through the passed transform
%   function. Saves in the .ogg format. Skips if the destination file
%   already exists. 
%   transform should take and return some mono audio as an array at the
%   specified sample rate

    input_path = [input_foldername file.name];
    
    [~, file_name, ~] = fileparts(input_path);
    
    output_path = [output_foldername ...
                   file_name '_' num2str(start_time) '-' num2str(end_time) ...
                   '.ogg' ];
               
               
    if(exist(output_path, 'file') ~= 2)
    
        % Get the start sample and end sample
        inf = audioinfo(input_path);
        start_sample = start_time * inf.SampleRate;
        end_sample = end_time * inf.SampleRate;

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

