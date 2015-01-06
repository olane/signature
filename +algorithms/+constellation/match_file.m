function out = match_file( filename, db_handle )
%MATCH_FILE Reads an audio file, then calls match_clip on it

    audio = utils.read_audio_as_mono(filename, 8000);
    
    out = algorithms.constellation.match_clip(audio, db_handle);
    
end

