function out = match_file( filename, db_handle )
%MATCH_FILE Reads an audio file, then calls match_clip on it

    audio = utils.read_audio_as_mono(filename, 5000);
    
    out = algorithms.barcoder.match_clip(audio, db_handle);
    
end

