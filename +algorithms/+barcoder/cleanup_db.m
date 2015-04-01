function cleanup_db( db_handle )
%CLEANUP_DB does anything that needs to be done after registering a load of
%songs

    disp('Remaking indexes')
    tic
    sqlite3.execute(db_handle, 'CREATE INDEX IF NOT EXISTS hash_index ON hashes(hash)');
    sqlite3.execute(db_handle, 'CREATE INDEX IF NOT EXISTS hash_number_index ON hashes(hash_number)');
    sqlite3.execute(db_handle, 'CREATE INDEX IF NOT EXISTS song_id_index ON hashes(song_id)');
    toc

end

