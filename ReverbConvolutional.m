function reverb_conv_out = ReverbConvolutional(input_signal, h)

    %  convolves input_signal and h, and normalizes the output  
    %         to +-1.

    temp = input_signal;
    Ly=length(input_signal)+length(h)-1;  % 
    Ly2=pow2(nextpow2(Ly));    % Find smallest power of 2 that is > Ly
    input_signal=fft(input_signal, Ly2);  % Fast Fourier transform
    H=fft(h, Ly2);	           % Fast Fourier transform
    reverb_conv_out=input_signal.*H;        	         
    reverb_conv_out=real(ifft(reverb_conv_out, Ly2));   % Inverse fast Fourier transform
    reverb_conv_out=reverb_conv_out(1:1:Ly);   % Take just the first N elements
    reverb_conv_out=reverb_conv_out/max(abs(reverb_conv_out)); % Normalize the output
    
    
   % Display the original input signal
     figure 
     subplot(2,1,1); 
     plot(temp, 'c'); 
     title('Original signal'); 
     ylabel('Amplitude');
     xlabel('Time (s)');
     grid on;

     % Display the output signal  after Echo
     subplot(2,1,2); 
     plot(reverb_conv_out, 'r'); 
     title('(CONV. REVERB) Signal after Convolutional Reverberation'); 
     ylabel('Amplitude');
     xlabel('Time (s)');
     grid on;
 
    
    
end