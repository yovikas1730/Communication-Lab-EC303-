clc;
close all;
clear all;
format long;
bit_count = 10000;
Eb_No = -3: 1: 30;
SNR = Eb_No + 10*log10(2);
for aa = 1: 1: length(SNR)
T_Errors = 0;
T_bits = 0;
while T_Errors < 100
uncoded_bits = round(rand(1,bit_count));
B1 = uncoded_bits(1:2:end);
B2 = uncoded_bits(2:2:end);
qpsk_sig = ((B1==0).*(B2==0)*(exp(i*pi/4))+(B1==0).*(B2==1)...
*(exp(3*i*pi/4))+(B1==1).*(B2==1)*(exp(5*i*pi/4))...
+(B1==1).*(B2==0)*(exp(7*i*pi/4)));
ray = sqrt(0.5*((randn(1,length(qpsk_sig))).^2+(randn(1,length(qpsk_sig))).^2));
rx = qpsk_sig.*ray;
N0 = 1/10^(SNR(aa)/10);
rx = rx + sqrt(N0/2)*(randn(1,length(qpsk_sig))+i*randn(1,length(qpsk_sig)));
rx = rx./ray;
B4 = (real(rx)<0);
B3 = (imag(rx)<0);
uncoded_bits_rx = zeros(1,2*length(rx));
uncoded_bits_rx(1:2:end) = B3;
uncoded_bits_rx(2:2:end) = B4;
diff = uncoded_bits - uncoded_bits_rx;
T_Errors = T_Errors + sum(abs(diff));
T_bits = T_bits + length(uncoded_bits);
end
BER(aa) = T_Errors / T_bits;
end
figure(1);
semilogy(SNR,BER,'or');
hold on;
xlabel('SNR (dB)');
ylabel('BER');
title('SNR Vs BER plot for QPSK Modualtion in Rayleigh Channel');
figure(1);
EbN0Lin = 10.^(Eb_No/10);
theoryBerRay = 0.5.*(1-sqrt(EbN0Lin./(EbN0Lin+1)));
semilogy(SNR,theoryBerRay);
grid on;
figure(1);
theoryBerAWGN = 0.5*erfc(sqrt(10.^(Eb_No/10)));
semilogy(SNR,theoryBerAWGN,'g-+'); grid on;
legend('Simulated', 'Theoretical Raylegh', 'Theroretical AWGN');
axis([SNR(1,1) SNR(end-3) 0.00001 1]);