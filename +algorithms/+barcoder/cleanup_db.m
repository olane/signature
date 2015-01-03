function cleanup_db( db_handle )
%CLEANUP_DB does anything that needs to be done after registering a load of
%songs

    disp('Remaking index')
    tic
    sqlite3.execute(db_handle, 'CREATE INDEX IF NOT EXISTS hash_index ON hashes(hash)');
    toc

end

