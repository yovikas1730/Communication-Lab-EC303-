clc;
clear all;
close all;
num_bit=10000;%number of bit
data=randi([0,1],1,num_bit);%random bit generation (1 or 0)
SNRdB=0:10; % SNR in dB
SNR=10.^(SNRdB/10);
for(k=1:length(SNRdB))%BER (error/bit) calculation for different SNR%
y=awgn(complex(data),SNRdB(k));
error=0;
R=0;
M=[];
for(c=1:1:num_bit)
if (y(c)>.5&&data(c)==0)||(y(c)<.5&&data(c)==1)%logic acording to BASK
error=error+1;
M=[M ~data(c)];
else
M=[M data(c)];
end
end
error=error/num_bit; %Calculate error/bit
m(k)=error;
end
semilogy(SNRdB,m,'o','linewidth',2.5),grid on,hold on;
BER_th=(1/2)*erfc(.5*sqrt(SNR));
semilogy(SNRdB,BER_th,'r','linewidth',2.5),grid on,hold on;
title(' curve for Bit Error Rate verses SNR for Binary ASK modulation');
xlabel(' SNR(dB)');
ylabel('BER');
legend('simulation','theorytical')
axis([0 10 10^-5 1]);
