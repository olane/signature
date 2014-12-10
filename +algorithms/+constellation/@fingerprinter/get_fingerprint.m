function [ hashes ] = get_fingerprint( audio )
%GET_FINGERPRINT Creates a fingerprint of a mono audio clip. Assumes a
%sample rate of 16 kHz.
%   The returned array contains all of the hashes that make up a fingerprint.
    
    [times, frequencies, powers] = ...
        algorithms.constellation.fingerprinter.get_spectrogram(audio);
    
    
    % PEAK FIND PARAMETERS
    % The threshold of the high pass filter used before peak detection
    thres = 0;
    
    % A filter used to smooth the signal before finding peaks
    filt = (fspecial('gaussian', 15, 3));
    
    % Border on the edge of the signal for which peaks will not be detected
    edge = 3;
    
    p = FastPeakFind(powers, thres, filt, edge);
    
    peak_times = p(1:2:end);
    peak_freqs = p(2:2:end);
    

    % TARGET ZONE PARAMETERS
    % The target zone is the area ahead of each peak from which other peaks
    % will be taken as pairs
    
    % The furthest ahead in time the target zone extends to (in samples)
    % (note that this is packed into 10 bits, so can't be higher than 63)
    target_dt = 32;
    
    % The furthest up or down the target zone extends to (in frequency
    % bins). Note the height of the target zone is 2*target_df, whilst the
    % length is simply target_dt because no points are taken from behind
    % the anchor point.
    % (note that this is packed into 10 bits, so can't be higher than 63)
    target_df = 16;
    
    % The maximum number of points to pair with each anchor point
    max_fan_out = 10;
    
    landmark_pairs = [];
    
    % Find landmark pairs
    for i = 1:length(peak_times)
        
        anchor_time = peak_times(i);
        anchor_freq = peak_freqs(i);
        
        target = peak_times > anchor_time & ...
                 peak_times < (anchor_time + target_dt) & ...
                 peak_freqs > (anchor_freq - target_df) & ...
                 peak_freqs < (anchor_freq + target_df);
        
        target_times = peak_times(target);
        target_freqs = peak_freqs(target);
        
        for j = 1:min(length(target_times), max_fan_out)
            landmark_pairs(end+1, :) = [anchor_time, ...
                                        anchor_freq, ...
                                        target_times(j) - anchor_time, ...
                                        target_freqs(j) - anchor_freq];
        end
               
    end
    
    
    % Pack the hashes to pairs of the form [hash, time]
    
    hashes = zeros(length(landmark_pairs(:, 1)), 2);
    
    for i = 1:length(landmark_pairs(:, 1))
        hashes(i,:) = landmark_pair_to_hash(landmark_pairs(i,:));
    end
    
    
    
    % Optionally draw debugging graphs
    
    drawplots = true;
    
    if(drawplots)
        
        % peaks on spectrogram
        imagesc(10*log10(abs(powers))); 
        hold on
        plot(peak_times, peak_freqs, 'r+')
        
        figure;
        
        % constellations on spectrogram
        imagesc(10*log10(abs(powers))); 
        hold on
        for i = 1:length(landmark_pairs(:,1))
            p = landmark_pairs(i, :);
            plot([p(1), p(1)+p(3)], [p(2), p(2)+p(4)], 'Color', 'r');
        end
       
    end
end

