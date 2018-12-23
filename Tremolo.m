function tremolo_out = Tremolo(input_signal, fs, fx, alpha)

% This function adds tremolo affect to an input signal
    
     % Initialize Tremolo parameters
     fx = 5; % modulation frequency
     alpha = 0.5;
            
    index = 1 : length(input_signal);
    trem = (1 + alpha * sin(2 * pi * index * (fx / fs)))';
    tremolo_out = trem .* input_signal;
    
    % Display the original input signal
    figure 
    subplot(2,1,1); 
    plot(input_signal, 'c'); 
    title('Original signal'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;

    % Display the output signal  after Tremolo
    subplot(2,1,2); 
    plot(tremolo_out, 'r'); 
    title('(TREMOLO) Signal after Tremolo'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;

end
