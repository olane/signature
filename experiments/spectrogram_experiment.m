
filename = 'heartbeat.mp3';

inf = audioinfo(filename);

sample = [0 18];

sample = sample * inf.SampleRate + 1;

[D, sample_rate] = audioread(filename, sample);

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

a = miraudio('Design');

b = miraudio(a, 'Extract', 120, 121);
x = mirspectrum(b, 'Frame', 0.05, 'Max', 20000, 'Res', 0.2, 'Min', 20);
r = mirpeaks(x, 'Contrast', 0.04);

a = mireval(r, 'jackson5.mp3');
a{1,1}


