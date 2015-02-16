function audiodata = record_audio( sample_rate, bits_per_sample, length )
%RECORD_AUDIO records some audio from the microphone and returns it as an
%array, normalised between -1 and 1. Length given in seconds. Blocks for
%the length of the recording. 

    recObj = audiorecorder(sample_rate, bits_per_sample, 1);
    recordblocking(recObj, length);
    audiodata = getaudiodata(recObj);
    
    % Normalise, with 1% headroom
    audiodata = audiodata ./ max(abs(audiodata)) .* 0.99;
    
end

