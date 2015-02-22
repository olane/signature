function peaks = find_2d_peaks( d, thresh, filt_size, edge )
%FIND_2D_PEAKS Finds local maxima in a 2D array
%   d           The data
%   thresh      A threshold value below which no peaks will be detected
%   filt_size   The sigma value of the gaussian filter used to smooth the
%               image before peak detection. This should correspond to the
%               approximate size of the peaks to be found. 
%   edge        A border around the edge of the array in which no peaks
%               will be detected.

    filt = (fspecial('gaussian', ceil(filt_size * 3), filt_size));

    % If the image is floating point, recast to uint16 for speed
    if isfloat(d) 
        if max(d(:))<=1
            d = uint16(d .* 2^16 ./ max(d(:)));
        else
            d = uint16(d);
        end
    end
    
    
    if any(d(:))
        
        % Median filter to remove salt and pepper noise
        d = medfilt2(d, [3, 3]);
        
        % Threshold
        d = d .* unit16(d > thresh);
        
        if any(d(:))
            
            % Smooth the image
            d = conv2(single(d), filt, 'same');
            
            % Find the peaks
            [h, w] = size(d);
            
            peaks = [];
            
            for i = (edge):(h - edge)
                for j = (edge):(w - edge)
                    
                    if ((d(i,j) >= d(i-1, j-1)) &&...
                        (d(i,j) >= d(i,   j-1)) &&...
                        (d(i,j) >= d(i+1, j-1)) &&...
                        (d(i,j) >= d(i-1, j  )) &&...
                        (d(i,j) >= d(i+1, j  )) &&...
                        (d(i,j) >= d(i-1, j+1)) &&...
                        (d(i,j) >= d(i,   j+1)) &&...
                        (d(i,j) >= d(i+1, j+1)))
                    
                        peaks = [peaks, j, i]; 
                        
                        % TODO check if i and j are the right way around
                        % TODO preallocate in blocks
                    
                    end
                    
                end
            end
            
            
        end
        
        
    end
    
    
end

