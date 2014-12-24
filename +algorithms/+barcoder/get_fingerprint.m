
function [ hashes ] = get_fingerprint( audio, sampling_freq )
%GET_FINGERPRINT Creates a fingerprint of a mono audio clip. 
%   http://www.nhchau.com/files/AudioFingerprint-02-FP04-2.pdf
    
    L = 0.37 * sampling_freq;
    window = hann(L);
    increment = round(L/32); %31/32 frame overlap
    
    [frames, frame_centres] = utils.enframe(audio, window, increment);

    fourier_frames = abs(fft(frames')');
    
    % logarithmic bands
    
    % sum power over each band
    
    % calc F(n,m) using band powers
    
    % return Fs
    
end