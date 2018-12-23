function out_signal = Flanger(in_signal, fs)

% This function creates Flanger

    delay = 0.03; 
    rate = 1; 
    amp = 0.7;

    index = 1 : length(in_signal); 
    % Create a sinusoidal wave that oscillates when multipled with the LFO rate
    % (rate/fs) dictates the oscillations
    sinLFO = (sin(2 * pi * index * (rate / fs)))';                  
    % convert delay (ms) to max delay in samples
    max_samp_delay = round(delay * fs); 
    out_signal = zeros(length(in_signal), 1); 
    % Correct the array to avoid referencing negative samples 
    out_signal(1 : max_samp_delay) = in_signal(1 : max_samp_delay); 
    % For each sample generate delay and feed it back with oscillation
    for i = (max_samp_delay + 1): length(in_signal),
        cur_sin = abs(sinLFO(i));
        cur_delay = ceil(cur_sin * max_samp_delay); 
        % Feed delayed signal back into original signal
        out_signal(i) = (amp * in_signal(i)) + amp *(in_signal(i-cur_delay)); 
    end

%--------------------------- Plot signals ---------------------------
    % Display the original input signal
    figure 
    subplot(2,1,1); 
    plot(in_signal, 'c'); 
    title('Original signal'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;

    % Display the output signal  after Flanger
    subplot(2,1,2); 
    plot(out_signal, 'r'); 
    title('(FLANGER) Signal after Flanger'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;

end