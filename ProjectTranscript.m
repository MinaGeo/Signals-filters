fo = 440;
a = 2^(1/12);
fn9 = fo*a^(-9); %Frequency of DO
fn7 = fo*a^(-7); %Frequency of RE
fn5 = fo*a^(-5); %Frequency of MI
fn4 = fo*a^(-4); %Frequency of FA
arr = [fn9 fn7 fn5 fn4];
fs = 10*max(arr); %sampling frequency
frmsz = round(0.5*fs); %framesize since duration of each musical note is half a second
t = (0:1:frmsz-1)*(1/fs); %time for every signal 
x1t = cos(2*pi*fn9*t); 
x2t = cos(2*pi*fn7*t);
x3t = cos(2*pi*fn5*t);
x4t = cos(2*pi*fn4*t);
xt = [x1t, x2t, x3t, x4t]; %concatenation
sound(xt,fs); %sound of DO, RE, MI, FA
audiowrite('soundWavefin.wav', xt, round(fs)); %creates and saves a .wav file with the provided signal (xt)
frmsz = 4*frmsz; %since framesize with original only fit for 1 wave,  there’s now 4 signals concatenated therefore, 4*frmsz
t = (0:1:frmsz-1)*(1/fs); %updated time after frmsz got changed
figure; plot(t, xt);
E_xt = sum(abs(xt.^2))/fs; %energy of xt
xf = fftshift(fft(xt))/fs; %(xf) is frequency spectrum of xt
f = ((-frmsz/2):1:(frmsz/2)-1)*(fs/frmsz); %frequency
figure; plot(f, abs((xf)));
E_xf = sum(abs(xf.^2))*(fs/frmsz); %energy of xt from its frequency spectrum (xf)
fcutoff = (fn5 + fn7)/2; %cut-off frequency
[b, a] = butter(20, fcutoff/(fs/2)); %creation of low-pass filter using butter
figure; freqz(b,a);%plots magnitude and phase response of low pass filter [0 to (frmsz/2)-1]
figure; freqz(b,a,[f],fs); %plots magnitude and phase response of low pass filter [(frmsz/2) to (frmsz/2)-1]
y1t = filter(b,a,xt); %y1t is xt after applying low pass filter
sound(y1t,fs); %sound of DO, RE, MI, FA after low pass filter
audiowrite('lowPass.wav', y1t, round(fs)); %creates and saves .wav file for the provided signal (y1t)
figure; plot(t, y1t); 
E_y1t = sum(abs(y1t.^2))/fs; %energy of the signal y1t
y1f = fftshift(fft(y1t))/fs; %(y1f) is frequency spectrum of y1t
f = ((-frmsz/2):1:(frmsz/2)-1)*(fs/frmsz); %frequency (reassuring)
figure; plot(f, abs((y1f)));
E_y1f = sum(abs(y1f.^2))*(fs/frmsz); %energy of signal y1f 
fcutoff = (fn5 + fn7)/2;  %cut-off frequency
[Bh,Ah] = butter(20,fcutoff/(fs/2),'high'); %creation of high-pass filter using butter
figure; freqz(Bh,Ah);%plots magnitude and phase response of high pass pass filter [0 to (frmsz/2)-1]
figure; freqz(Bh,Ah,[f],fs);%plots magnitude and phase response of high pass pass filter [(frmsz/2) to (frmsz/2)-1]
y2t = filter(Bh,Ah,xt); %y2t is xt after applying high pass filter
sound(y2t,fs); %sound of DO, RE, MI, FA after high pass filter
audiowrite('highPass.wav', y2t, round(fs)); %creates and saves .wav file for the provided signal (y2t)
figure; plot(t,y2t);
E_y2t = sum(abs(y2t.^2))/fs; %energy of the signal y2t
y2f = fftshift(fft(y2t))/fs; %(y2f) is frequency spectrum of y2t 
f = ((-frmsz/2):1:(frmsz/2)-1)*(fs/frmsz); %frequency (reassuring)
figure; plot(f, abs((y2f)));
E_y2f = sum(abs(y2f.^2))*(fs/frmsz); %energy of signal y2f 