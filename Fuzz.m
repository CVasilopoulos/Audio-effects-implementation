function fuzz_out = Fuzz(input_signal, fs)

    % This function adds fuzz effect to an input audio signal

    % Distortion based on an exponential function
    % input_signal - input
    % gain - amount of distortion,
    % mix - mix of original and distorted sound

    gain = 11;
    mix = 0.1; % mix = 1 only distorted, hear only fuzz

    q = input_signal ./ abs(input_signal);
    fuzz_out = q .*(1 - exp(gain * (q .* input_signal)));
    fuzz_out = mix * fuzz_out + (1 - mix) * input_signal;
    
    % Display the original input signal
    figure 
    subplot(2,1,1); 
    plot(input_signal, 'c'); 
    title('Original signal'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;

    % Display the output signal  after Fuzz
    subplot(2,1,2); 
    plot(fuzz_out, 'r'); 
    title('(FUZZ) Signal after Fuzz'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;

end