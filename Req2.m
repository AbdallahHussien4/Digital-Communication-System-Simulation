%Generate 4 Random bits
randomBits = randi([0 1],4,1);

%Present the bits with rect pulses
fullWaveForm = zeros(1,numel(randomBits)*100);
for i = 1:numel(randomBits)
	if (randomBits(i) == 1)
        fullWaveForm((i-1)*100+1 : i*100) =  ones(1, 100);
    else 
        fullWaveForm((i-1)*100+1 : i*100) =  -1* ones(1, 100);
    end 
end 
fullWaveForm(400) = fullWaveForm(399);
dt = 1/100 ;
numCycles = 4;
t = dt * (0 : (numel(fullWaveForm) - 1));

plot(t, fullWaveForm, 'b-', 'LineWidth', 2);
FontSize = 20;
xlabel('Time (seconds)', 'FontSize', FontSize);
ylabel('Amplitude', 'FontSize', FontSize);
title('Square Wave With 10 Cycles', 'FontSize', FontSize);
grid on;

%Add Noise
AfterNoise = awgn(fullWaveForm,20,'measured','db');
plot(t, AfterNoise, 'b-', 'LineWidth', 2);
FontSize = 20;
xlabel('Time (seconds)', 'FontSize', FontSize);
ylabel('Amplitude', 'FontSize', FontSize);
title('Signal After Noise', 'FontSize', FontSize);
grid on;

%Concolution


%Calc POE
