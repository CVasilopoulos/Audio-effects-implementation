clear all; clc; close all; 

addpath('path\input');
signal = input('Enter audio file name (e.g "input.wav"):'); % Read signal
[x, fs] = audioread(signal); 
[h, fs1] = audioread('feel_good_x.wav');
Time = length(x)./fs; % Calculate time in seconds for playback
x = x(:,1); % Convert to mono 


% Series or parallel processing
select = input('Enter 1 for series processing, 2 for parallel processing:');

% In series processing, the signal chain flows linearly from effect one -
% two - three. After each effect the signal is directly processed further.

if (select == 1)
    audio_effect = []; 
    sel = 1;
    fprintf('*********Audio effects*********\n');
    fprintf(' 1.  Flanger\n 2.  Compression\n 3.  Reverberation\n');
    fprintf(' 4.  Tremolo\n 5.  Overdrive\n 6.  Panning\n');
    fprintf(' 7.  Guitar Distortion\n 8.  Echo\n 9. Fuzz\n');
    fprintf(' 10. Chorus\n 11. Vibrato\n 12. Wah - Wah\n 13. Convolutional Reverberation\n');
    fprintf(' 14. Expansion\n');
       
    audio_effect = input('Choose audio effect(s) to apply to the input signal(e.g. [1 5 6]):')

    y = x;
    %--------------------------- Series ---------------------------
    for i = 1 : length(audio_effect)
       if (audio_effect(i) == 1)
           display('Flanger');
           % Call flanger function
           y = Flanger(x, fs); 
           display('Flanger');
           sound(y, fs); % Play signal after Flanger
       end

       if (audio_effect(i) == 2)
           display('Compressor');
           % Call Compression function
           y = Compression(y, fs); 
           pause(Time); %Allow time for the previous sound() to finish
           sound(y,fs); % Play the signal after Compression
       end

       if (audio_effect(i) == 3)
             %Permute re-arranges dimensions of an array
            y = permute(y,[2 1]); % Move the audio data to the right index to allow 
                                  % reverb to work correctly
           display('Reverberation'); 
           % Call Reverberation function
           y = Reverb(y, fs);
           pause(Time); % Allow time for the previous sound() to finish
           sound(y,fs);
       end

       if (audio_effect(i) == 4)
            % Call Tremolo function
            y = Tremolo(y, fs);
            display('Tremolo');
            pause(Time); % Allow time for the previous sound() to finish
            sound(y, fs);
       end
       
       if (audio_effect(i) == 5)
            % Call Overdrive function
            y = Overdrive(y);
            display('Overdrive');
            pause(Time); % Allow time for the previous sound() to finish
            sound(y, fs);
       end
       
       if (audio_effect(i) == 6)
            % Call Panning function
            y = Panning(y);
            display('Panning');
            pause(Time); % Allow time for the previous sound() to finish
            sound(y, fs);
       end
       
       if (audio_effect(i) == 7)
            % Call Guitar Distortion function
            y = Gdist(y);
            display('Guitar Distortion');
            pause(Time); % Allow time for the previous sound() to finish
            sound(y, fs);
       end
       
       if (audio_effect(i) == 8)
            % Call Echo function
            y = Echo(y, fs);
            display('Echo');
            pause(Time); % Allow time for the previous sound() to finish
            sound(y, fs);
       end
       
             
       if (audio_effect(i) == 10)
            % Call Fuzz function
            y = Fuzz(y, fs);
            display('Fuzz');
            pause(Time); % Allow time for the previous sound() to finish
            sound(y, fs);
       end

        if (audio_effect(i) == 11)
            % Call Chorus function
            y = Chorus(y, fs);
            display('Chorus');
            pause(Time); % Allow time for the previous sound() to finish
            sound(y, fs);
        end

        if (audio_effect(i) == 12)
            % Call Vibrato function
            y = Vibrato(y, fs);
            display('Vibrato');
            pause(Time); % Allow time for the previous sound() to finish
            sound(y, fs);
        end

        if (audio_effect(i) == 13)
            % Call Wah - Wah function
            y = WahWah(y, fs);
            display('Wah - Wah');
            pause(Time); % Allow time for the previous sound() to finish
            sound(y, fs);
        end
        
        if (audio_effect(i) == 14)
            % Call Convolutional Reverberation function
            y = ReverbConvolutional(y, h);
            display('Convolutional Reverberation');
            pause(Time); % Allow time for the previous sound() to finish
            sound(y, fs);
        end
        
        if (audio_effect(i) == 15)
            % Call Expansion function
            y = Expansion(y, fs);
            display('Expansion');
            pause(Time); % Allow time for the previous sound() to finish
            sound(y, fs);
        end
              
    
    end
   
   % Write audio to new .wav file
   audiowrite('path\output\outputSeries.wav', y, fs, 'BitsPerSample', 32);
   pause(Time); % Allow time for the previous sound() to finish
   display('Final signal');
   sound(y,fs); % Play signal after Reverb
    
