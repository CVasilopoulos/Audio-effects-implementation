function echo_out = Echo(input_signal, fs)

% This function adds the echo effect to an input_signal audio signal

    % Echo effect parameters 

     delay = 0.5; % 0.5s delay  
     alpha = 0.65; % echo strength  
     D = delay * fs;  
     echo_out = zeros(size(input_signal));  
     echo_out(1:D) = input_signal(1:D);  

     for i = D + 1 : length(input_signal)  
         
       echo_out(i) = input_signal(i) + alpha * input_signal(i - D);  
       
     end  
     
     % using filter method 
     % b = [1,zeros(1,D),alpha];  
     % echo_out = filter(b,1,input_signal); 
  
     % Display the original input signal
     figure 
     subplot(2,1,1); 
     plot(input_signal, 'c'); 
     title('Original signal'); 
     ylabel('Amplitude');
     xlabel('Time (s)');
     grid on;

     % Display the output signal  after Echo
     subplot(2,1,2); 
     plot(echo_out, 'r'); 
     title('(ECHO) Signal after Echo'); 
     ylabel('Amplitude');
     xlabel('Time (s)');
     grid on;
 
end 
