function song_name = get_song_name( song_id, db_handle )
%GET_SONG_NAME gets a song name given its ID from the database.
    
    query = 'SELECT song_name FROM songs WHERE song_id=? LIMIT 1';

    r = sqlite3.execute(db_handle, query, song_id);

    song_name = r.song_name;
    
end

