
function drawspectrogram_MIRT(filename)

    a = miraudio('Design');

    b = miraudio(a, 'Extract', 120, 121);
    x = mirspectrum(b, 'Frame', 0.05, 'Max', 20000, 'Res', 0.2, 'Min', 20);
    %r = mirpeaks(x, 'Contrast', 0.04);

    a = mireval(x, filename);
    a{1,1}

end