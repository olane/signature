function [ hashes ] = get_hash_section( db_handle, song_id, start_hash_number, end_hash_number)
%GET_HASH_SECTION Gets the set of hashes between start_hash_number and
%end_hash_number (inclusive) for the song with id song_id.

    results = sqlite3.execute(...
        db_handle, ...
        'SELECT hash FROM hashes WHERE song_id = ? AND hash_number BETWEEN ? AND ?', ...
        song_id, ...
        start_hash_number, ...
        end_hash_number);

    hashes = zeros(length(results), 1);
    
    for i = 1:length(results)
        hashes(i) = results(i).hash;
    end
    
end

