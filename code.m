%Generate n Random bits
fs = 10;
n = 5;
randomBits = randi([0 1],n,1);
EN0 = [-10:1:20];
%Present the bits with rect Pulses
fullWaveForm = zeros(1,numel(randomBits)*fs);
for i = 1:numel(randomBits)
	if (randomBits(i) == 1)
       fullWaveForm((i-1)*fs+1 : i*fs) =  ones(1, fs);
   else
       fullWaveForm((i-1)*fs+1 : i*fs) =  -1* ones(1, fs);
   end
end
fullWaveForm(n*fs) = fullWaveForm(n*fs-1);
dt = 1/fs ;
numCycles = n;
t = dt * (1 : (numel(fullWaveForm)));
 
plot(t, fullWaveForm, 'b-', 'LineWidth', 2);
FontSize = 20;
xlabel('Time (seconds)', 'FontSize', FontSize);
ylabel('Amplitude', 'FontSize', FontSize);
title('Original Signal', 'FontSize', FontSize);
grid on;
%Construct And convolve Matched Filter.
   MatchedFilter = ones(1, fs);
   OutMatched = filter(MatchedFilter,1,fullWaveForm);
   figure;
   plot(t, OutMatched, 'b-', 'LineWidth', 2);
   FontSize = 20;
   xlabel('Time (seconds)', 'FontSize', FontSize);
   ylabel('Amplitude', 'FontSize', FontSize);
   title('Output from Matched Filter', 'FontSize', FontSize);
   grid on;
 
%Construct And convolve Delta Filter.
   DeltaFilter = 1;
   OutDelta = filter(DeltaFilter,1,fullWaveForm);
   figure;
   plot(t, OutDelta, 'b-', 'LineWidth', 2);
   FontSize = 20;
   xlabel('Time (seconds)', 'FontSize', FontSize);
   ylabel('Amplitude', 'FontSize', FontSize);
   title('Output from Delta Filter', 'FontSize', FontSize);
   grid on;
 
%Construct And convolve Triangle Filter.
   w=1; % signal width
   Amp=1; % signal amplitude
   tt=0:1/fs:w-1/fs;
   TriFilter=(Amp*abs(tt)/w-Amp+1)*sqrt(3);
   OutTri = filter(TriFilter,1,fullWaveForm);
   figure;
   plot(t, OutTri, 'b-', 'LineWidth', 2);
   FontSize = 20;
   xlabel('Time (seconds)', 'FontSize', FontSize);
   ylabel('Amplitude', 'FontSize', FontSize);
   title('Output from Triangle Filter', 'FontSize', FontSize);
   grid on;
 
for i=1:length(EN0)
%Add Noise
   AfterNoise = awgn(fullWaveForm,EN0(i),'measured','db');
%convolve Matched Filter.
   OutMatched = filter(MatchedFilter,1,AfterNoise);
%convolve Delta Filter.
   OutDelta = filter(DeltaFilter,1,AfterNoise);
%convolve Triangle Filter.
   OutTri = filter(TriFilter,1,AfterNoise);
 
%Sample At t
   SampleMatched = sign(OutMatched(fs:fs:end));
   SampleDelta = sign(OutDelta(fs:fs:end));
   SampleTri = sign(OutTri(fs:fs:end));
%Recover sent bits
   RecievedMatched=(SampleMatched+1)/2;
   RecievedDelta=(SampleDelta+1)/2;
   RecievedTri=(SampleTri+1)/2;
 
%Calculate BER
   BERMatched(i) = mean(abs( randomBits'-RecievedMatched ));
   BERDelta(i) = mean(abs(randomBits'-RecievedDelta));
   BERTri(i) = mean(abs(randomBits'-RecievedTri));
end
 
figure;
semilogy(EN0,BERMatched,'-ro', EN0,BERDelta,'-b.',EN0,BERTri,'-g*')
title ('SNR Vs BER');
xlabel ('E/N0 (dB)');
ylabel ('Bit Error Rate');
legend('Matched Filter', 'Delta', 'Triangle Filter');
grid on;
