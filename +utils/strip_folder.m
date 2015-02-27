function out = strip_folder( in )
%strip_folders Returns the text after the last trailing / in the input.
%For example, 'abc/def/g' -> 'g'

    tmp = strsplit(in, '/');
    out = tmp(end);

end

