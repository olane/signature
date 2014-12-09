function [ hash ] = get_fingerprint( audio )
%GET_FINGERPRINT Creates a fingerprint of a mono audio clip. Assumes a
%sample rate of 44.1 kHz.
%   All times are in samples. 
    
    [times, frequencies, powers] = algorithms.constellation.fingerprinter.get_spectrogram(audio);
    
    thres = 0;
    filt = (fspecial('gaussian', 5, 1));
    edge = 3;
    
    p = FastPeakFind(powers, thres, filt, edge);
    
    peak_times = p(1:2:end);
    peak_freq_bins = p(2:2:end);
    
%     imagesc(10*log10(abs(powers))); hold on
%     plot(peak_times, peak_freq_bins, 'r+')

    

end

