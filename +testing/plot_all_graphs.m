%% Gaussian Philips

load('gaussian_barcoder_results.mat')

testing.plot_averaged_noise_test_batch_results...
    (set, ...
     snr, ...
     len, ...
     succ, ...
     tot, ...
     'Recognition rate for additive white gaussian noise: Philips algorithm', ...
     'gaussian_philips_results.eps', ...
     false);
 
 
 %% Gaussian Shazam

load('gaussian_constellation_results.mat')

testing.plot_averaged_noise_test_batch_results...
    (set, ...
     snr, ...
     len, ...
     succ, ...
     tot, ...
     'Recognition rate for additive white gaussian noise: Shazam algorithm', ...
     'gaussian_shazam_results.eps', ...
     false);

 
%% Natural Philips

load('natural_barcoder_results.mat')

testing.plot_averaged_noise_test_batch_results...
    (set, ...
     snr, ...
     len, ...
     succ, ...
     tot, ...
     'Recognition rate for additive real world noise: Philips algorithm', ...
     'natural_philips_results.eps', ...
     false);

 
%% Natural Shazam

load('natural_constellation_results.mat')

testing.plot_averaged_noise_test_batch_results...
    (set, ...
     snr, ...
     len, ...
     succ, ...
     tot, ...
     'Recognition rate for additive real world noise: Shazam algorithm', ...
     'natural_shazam_results.eps', ...
     false);
 
 
 %% Passthrough Philips
 
load('passthrough_barcoder_results.mat')
testing.plot_passthrough_test_batch(set, len, succ, tot, {'Recognition rate for re-recorded clips:'; 'Philips algorithm'}, 'barcoder_passthrough.eps', true)


 %% Passthrough Shazam
 
load('passthrough_constellation_results.mat')
testing.plot_passthrough_test_batch(set, len, succ, tot, {'Recognition rate for re-recorded clips:'; 'Shazam algorithm'}, 'constellation_passthrough.eps', true)
