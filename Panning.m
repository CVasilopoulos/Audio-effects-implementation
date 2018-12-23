function input_signal = Panning(input_signal)

% This function adds a panning effect to an input audio signal

    % Initialize panning parameters
    a = 0.5
    initial_angle = -40; %in degrees
    final_angle = 40;    %in degrees
    segments = 32;

    % in radians
    angle_increment = (initial_angle - final_angle) / segments * pi / 180;

    lenseg = floor(length(input_signal)/segments) - 1;
    pointer = 1;
    angle = initial_angle * pi / 180; % in radians
    panning_out = [[];[]];

    for i = 1 : segments

         A =[cos(angle), sin(angle); -sin(angle), cos(angle)];
         stereox = [input_signal(pointer:pointer + lenseg)';
                    input_signal(pointer : pointer + lenseg)'];
         panning_out = [panning_out, A * stereox];
         angle = angle + angle_increment; pointer = pointer + lenseg;

    end;

    
    
    % Plot results
    % Plot Original Signal
    figure 
    subplot(3,1,1); 
    plot(input_signal, 'c'); 
    title('Original signal'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;

    % Plot signal after panning
    hold on
    subplot(3,1,2);
    plot(panning_out(1,:));
    grid on;
    title('Stereo Panned Signal Channel 1 (L)');
    subplot(3,1,3);
    plot(panning_out(2,:));
    title('Stereo Panned Signal Channel 2 (R)');
    grid on;
    
    
end
