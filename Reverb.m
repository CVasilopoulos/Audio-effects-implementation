function y = Reverb(x, fs)

% This function creates Reverb

    % Initialize Reverb parameters
    earlyGain = 0.9;
    lateGain = 0.4;

    earlyDelayLen = [0.005, 0.002, 0.001]; % Array with early delay time in seconds
    leateDelayLen = [0.1, 0.09, 0.08, 0.095]; % Array with late time in seconds


    % Here allpass filters are used to simulate early reflections of space
    % Series processing
    y = allpass(x, fs, earlyGain, earlyDelayLen(1));
    y = allpass(y, fs, earlyGain, earlyDelayLen(2));
    y = allpass(y, fs, earlyGain, earlyDelayLen(3));

    % Here four comb filters are processed in parallel, simulating the late
    % delay reflections
    y1 = comb(y, fs, lateGain, leateDelayLen(1));
    y2 = comb(y, fs, lateGain, leateDelayLen(2));
    y3 = comb(y, fs, lateGain, leateDelayLen(3));
    y4 = comb(y, fs, lateGain, leateDelayLen(4));

    % Mix filtered signals
    y = y1 + y2 + y3 + y4; % Sum the parallel processed signals
    y = y./ max(y); % Normalise the output signal

    %----- Plot -----
    % Plot Original Signal
    figure 
    subplot(4,1,1); 
    plot(x, 'k'); 
    title('Original signal'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    grid on;

    % plot signal after Reverb
    subplot(4,1,2); 
    plot(y, 'k'); 
    ylabel('Amplitude');
    xlabel('Time (s)');
    title ('(REVERB) Signal after Reverb'); 
    grid on;

    % --------------------------- Central time ---------------------------

    %Central time is the centre of gravity of the reverb tail
    %It is measured in seconds and normalised to the length of the impulse
    %response and found by taking the cntroid across the IR

    %Calculate interpolated envelope in dB 
    [t, e] = dBenvelope(y, 512, fs);
    cTime = sum(t.*e)./sum(e); %Calculate the central time by summing the time and envelopes

    %Plot central
    subplot(4,1,3); 
    plot(t, e, 'k'); %Plot time
    title('(REVERB)Central time');
    ylabel('Level (dB)');
    xlabel('Time (s)');
    grid on; hold on; 
    plot([cTime, cTime], [min(e), max(e)], 'r'); %Plot the envelope


    %--------------------------- Reverb time ---------------------------


    %T Create an impulse response
    dur = 1; % Duration
    b = [1 1]; % Array to hold IR points
    N = round(dur*fs); % Find the length
    h = zeros(1, fs); % Add extra empty zero data to be correct length
    h(1) = b(1); % Apply filters
    h(N) = b(2); 

    % Using the reverb algorithm, now the input is the artifical impulse
    % esponse instead
    % Allpass filters
    RTSig = allpass(h, fs, earlyGain, earlyDelayLen(1));
    RTSig = allpass(RTSig, fs, earlyGain, earlyDelayLen(2));
    RTSig = allpass(RTSig, fs, earlyGain, earlyDelayLen(3));

    % Comb-filters
    RTSig1 = comb(RTSig, fs, lateGain, leateDelayLen(1));
    RTSig2 = comb(RTSig, fs, lateGain, leateDelayLen(2));
    RTSig3 = comb(RTSig, fs, lateGain, leateDelayLen(3));
    RTSig4 = comb(RTSig, fs, lateGain, leateDelayLen(4));

    % Mix filtered signals
    RTSig = RTSig1+RTSig2+RTSig3+RTSig4;
    RTSig = RTSig./max(RTSig); %Normalise the output signal

    % Calculate interpolated envelope in dB
    [t, e] = dBenvelope(RTSig, 512, fs);

    % Find the peak in the envelope
    [peakVal, peakIdx] = max(e);

    % Check if peak value falls below 60 dB
    if( (peakVal-min(e)) > 60)   
        % Reverb tail - measuring peak at the end    
        tail = e(peakIdx)-e(peakIdx:end); 
        lessThan60 = find(tail>60); % Checking if decayed by 60dB
        rt60Idx = lessThan60(1);      
        RT60 = (rt60Idx-peakIdx)/fs 

    else
        % If it never falls below 60dB use the end of file
        RT60 = (length(x)-peakIdx)/fs;   

    end
    % --------------------------- Plot --------------------------- 
    % Plot the resultant reverb time diagram
    subplot(4,1,4); 
    plot(t, e, 'k'); 
    title ('(REVERB) Reverb time (RT60) of algorithm'); 
    ylabel('Level (dB)');
    xlabel('Time (s)');
    grid on; hold on; 
    axis([t(1), t(end), min(e), max(e)]);
    plot([t(peakIdx) t(peakIdx)], [min(e) max(e)], 'r');
    plot([t(rt60Idx) t(rt60Idx)], [min(e) max(e)], 'r');

end