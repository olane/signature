function out_signal = add_gaussian_noise(signal, targetSNR, rescale)
%ADD_GAUSSIAN_NOISE adds gaussian white noise to a signal, to give the
%target signal to noise ratio. If rescale is true, the signal will be
%rescaled to between 0 and 1 after adding the noise.

    len = length(signal);
    
    noise = randn(size(signal));
    
    % Find the powers of the signal and the noise, so we can scale the
    % noise to give the right SNR
    signal_power = sqrt(sum(signal.^2)) / len;
    noise_power = sqrt(sum(noise.^2)) / len;
    
    % Scale our noise to give the right SNR
    scaleFactor = (signal_power / noise_power) / targetSNR;
    noise = scaleFactor * noise;
    
    out_signal = signal + noise;
    
    if(rescale)
        out_signal = out_signal ./ max(out_signal);
    end
    
end