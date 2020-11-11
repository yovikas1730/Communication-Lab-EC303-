M = 4; % Alphabet size
dataIn = randi([0 M-1],10,1); % Random message
subplot(3,1,1);
plot(dataIn);
title('Input Message');
txSig = dpskmod(dataIn,M); % Modulate
subplot(3,1,2);
title('DPSK Modulated bits');
rxSig = txSig*exp(2i*pi*rand());
dataOut = dpskdemod(rxSig,M);
subplot(3,1,3);
plot(dataOut);
title('DPSK Demodulated bits');