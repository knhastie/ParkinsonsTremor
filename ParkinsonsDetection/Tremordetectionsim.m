%Detecting tremor from simulated (one channel) data
%Read in simulated data
load SimulatedData1.mat

%Remove drift--only necessary if Aleks helps with Datasimcode realism

%Produce power spectrum via fft
ps=fft(simdatmag);
fs=100;  %sampling frequency
M=1000;  %number of samples
fres=fs/M;  %bin size, fres=0.1Hz
fN=fs/2;  %highest frequency in fft, fN=50
f=(0.1:0.1:50);

%Remove noise from gravity, diskinesia, and voluntary movement
%Use band pass filter, leave only 3.25 to 12 Hz
%Bin width is 0.1, so 3.2 Hz occurs at ps(32), 12Hz at ps(120)
psraw=ps;
ps(1:32)=0;
ps(120:500)=0;

%Find peak frequency
[psmax, indexF]=max(ps);
fpeak=f(indexF);

%Make fft single-sided
L=length(ps);
P2 = abs(ps/L);
Pnew = P2(1:L/2+1);
Pnew(2:end-1) = 2*Pnew(2:end-1);

%Find peak power sum--sum of values within 0.3Hz of peakf
i1=indexF-3;
i2=indexF+3;
peakpower=sum(Pnew(i1:i2));
totpower=sum(Pnew(32:120));
rat=peakpower/totpower;
%If peak power sum is at least 85% of total sum, tremor is valid
%If tremor frequency is between 3.5 and 7.5, tremor is PD
if rat>=0.75
    fprintf('Peak Power is %d of total power spectra\n',rat)
    fprintf('Tremor detected is valid Parkinsons tremor\n')
else
    fprintf('No Parkinsons, peak power is %d\n', rat)
end
%plot fft
figure
    plot(f, abs(psraw))
    xlabel('Frequency (Hz)')
    ylabel('Amplitude')
    title('FFT of Accelerometer Data')

%Following comment only applies if current peakpower method stops working

%Might need to switch back to complex conjugate stuff, below
%{
If single-sided thing doesn't work
peakpower=sum(ps(i1:i2).^conj(ps(i1:i2)))/(length(ps(i1:i2))^2);
totpower=sum(ps(32:120).^conj(ps(32:120)))/(length(ps(32:120))^2);
rat=peakpower/totpower;
%}
