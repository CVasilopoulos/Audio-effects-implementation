function chorus_out = Chorus(input_signal, fs)

    % This function adds the Chorus effect to an input_signal audio signal

    % Chorus effect parameters 
    play_output = true;
    loop_timer  = false;

    delay_length     = 0.013; % sec
    modulation_depth = 0.003; % sec
    modulation_rate  = 1.00;  % Hz
    feedback         = 0.30;  % Percent
    low_shelf_freq   = 600;   % Hz
    low_shelf_gain   = -7;    % dB
    dry_wet_balance  = 0.40;  % 0.0 for all dry, 1.0 for all wet

    delay_length_samples     = round(delay_length * fs);
    modulation_depth_samples = round(modulation_depth * fs);

    modulated_output = zeros(length(input_signal), 1);
    delay_buffer     = zeros(delay_length_samples + modulation_depth_samples, 1);

    % Argument for sin() modulation function. Converts the loop's control 
    % variable into the appropriate argument in radians to achieve the 
    % specified modulation rate
    modulation_argument = 2 * pi * modulation_rate / fs;

    for i = 1 : (length(input_signal))
        
        % Find index to read from for modulated output
        modulated_sample = modulation_depth_samples * sin(modulation_argument * i);
        modulated_sample = modulated_sample + delay_length_samples;

        % Get values to interpolate between
        interp_y1 = delay_buffer(floor(modulated_sample));
        interp_y2 = delay_buffer( ceil(modulated_sample));

        query_sample = modulated_sample - floor(modulated_sample);

        % Interpolate to find the output value
        modulated_output(i) = interp_y1 + (interp_y2 - interp_y1) * (query_sample);

        % Save the input_signal's current value in the buffer and advance to the next value
        new_sample = (input_signal(i) + modulated_output(i) * feedback);
        delay_buffer = [ new_sample; delay_buffer(1 : length(delay_buffer) - 1) ];
        
    end

    % Create low shelf filter
    w0     = 2 * pi * low_shelf_freq / fs;
    S      = 0.5;
    A      = 10 ^ (low_shelf_gain / 40);
    alpha  = sin(w0) / 2 * sqrt( (A + 1/A) * (1/S - 1) + 2 );

    b0 =    A *( (A+1) - (A-1) * cos(w0) + 2 * sqrt(A) * alpha );
    b1 =  2 * A * ( (A-1) - (A+1) * cos(w0)                   );
    b2 =    A * ( (A+1) - (A-1) * cos(w0) - 2 * sqrt(A) * alpha );
    a0 =        (A+1) + (A-1) * cos(w0) + 2 * sqrt(A) * alpha;
    a1 =   -2 * ( (A-1) + (A+1) * cos(w0)                   );
    a2 =        (A+1) + (A-1) * cos(w0) - 2*sqrt(A) * alpha;

    % Find and plot the EQ's frequency response in the Z domain
    [H, W] = freqz([b0, b1, b2], [a0, a1, a2], 500);
    f = W / (2 * pi) * fs;

    % Find the decibel version of the EQ's frequency response
    H_dB = 20*log10(abs(H));

    figure('Position',[25, 50, 750, 600])

    subplot(2, 1, 1); semilogx(f, H_dB); axis([20, 20e3, min(H_dB), max(H_dB)])
    title('Frequency response of low shelf EQ')
    ylabel('Gain (dB)')
    xlabel('Frequency (Hz)')
    grid on;

    len = length(modulated_output);

    NFFT = 2^nextpow2(len); % Next power of 2 from length of y
    f = fs / 2 * linspace(0, 1, NFFT/2+1);
    Mod_FFT = fft(modulated_output,NFFT) / len;

    % Plot single-sided amplitude spectrum of the modulated signal before EQ.
    subplot(2, 1, 2); semilogx(f, abs(Mod_FFT(1:NFFT/2+1)));

    % Apply low shelf EQ to the modulated signal
    modulated_output = filter([b0, b1, b2], [a0, a1, a2], modulated_output);
    Mod_EQ_FFT = fft(modulated_output,NFFT) / len;

    % Plot single-sided amplitude spectrum of the modulated signal after EQ.
    hold; semilogx(f, abs(Mod_EQ_FFT(1:NFFT/2+1)), 'r'); 

    axis([20, 20e3, 0, max(abs(Mod_FFT))]);
    title('Single-Sided Spectrum')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)| (dB)')
    legend('Modulated', 'Modulated & EQed')
    grid on;


    % Add the dry and wet signals to get the final mixed version
    chorus_out = ((1 - dry_wet_balance) * input_signal(:, 1) ) + (dry_wet_balance * modulated_output);

    % Plot the input_signal, modulated signal, and summed output signal
    xmin =  1; xmax = length(input_signal);
    ymin = -1; ymax = 1;

    figure('Position', [700, 50, 600, 600])
    subplot(3, 1, 1); plot(input_signal, 'b'); axis([xmin, xmax, ymin, ymax]);
    title('Original signal');
    grid on;

    subplot(3, 1, 2); plot(modulated_output, 'r'); axis([xmin, xmax, ymin, ymax]);
    title('Modulated signal');
    grid on;

    subplot(3, 1, 3); plot(chorus_out, 'g');  axis([xmin, xmax, ymin, ymax]);
    title('Signal after Chorus');
    grid on;

end



