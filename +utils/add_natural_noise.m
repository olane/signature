function out_signal = add_natural_noise(signal, targetSNR, noise_filename, Fs, rescale)
%ADD_NATURAL_NOISE adds noise from an audio file to a signal, to give the
%target signal to noise ratio. If rescale is true, the signal will be
%rescaled to between 0 and 1 after adding the noise. targetSNR is in
%decibels. Noise will be looped if shorter than the signal.

    % Convert decibels to power ratio
    targetPowerRatio = 10^(targetSNR/10);

    len = length(signal);
    
    noise = utils.read_audio_as_mono(noise_filename, Fs);
    
    if length(noise) > len
        noise(len+1:end) = [];
    end
    
    if length(noise) < len
        noise = padarray(noise, len - length(noise), 'circular', 'post');
    end
    
    % Find the powers of the signal and the noise, so we can scale the
    % noise to give the right SNR
    signal_power = sqrt(sum(signal.^2)) / len;
    noise_power = sqrt(sum(noise.^2)) / len;
    
    % Scale our noise to give the right SNR
    scaleFactor = (signal_power / noise_power) / targetPowerRatio;
    noise = scaleFactor * noise;
    
    out_signal = signal + noise;
    
    if(rescale)
        % Factor of 0.9999 because values of exactly 1 are considered
        % clipping
        out_signal = out_signal / max(abs(out_signal(:))) * 0.9999;
    end
    
end