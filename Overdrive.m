function overdrive_out = Overdrive(input_signal)

% This function adds overdrive affect to an input signal with symmetrical
% clipping

     N = length(input_signal);
     overdrive_out = zeros(1, N); % Preallocate overdrive_out
     th = 1 / 3; % threshold for symmetrical soft clipping 

     for i = 1 : N
         
           if abs(input_signal(i)) < th, overdrive_out(i) = 2 * input_signal(i); end;
           if abs(input_signal(i)) >= th, 
              if input_signal(i) > 0, overdrive_out(i )= (3 - (2 -...
                                    input_signal(i) * 3) .^ 2) / 3; end;
              if input_signal(i) < 0, overdrive_out(i) = -(3 - (2 -...
                                abs(input_signal(i)) * 3) .^ 2) / 3; end;
           end;   
           
           if abs(input_signal(i)) > 2 * th, 
              if input_signal(i)> 0, overdrive_out(i) = 1; end;
              if input_signal(i)< 0, overdrive_out(i) = -1; end;
              
           end;
     end
     overdrive_out = overdrive_out';
     
   % Display the original input signal
    figure 
    subplot(2,1,1); 
    plot(input_signal, 'c'); 
    title('Original signal'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;

    % Display the output signal  after Overdrive
    subplot(2,1,2); 
    plot(overdrive_out, 'r'); 
    title('(OVERDRIVE) Signal after Overdrive'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;
end