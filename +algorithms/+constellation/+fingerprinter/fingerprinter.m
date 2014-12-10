classdef fingerprinter
    %FINGERPRINTER Creates audio fingerprints according to the
    %constellation algorithm
    %   Based on the algorithm put forward by Shazam in their paper
    %   "An Industrial-Strength Audio Search Algorithm".
    
    
    methods (Static)
      hash = get_fingerprint( audio )
      [ times, frequencies, powers ] = get_spectrogram( audio )
      H = landmark_pair_to_hash( L )
   end
    
end

