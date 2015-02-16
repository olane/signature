function output_audio = microphone_passthrough( input_audio, input_Fs, output_Fs, length )
%MICROPHONE_PASSTHROUGH takes some audio, plays it through the inbuilt
%speakers and records it again through the microphone. Returns mono audio
%at sample rate output_Fs, bit depth 16. length is the length of the audio
%in seconds.

    sound(input_audio, input_Fs);
    output_audio = record_audio(output_Fs, 16, length);

end

