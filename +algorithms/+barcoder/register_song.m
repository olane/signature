function register_song( db_handle, audio, sample_rate, song_name )
%REGISTER_SONG Registers a song in the database.
%   Calculates a fingerprint and inserts it into the database. Takes mono
%   audio.

    %% Analysis
    
    F = algorithms.barcoder.get_fingerprint(audio, sample_rate);
    
    F_int = rowfun(@utils.bi2dec, F);
    
    %% DB insertion

    

end

