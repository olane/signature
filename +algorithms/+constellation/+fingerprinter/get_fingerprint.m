function [ hashes ] = get_fingerprint( audio )
%GET_FINGERPRINT Creates a fingerprint of a mono audio clip. All times are
%in samples, not seconds.
%   The returned array contains all of the hashes that make up a
%   fingerprint, as a list of [time, hash] pairs
    
    [~, ~, powers] = algorithms.constellation.fingerprinter.get_spectrogram(audio);
    
    
    % PEAK FIND PARAMETERS
    % The threshold of the high pass filter used before peak detection
    thres = 0;
    
    % Size of the filter used to smooth the signal before finding peaks
    filt_size = 3;
    
    % Border on the edge of the signal for which peaks will not be detected
    edge = 3;
    
    p = algorithms.constellation.fingerprinter.find_2d_peaks(powers, thres, filt_size, edge);
    
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
    
    
    start_block_size = round(length(audio) / 200);
    n = 0;
    allocated = start_block_size;
    
    landmark_pairs = zeros(start_block_size, 4);
    
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
            
            landmark_pairs(n+1, :) = [anchor_time, ...
                                      anchor_freq, ...
                                      target_times(j) - anchor_time, ...
                                      target_freqs(j) - anchor_freq];
                                    
            n = n + 1;
            
            if(allocated == n)
                % We need more space, double the size
                landmark_pairs = [landmark_pairs; zeros(allocated, 4)];
                allocated = allocated * 2;
            end
            
        end
        
    end
    
    landmark_pairs((n+1):end, :) = [];
    
    % Pack the hashes to pairs of the form [time, hash]
    
    hashes = zeros(length(landmark_pairs(:, 1)), 2);
    
    for i = 1:length(landmark_pairs(:, 1))
        hashes(i,:) = algorithms.constellation.fingerprinter.landmark_pair_to_hash(landmark_pairs(i,:));
    end
    
    
    
    % Optionally draw debugging graphs
    
    drawplots = false;
    
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

