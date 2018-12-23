function [y, b, a] = comb(x, fs, gain, delayLen) 

% This function is the combinational filter
delayLen = round(delayLen*fs);
% create coefficients
b = [zeros(1, delayLen), 1];
a = [1, zeros(1, delayLen-1), -gain]; 
% filter the input signal
y = filter(b,a,x);

end