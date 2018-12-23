function  y = Compression(x, fs)

% This function creates Compression

    % Initialize Compression parameters
    ratio = 0.6;
    threshold = -1;
    knee = 1;
    dBGain = 3;

    ts = 1 / fs;
    dur = length(x) / fs; 
    time = 0 : ts : dur - ts; 

    %--------------------------- Plot signal before compression ---------------------------

    % RMS Calculated by taking the root mean squared (RMS) for each frame of audio
    % Peak amplitude calculated by taking the max and min value for each frame
    % of audio

    %Create frame parameters 
    frameLen = 268;
    frStart = 1;
    frEnd = frameLen;

    % Add extra zeros for correct matrix dimensions
    numFrames = floor(length(x) / frameLen);
    y=x;


    for i = 1:numFrames
       % Calculate Gain and apply it to a frame
       frameCtrsC(i) = time(frStart + round(frEnd - frStart)); % Time of signal from start to end
       ampXrms(i) = sqrt(mean(y(frStart : frEnd).^2)); % Calculate RMS amplitude
       ampXpeak(i) = max(x(frStart : frEnd)); % Calculat peak amplitude

       %Update frame position with new data
       frStart = frStart + frameLen;
       frEnd = frEnd + frameLen;
    end

    %Plot RMS amp
    figure 
    subplot(5,1,1);
    plot(time, x); hold on; grid on;
    plot(frameCtrsC, ampXrms, 'r', 'LineWidth', 2 )
    ylabel('Gain (dB)')
    xlabel('Time (s)')
    title('(COMPRESSION)RMS Amplitude envelope')

    %Plot peak amp
    subplot(5,1,2);
    plot(time, x); hold on; grid on;
    plot(frameCtrsC, ampXpeak, 'r', 'LineWidth', 2 ) 
    ylabel('Gain (dB)')
    xlabel('Time (s)')
    title('(COMPRESSION)Peak Amplitude envelope')

    %--------------------------- Compression ---------------------------


    % Compute knee coefficients
    % Quadratic-spline interpolation calculates coefficients based on polynomial equations.
    % knee width is represented as two sample points x1 = T - k / 2
    %                                                x2 = T + k / 2
    % Then it interpolates between the two points using this quadratic equation:
    % a1 + b1x + c1x^2

    c0 = -((ratio - 1.0) * (threshold * threshold - knee * threshold + knee * knee / 4.0)) / (2.0 * knee * ratio);
    c1 = ((ratio - 1) * threshold + (ratio + 1) * knee / 2.0) / (knee * ratio);
    c2 = (1 - ratio) / (2.0 * knee * ratio);


    y = zeros(1, length(x));
    for n = 1 : length(x)
        % If orginal siganl is equal to or below the threshold then do not
        % effect the signal.
        if (x(n) <= threshold - (knee * 0.5))
            y(n) = x(n);
        % Calculate compressed part
        elseif (x(n) > threshold + (knee * 0.5)) 
            % Reduce gain by the gain reduction threshold ratio 
            y(n) = threshold + (x(n) - threshold) / ratio; 
        % Compute knee smoothing
        else
            y(n) = x(n) * x(n) * c2 + x(n) * c1 + c0; % multiply signal by knee coefficients
        end

    end

    %--------------------------- Transfer function plot ---------------------------


    subplot(5,1,3);
    plot(x, y, 'k'); hold on; % Plot origianl signal and processed signal
    plot([threshold, threshold],[min(x), max(x)], 'k--');% threshold - min max
    plot([min(x), max(x)],[threshold, threshold], 'k--');% Min max - threshold
    title('(COMPRESSION)Transfer function');

    % --------------------------- Make up gain ---------------------------

    % Apply make up gain
    y = y.* (10.^(dBGain/20)); 


    % --------------------------- Plot signal after compression and gain ---------------------------

    %RMS Calculated by taking the root mean squared (RMS) for each frame of audio
    %Peak amplitude calculated by taking the max and min value for each frame
    %of audio


    frameLen_AfterC = 268;
    frStart_AfterC = 1;
    frEnd_AfterC = frameLen_AfterC;

    % Add extra zeros for correct matrix dimensions
    numFrames_AfterC = floor(length(y)/frameLen_AfterC);


    for i = 1:numFrames_AfterC
       % Calculate Gain and apply it to a frame
       frameCtrs_AfterC(i) = time(frStart_AfterC + round(frEnd_AfterC - frStart_AfterC)); 
       ampYrms_AfterC(i) = sqrt(mean(y(frStart_AfterC : frEnd_AfterC).^2)); %Calculate RMS amplitude
       ampYpeak_AfterC(i) = max(y(frStart_AfterC : frEnd_AfterC)); %Calculate peak amplitude

       % Update frame position with new data
       frEnd_AfterC = frEnd_AfterC + frameLen_AfterC;

    end

    % Plot RMS amp
    subplot(5,1,4); 
    plot(time, y); hold on; grid on;
    plot(frameCtrs_AfterC, ampYrms_AfterC, 'g', 'LineWidth', 2 ) 
    ylabel('Gain (dB)')
    xlabel('Time (s)')
    title('(COMPRESSION)RMS Amplitude envelope after compression')

    %Plot Peak amp
    subplot(5,1,5);
    plot(time, y); hold on; grid on;
    plot(frameCtrs_AfterC, ampYpeak_AfterC, 'g', 'LineWidth', 2 ) 
    ylabel('Gain (dB)')
    xlabel('Time (s)')
    title('(COMPRESSION)Peak Amplitude envelope after compression')

end