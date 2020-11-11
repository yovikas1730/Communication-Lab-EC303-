clc;
clear all;
close all;

%Input Signal Generation
Am1 = 5;
Am2 = 2;
fm1 = 1;
fm2 = 20;
fs = 15*fm2;
t = 0:1/fs:1;

x = Am1*sin(2*pi*fm1*t) + Am2*sawtooth(2*pi*fm2*t);

delta = 1/4;

figure(); plot(t, x);
axis([min(t) max(t) (1.5*min(x)) (1.5*max(x))]);
xlabel('Time'); ylabel('Amplitude');
title('Complex Input signal');


%ADM Modulation
xlen = length(x);
ADM = 0;
    
count1 = 0;
count2 = 0;
sum = 0;
    
for i = 1:xlen         
    if x(i) > sum
        if count1 < 2
            sum = sum + delta;
        else
            sum = sum + (min(2^(count1 - 1), 8))*delta;
        end
        if sum < x(i)
            count1 = count1 + 1;
        else
            count1 = 0;
        end
            
    elseif x(i) < sum
        if count2 < 2
            sum = sum - delta;
        else
            sum = sum - (min(2^(count2 - 1), 8))*delta;
        end
        if sum > x(i)
            count2 = count2 + 1;
        else
            count2 = 0;
        end
    end
    ADM(i) = sum
end

figure();
stairs(t, ADM);
hold on;
plot(t, x);

%Signal Smoothening
[num den] = butter(2, 3*fm2/fs);
filter_output = filter(num, den, ADM);

figure();
plot(t, filter_output, 'LineWidth', 3);
hold on; plot(t, x, 'LineWidth', 3);
xlabel('Time'); ylabel('Amplitude');
title('Smoothened ADM signal');
legend('Smoothed no noise received signal', 'Original Signal');
axis([min(t) max(t) (1.5*min(x)) (1.5*max(x))]);