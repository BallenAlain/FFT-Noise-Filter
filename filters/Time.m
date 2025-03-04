clear;
close all;

% read samples and sampling frequency
[y,fs] = audioread('music_noisy.wav'); 

%
% Low pass filter
%
fLow=[1000,1100]; % define passband edge and stopband edge
aLow=[1,0]; % order (passband, stopband)
devLow=[0.0001,0.0001]; % define stopband and passband ripples
 
[NL,FiL,AiL,WL]=firpmord(fLow,aLow,devLow,fs);
bLow=firpm(NL,FiL,AiL,WL); %coefficient
figure;
freqz(bLow);
%
% Band pass filter
%
fBand=[1100,1500,2000,2700]; % define passband edges and stopband edges
aBand=[0,1,0]; % order (stopband,passband,stopband)
devBand=[0.0001,0.001,0.0001]; % define stopband and passband ripples

[NB,FiB,AiB,WB]=firpmord(fBand,aBand,devBand,fs);
bBand=firpm(NB,FiB,AiB,WB); %coefficient
figure;
freqz(bBand);

%
% Band pass filter
%
fHigh=[2760,2780]; % define passband edges and stopband edges
aHigh=[0,1]; % order (stopband,passband)
devHigh=[0.001,0.001]; % define stopband and passband ripples

[NH,FiH,AiH,WH]=firpmord(fHigh,aHigh,devHigh,fs);
bHigh=firpm(NH,FiH,AiH,WH); %coefficient
figure;
freqz(bHigh);

% compute convolution of each filter's coefficient and samples
Low = conv(y,bLow,'same');
Med = conv(y,bBand,'same');
High = conv(y,bHigh,'same');

res = Low + Med + High; % Combine results of convolutions
audiowrite('testfir.wav', res, fs); % write to file using new samples

[test] = audioread('testfir.wav'); % read samples of file
testz = fft(test); % Fast fourier transform of samples
z = fftshift(testz); % Shift
[N,P] = size(test);
f=-fs/2:fs/(N-1):fs/2;
figure;
plot(f,abs(z)); % analysis of plots