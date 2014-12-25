
function [ hashes ] = get_fingerprint( audio, fs )
%GET_FINGERPRINT Creates a fingerprint of a mono audio clip. 
%   http://www.nhchau.com/files/AudioFingerprint-02-FP04-2.pdf
    
    %% Framing and Fourier Transform
    L = round(0.37 * fs);
    window = hann(L);
    increment = round(L/32); %31/32 frame overlap
    
    [frames, frame_centres] = utils.enframe(audio, window, increment);

    fourier_frames = abs(fft(frames')');
    
    % We have a real valued signal so half of the fourier transform is
    % redundant
    fourier_frames = fourier_frames(1:floor(L/2)+1);
    
    
    % Sample length is L, so we have L/2 frequency bins. Our max
    % frequency is fs/2 Hz (by Nyquist), so our bin resolution is
    % fs/L Hz/bin.

    res = fs/L;
    
    for frame_num = 1:length(fourier_frames(1))
        
        %% Calculate logarithmic bands
        bottom = 300;
        top = 2000;
        n_bands = 33;

        % Find logs of endpoints of the line
        s = log(bottom); 
        f = log(top);

        % Then make an evenly spaced vector in log space
        exponents = linspace(s, f, n_bands+1); 

        % Recover the values in linear space
        bands = exp(exponents);


        %% Sum energy over each band
        band_energies = zeros(n_bands, 1);

        for i = 1:n_bands
            
            % Find first and last bin of the band
            band = [round(bands(i)/res), round(bands(i+1)/res) - 1];
            
            % Calculate the ESD for the band (sum of squares of fourier
            % coeffs)
            band_energies(i) = sum(fourier_frames(frame_num, band(1):band(2)).^2);
            
        end



        %% Calculate F(n,m) using band energies
    
    end
    
    
    %% return Fs
    
end