input_foldername = '../library/';
input_files = dir([input_foldername '*.mp3']);

output_foldername = './basic_test_clips/';

disp(['Found ' num2str(length(input_files)) ' mp3 files in library.']);

mkdir(output_foldername);

i = 1;
c = 0;

while i < length(input_files)
    
    file = input_files(i);
    
    disp(['Sampling "' file.name '"...']);
    
    take_basic_clip(input_foldername, file, output_foldername, 60, 70);
    
    i = i + 10;
    c = c + 1;
    
end

disp(['Sampled ' num2str(c) ' files.']);

% 
% for file = files'
%     if ~file.isdir
%         drawspectrogram([foldername file.name], [0 18])
%     end
% end

