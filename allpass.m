function y = allpass(x, fs, gain, delayLen)

% Calculate delay length in samples
delayLen = round(delayLen * fs); 
% create coefficient filters that will shape the signal
b = [gain, zeros(1, delayLen - 1), 1];
a = [1,    zeros(1, delayLen - 1), gain];
% filter the input signal 
y = filter(b, a, x);

end
