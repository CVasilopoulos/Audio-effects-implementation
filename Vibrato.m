function vibrato_out = Vibrato(input_signal, fs)

% This function adds vibrato effect to an input signal

    % Initialize Vibrato parameters
    Modfreq = 10; %10 Khz
    width = 0.0008; % 0.8 Milliseconds

    ya_alt=0;
    Delay=width; % basic delay of input sample in sec
    DELAY=round(Delay*fs); % basic delay in # samples
    width=round(width*fs); % modulation width in # samples
    if width > DELAY 
      error('delay greater than basic delay !!!');
      return;
    end
    MODFREQ = Modfreq / fs; % modulation frequency in # samples
    LEN = length(input_signal);  % # of samples in WAV-file
    L=2+DELAY+width*2;    % length of the entire delay  
    Delayline=zeros(L,1); % memory allocation for delay
    vibrato_out=zeros(size(input_signal)); % memory allocation for output vector

    for n = 1 : (LEN - 1)
       M = MODFREQ;
       MOD = sin(M * 2 * pi * n);
       ZEIGER=1+DELAY+width*MOD;
       i = floor(ZEIGER);
       frac = ZEIGER - i;
       Delayline = [input_signal(n); Delayline(1 : L - 1)]; 
       %---Linear Interpolation-----------------------------
       vibrato_out(n,1) = Delayline(i + 1) * frac+Delayline(i) * (1 - frac); 

       %---Allpass Interpolation------------------------------
       %vibrato_out(n,1)=(Delayline(i+1)+(1-frac)*Delayline(i)-(1-frac)*ya_alt);  
       %ya_alt=ya(n,1);
       
    end   
    
    % Display the original input signal
    figure 
    subplot(2,1,1); 
    plot(input_signal, 'c'); 
    title('Original signal'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;

    % Display the output signal  after Vibrato
    subplot(2,1,2); 
    plot(vibrato_out, 'r'); 
    title('(VIBRATO) Signal after Vibrato'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;
       
end 

    
    