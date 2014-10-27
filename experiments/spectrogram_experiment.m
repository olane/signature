
filename = 'heartbeat.mp3';

inf = audioinfo(filename);

sample = [160 180];

sample = sample * inf.SampleRate + 1;


[D, sample_rate] = audioread(filename, sample);
sound(D, sample_rate)
D = mean(D, 2); %stereo to mono

target_sample_rate = 44100;

srgcd = gcd(sample_rate, target_sample_rate);
D = resample(D,target_sample_rate/srgcd, sample_rate/srgcd); %resample to target rate


window = hann(512);
number_samples_overlap = 256;
fft_length = 2^14;

[transform, frequencies, times] = spectrogram(D, ...
                                              window, ...
                                              number_samples_overlap, ...
                                              fft_length, ...
                                              target_sample_rate);
                                          

imagesc(times,frequencies,20*log10(abs(transform)));

set(gca,'YDir','normal')
xlabel('Time (s)');
ylabel('Frequency (Hz)');
 
%%
% % with MIRtoolbox
% 
% a = miraudio('heartbeat.mp3', 'Extract', 120, 130);
% x = mirspectrum(a, 'Frame', 0.05, 'Max', 20000, 'Res', 0.2, 'Min', 20);
% mirpeaks(x, 'Contrast', 0.04);


