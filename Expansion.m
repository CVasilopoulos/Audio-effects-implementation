function out_comp_exp = Expansion(input_signal, fs)

    % This function expands the input signal
    
    % Initialize expansion parameters
    comp = 0.5; 
    a = 0.5;
    
    h = filter([(1-a)^2],[1.0000 -2*a a^2], abs(input_signal)); 
    h = h / max(h);
    h = h .^ comp;

    out_comp_exp = input_signal .* h;

    out_comp_exp = out_comp_exp * max(abs(input_signal)) / max(abs(out_comp_exp));
    
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
     plot(out_comp_exp, 'r'); 
     title('(EXPANSION) Signal after Expansion'); 
     ylabel('Amplitude');
     xlabel('Time (s)');
     grid on;
 
    
end