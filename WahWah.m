function wahwah_out = WahWah(input_signal, fs)

    % This function adds wah - wah effect to an input signal 

    % BP filter with narrow pass band, fc oscillates up and down the
    % spectrum

    %%%%%%% EFFECT COEFFICIENTS %%%%%%%%%%%%

    % damping factor
    % lower the damping factor the smaller the pass band
    damp = 0.05;

    % min and max centre cutoff frequency of variable bandpass filter
    minf=500;
    maxf=3000;

    % wah frequency, how many Hz per second are cycled through
    fw = 2000;

    % change in centre frequency per sample (Hz)
    % delta=0.1;
    delta = fw / fs;
    %0.1 => at 44100 samples per second should mean  4.41kHz fc shift per sec

    % create triangle wave of centre frequency values
    fc = minf : delta : maxf;
    while(length(fc) < length(input_signal) )
        fc= [ fc (maxf: -delta : minf) ];
        fc= [ fc (minf : delta : maxf) ];
    end

    % trim tri wave to size of input
    fc = fc(1 : length(input_signal));

    % difference equation coefficients
    F1 = 2*sin((pi*fc(1))/fs);  % must be recalculated each time fc changes
    Q1 = 2*damp;                % this dictates size of the pass bands
    
    
    yh=zeros(size(input_signal));          % create emptly out vectors
    wahwah_out=zeros(size(input_signal));
    yl=zeros(size(input_signal));

    % first sample, to avoid referencing of negative signals
    yh(1) = input_signal(1);
    wahwah_out(1) = F1*yh(1);
    yl(1) = F1*wahwah_out(1);

    % apply difference equation to the sample
    for n=2:length(input_signal),

        yh(n) = input_signal(n) - yl(n-1) - Q1*wahwah_out(n-1);
        wahwah_out(n) = F1*yh(n) + wahwah_out(n-1);
        yl(n) = F1*wahwah_out(n) + yl(n-1);
        F1 = 2 * sin((pi * fc(n)) / fs);
        
    end

    % normalise
    maxyb = max(abs(wahwah_out));
    wahwah_out = wahwah_out/maxyb;

   % Display the original input signal
    figure 
    subplot(2,1,1); 
    plot(input_signal, 'c'); 
    title('Original signal'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;

    % Display the output signal  after Wah - Wah
    subplot(2,1,2); 
    plot(wahwah_out, 'r'); 
    title('(WAH - WAH) Signal after Wah - Wah'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;
    
end