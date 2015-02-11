function audiodata = record_audio( sample_rate, bits_per_sample, length )
%RECORD_AUDIO records some audio from the microphone and returns it as an
%array. Length given in seconds. 

    recObj = audiorecorder(sample_rate, bits_per_sample, 1);
    
    recordblocking(recObj, length);
    
    audiodata = getaudiodata(recObj);
    
end

