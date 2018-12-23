function input_signal = Gdist(input_signal)

    % This function adds a distortion effect like that of an overdriven 
    % guitar amplifier

    %   a is the amount of distortion.  A should be chosen so that -1 < a < 1.
    %   input_signal = Input.  Should be a column vector between -1 and 1.

    temp = input_signal;
    a = 0.5
    k = (2 * a) / (1 - a);
    input_signal = (1 + k) * (input_signal)./ ( 1 + k * abs(input_signal));

    % Display the original input signal
    figure 
    subplot(2,1,1); 
    plot(temp, 'c'); 
    title('Original signal'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;

    % Display the output signal  after Overdrive
    subplot(2,1,2); 
    plot(input_signal, 'r'); 
    title('(GUITAR DISTORTION) Signal after Guitar Distortion'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;

end