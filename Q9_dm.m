clc;
clear all;
close all;

%Delta Modulation######################################
%######################################################

Am1 = 4;
Am2 = 2;
fm1 = 0.5;
fm2 = 5;
fs = 15*fm2;
t = 0:1/fs:3;

%Input Signal;
x = Am1*sin(2*pi*fm1*t) + Am2*cos(2*pi*fm2*t);
delta = 4*pi*Am1*fm2/fs;

figure(); plot(t, x);
axis([min(t) max(t) (1.5*min(x)) (1.5*max(x))]);
xlabel('Time'); ylabel('Amplitude');
title('Complex Input signal');

xlen = length(x)

%DM Encoding

acc = 0;
for n = 1:length(x)
    if x(n) > acc(n)
        dm_out(n) = 1;
        acc(n+1) = acc(n) + delta;
    else
        dm_out(n) = -1;
        acc(n+1) = acc(n) - delta
    end
end

figure(); stairs(t, dm_out);
axis([min(t) max(t) 1.5*min(dm_out) 1.5*max(dm_out)]);
xlabel('Time'); ylabel('Axis');
title('DM Encoded Signal');

%Adding noise
%Here, noise will be defined as a random flipping of the bit from 1 to 0 or
%0 to 1
% epsilon = 0.005;
% for i = 1:length(dm_out)
%     random = rand(1);
%     if random < epsilon
%         dm_out_noisy(i) = dm_out(i) * -1;
%     else
%         dm_out_noisy(i) = dm_out(i);
%     end
% end

% figure();
% stairs(t, dm_out);
% axis([min(t) max(t) 1.5*min(dm_out) 1.5*max(dm_out)]);
% xlabel('Time'); ylabel('Axis');
% title('DM Encoded Signal w/no noise');


%DM Decoding

recvd_signal_no_noise = dm_out;
acc = 0;

for n = 1:xlen
    if recvd_signal_no_noise(n) > 0
        acc(n+1) = acc(n) + delta;
    else
        acc(n+1) = acc(n) - delta;
    end
end

figure();
stairs(acc); hold on; plot(x);
xlabel('Time'); ylabel('Amplitude');
title('DM Decoded signal');

recv = acc(2:xlen+1);

%Signal Smoothening
[num den] = butter(2, 3*fm2/fs);
filter_output = filter(num, den, recv);

figure();
plot(t, filter_output, 'LineWidth', 3);
hold on; plot(t, x, 'LineWidth', 3);
xlabel('Time'); ylabel('Amplitude');
title('Smoothened DM signal w/no noise');
legend('Smoothed no noise received signal', 'Original Signal');
axis([min(t) max(t) (1.5*min(filter_output)) (1.5*max(filter_output))])

