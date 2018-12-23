function [t, env] = dBenvelope(x, frameLen, fs)

% This function returns an interpolated dB amplitude envelope of x

ts = 1 / fs;
dur = length(x)/fs;
t = 0 : ts : dur-ts;
% initialize frame positions
frStart = 1;
frEnd = frameLen;
numFrames = floor(length(x)/frameLen);
for i = 1 : numFrames
   % Compute peak envelope
   frameCtrs(i) = t(frStart + round(frEnd-frStart));
   ampXpeak(i) = 20 * log10(max(abs(x(frStart : frEnd)))); %Peak Amplitude
   % update frame position
   frStart = frStart + frameLen;
   frEnd = frEnd + frameLen;
end
% interpolate the envelope
frameCtrs = frameCtrs;
ampXpeak = ampXpeak;
env = interp1(frameCtrs, ampXpeak, t);
env = env(~isnan(env));
t   = t(~isnan(env));


end