else
    
    %--------------------------- Parallel ---------------------------
    % Call all functions for audio effects
    y1 = Flanger(x, fs);
    y2 = Compression(x, fs);
    y3 = Reverb(x, fs);
    y5 = Tremolo(x, fs);
    y6 = Overdrive(x);
    y7 = Panning(x);
    y8 = Gdist(x);
    y9 = Echo(x, fs);
    y11 = Fuzz(x, fs);
    y12 = Chorus(x, fs);
    y13 = Vibrato(x, fs);
    y14 = WahWah(x, fs);
    y15 = ReverbConvolutional(x, h);
    y16 = Expansion(x, fs);
    



    
    % Ask user if they want to hear the signals after each audio effect
    playbackQuestion = input('Enter 1 to hear each signal or 0 to continue:');
    if (playbackQuestion == 1)
        
        display('Original sound'); % Print description of signal to screen
        sound(x, fs);   % Play signal
        pause(Time);    % Allow time for the previous sound() to finish
       
        display('Flanger');
        sound(y1, fs);  % Play signal
        pause(Time);    % Allow time for the previous sound() to finish
        
        display('Compressor');  % Print description of signal to screen
        sound(y2, fs);      % Play signal
        pause(Time);        % Allow time for the previous sound() to finish
        
        display('Reverberation');  % Print description of signal to screen
        sound(y3, fs);      % Play signal
        pause(Time);        % Allow time for the previous sound() to finish
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        display('Convolution Reverberation');  % Print description of signal to screen
        y15 = y15(1: size(y3));
        sound(y15, fs);      % Play signal
        pause(Time);        % Allow time for the previous sound() to finish
        
        display('Tremolo');  % Print description of signal to screen
        sound(y5, fs);      % Play signal
        pause(Time);        % Allow time for the previous sound() to finish
        
        display('Overdrive');  % Print description of signal to screen
        sound(y6, fs);      % Play signal
        pause(Time);        % Allow time for the previous sound() to finish 
        
        display('Panning');  % Print description of signal to screen
        sound(y7, fs);      % Play signal
        pause(Time);        % Allow time for the previous sound() to finish
        
        display('Guitar Distortion');  % Print description of signal to screen
        sound(y8, fs);      % Play signal
        pause(Time);        % Allow time for the previous sound() to finish
        
        display('Echo');  % Print description of signal to screen
        sound(y9, fs);      % Play signal
        pause(Time);        % Allow time for the previous sound() to finish
        
        
        display('Fuzz');  % Print description of signal to screen
        sound(y11, fs);      % Play signal
        pause(Time);        % Allow time for the previous sound() to finish       
        
        display('Chorus');  % Print description of signal to screen
        sound(y12, fs);      % Play signal
        pause(Time);        % Allow time for the previous sound() to finish
        
        display('Vibrato');  % Print description of signal to screen
        sound(y13, fs);      % Play signal
        pause(Time);        % Allow time for the previous sound() to finish
        
        display('Wah - Wah');  % Print description of signal to screen
        sound(y14, fs);      % Play signal
        pause(Time);        % Allow time for the previous sound() to finish
        
        display('Expansion');  % Print description of signal to screen
        sound(y16, fs);      % Play signal
        pause(Time);        % Allow time for the previous sound() to finish
        
       
        
    end   
  
    y2 = permute(y2,[2 1]); % Moves the audio data to the right index
    % normalise 
    y1 = (y1./max(abs(y1)))*(1 - (2^-(32 - 1)));
    y2 = (y2./max(abs(y2)))*(1 - (2^-(32 - 1)));
    y3 = (y3./max(abs(y3)))*(1 - (2^-(32 - 1)));
    y5 = (y5./max(abs(y5)))*(1 - (2^-(32 - 1)));
    y6 = (y6./max(abs(y6)))*(1 - (2^-(32 - 1)));
    y7 = (y7./max(abs(y7)))*(1 - (2^-(32 - 1)));
    y8 = (y8./max(abs(y8)))*(1 - (2^-(32 - 1)));
    y9 = (y9./max(abs(y9)))*(1 - (2^-(32 - 1)));
    y11 = (y11./max(abs(y11)))*(1 - (2^-(32 - 1)));
    y12 = (y12./max(abs(y12)))*(1 - (2^-(32 - 1)));
    y13 = (y13./max(abs(y13)))*(1 - (2^-(32 - 1)));
    y14 = (y14./max(abs(y14)))*(1 - (2^-(32 - 1)));
    y15 = (y15./max(abs(y15)))*(1 - (2^-(32 - 1)));
    y16 = (y16./max(abs(y16)))*(1 - (2^-(32 - 1)));
    
    audiowrite('path\output\outputFlanger.wav',y1, fs, 'BitsPerSample', 32);
    audiowrite('path\output\outputCompressor.wav',y2, fs, 'BitsPerSample', 32);
    audiowrite('path\output\outputReverb.wav',y3, fs, 'BitsPerSample', 32);
    audiowrite('path\output\outputTremolo.wav',y5, fs, 'BitsPerSample', 32);
    audiowrite('path\output\outputOverdrive.wav',y6, fs, 'BitsPerSample', 32);    
    audiowrite('path\output\outputPanning.wav',y7, fs, 'BitsPerSample', 32);
    audiowrite('path\output\outputGuitarDistortion.wav',y8, fs, 'BitsPerSample', 32);
    audiowrite('path\output\outputEcho.wav',y9, fs, 'BitsPerSample', 32);                                  
    audiowrite('path\output\outputFuzz.wav',y11, fs, 'BitsPerSample', 32);
    audiowrite('path\output\outputChorus.wav',y12, fs, 'BitsPerSample', 32);
    audiowrite('path\output\outputVibrato.wav',y13, fs, 'BitsPerSample', 32);
    audiowrite('path\output\outputWahWah.wav',y14, fs, 'BitsPerSample', 32);
    audiowrite('path\output\outputConvReverb.wav',y15, fs, 'BitsPerSample', 32);
    audiowrite('path\output\outputExpansion.wav',y16, fs, 'BitsPerSample', 32);
    
    
    % Sum all effects to the signal
    y = y1 + y2 + y3 + y5 + y6 + y7 + y8 + y9 + y11 + y12 + y13 + y14 + ...
        y15 + y16;
    
    % Normalise final signal
    y = y./max(y);
    
    pause(Time); % Allow time for the previous sound() to finish
    display('Final signal');
    sound(y, fs); % Play final signal
    
end