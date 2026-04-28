clear; clc;

M = 8;          % 8PSK
k = 3;          % bits per symbol
N = 30000;      % total bits

data = randi([0 1],N,1);

% reshape bits to symbols
bits = reshape(data,[],3);

% binary to decimal
symbols = bits(:,1)*4 + bits(:,2)*2 + bits(:,3);

% -------- 8PSK Modulation --------
theta = 2*pi*symbols/M;
tx = exp(1j*theta);

snr_dB = 0:2:20;
ber = zeros(size(snr_dB));

for n = 1:length(snr_dB)

    snr = 10^(snr_dB(n)/10);

    % noise variance
    sigma = sqrt(1/(2*snr));

    noise = sigma*(randn(size(tx)) + 1j*randn(size(tx)));

    rx = tx + noise;

    % -------- Demodulation --------
    phase = angle(rx);

    phase(phase<0) = phase(phase<0)+2*pi;

    demod = round(phase/(2*pi/M));
    demod(demod==8)=0;

    % decimal to bits
    b1 = floor(demod/4);
    b2 = floor(mod(demod,4)/2);
    b3 = mod(demod,2);

    bitsHat = [b1 b2 b3];
    bitsHat = bitsHat(:);

    ber(n) = sum(bitsHat~=data)/N;

end

% -------- Plot --------
semilogy(snr_dB,ber,'-o','LineWidth',2)
grid on
xlabel('SNR (dB)')
ylabel('BER')
title('8PSK BER')