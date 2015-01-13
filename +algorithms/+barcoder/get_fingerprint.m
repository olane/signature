
function F = get_fingerprint( audio, fs )
%GET_FINGERPRINT Creates a fingerprint of a mono audio clip. 
%   Based on http://www.nhchau.com/files/AudioFingerprint-02-FP04-2.pdf
%   Returns an array of 32 bit sub-fingerprints, which together represent
%   the full fingerprint. Each sub-fingerprint is represented as a vector
%   of bits.
    
    %% Framing and Fourier Transform
    L = round(0.37 * fs);
    window = hann(L);
    increment = round(L/32); %31/32 frame overlap
    
    [frames, ~] = utils.enframe(audio, window, increment);

    fourier_frames = abs(fft(frames')');
    
    % We have a real valued signal so half of the fourier transform is
    % redundant
    fourier_frames = fourier_frames(:, 1:floor(L/2)+1);
    
    n_frames = length(fourier_frames(:, 1));
    
    % Sample length is L, so we have L/2 frequency bins. Our max
    % frequency is fs/2 Hz (by Nyquist), so our bin resolution is
    % fs/L Hz/bin.

    res = fs/L;
    
    
    %% Calculate logarithmic bands
    % We use n_bands frequency bands between top_freq and bottom_freq,
    % logarithmically spaced
    bottom_freq = 300;
    top_freq = 2000;
    n_bands = 33;

    % Find logs of endpoints of the line
    s = log(bottom_freq); 
    f = log(top_freq);

    % Then make an evenly spaced vector in log space
    exponents = linspace(s, f, n_bands+1); 

    % Recover the band limits in linear space
    bands = exp(exponents);
    
    
    %% Sum energy over each band for each frame
    
    % n is frame number, m is band number
    
    E = zeros(n_frames, n_bands);
    
    for n = 1:n_frames
        for m = 1:n_bands
            
            % Find first and last bin of the band
            band = [round(bands(m)/res), round(bands(m+1)/res) - 1];
            
            % Calculate the ESD for the band (sum of squares of fourier
            % coeffs)
            E(n,m) = sum(fourier_frames(n, band(1):band(2)).^2);
            
        end
    end
    
    
    %% Calculate F(n, m) using band energies
    
    % n is frame number, m is bit number

    F = zeros(n_frames-1, n_bands-1);

    for n = 2:n_frames
        for m = 1:(n_bands - 1)

            F(n-1,m) = (E(n,m) - E(n,m+1) - (E(n-1,m) - E(n-1,m+1))) > 0;
            
        end
    end
    
end