function drawspectrogram(filename, sample)

    try
        inf = audioinfo(filename);
        sample = sample * inf.SampleRate + 1;
    catch 
        sample = [0 20];
    end


    [D, sample_rate] = audioread(filename, sample);

    D = mean(D, 2); %stereo to mono

    target_sample_rate = 44100;

    srgcd = gcd(sample_rate, target_sample_rate);
    D = resample(D,target_sample_rate/srgcd, sample_rate/srgcd); %resample to target rate


    window = hann(512);
    number_samples_overlap = 256;
    fft_length = 2^14;

    [~, frequencies, times, powers] = spectrogram(D, ...
                                                  window, ...
                                                  number_samples_overlap, ...
                                                  fft_length, ...
                                                  target_sample_rate);

    figure;

    imagesc(times,frequencies,10*log10(abs(powers)));

    set(gca,'YDir','normal')
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');

end
