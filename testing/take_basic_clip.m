function take_basic_clip(input_foldername, file, output_foldername, start_time, end_time )
%take_basic_clip Extracts a basic test clip
%   Takes the audio from start_time to end_time and saves it to a new file
%   in the output folder. Saves in the .ogg format.

    
    file_path = [input_foldername file.name];
    
    [~, file_name, ~] = fileparts(file_path);
    
    % Get the start sample and end sample
    inf = audioinfo(file_path);
    start_sample = start_time * inf.SampleRate;
    end_sample = end_time * inf.SampleRate;
    
    % Read the audio
    [audio, sample_rate] = audioread(file_path, [start_sample end_sample]);
    
    % Output it with its new name
    output_name = [output_foldername ...
                   file_name '_sample_' num2str(start_time) '-' num2str(end_time) ...
                   '.ogg' ];
    
    audiowrite(output_name, audio, sample_rate);
end

