function [ times, frequencies, powers ] = get_spectrogram( audio )
%GETSPECTROGRAM Takes a mono audio signal and returns a spectrogram of the
%signal. Assumes a sampling frequency of 16 kHz.
%   Divides the signal into 1025 frequency bands (including 0 Hz)

    sample_rate = 16000;

    window = hann(1024);
    number_samples_overlap = 512;
    fft_length = 2^11;

    [~, frequencies, times, powers] = spectrogram(audio, ...
                                                  window, ...
                                                  number_samples_overlap, ...
                                                  fft_length, ...
                                                  sample_rate);

end

