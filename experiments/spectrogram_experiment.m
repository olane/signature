foldername = './music/';
files = dir([foldername '*.mp3']);

for file = files'
    if ~file.isdir
        drawspectrogram([foldername file.name], [0 18])
    end
end

%%
% % with MIRtoolbox

foldername = './music/';
files = dir(foldername);

for file = files'
    if ~file.isdir
        drawspectrogram_MIRT([foldername file.name])
    end
end
