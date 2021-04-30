%Detecting tremor
%Read in accelerometer and gyroscope raw data

%FOR ALL DATA CHANNELS, USE FOR LOOP

%Remove drift
%(Gaussian filter?  Or actually, finding average of long time span signal
%from device at rest, subtracting that--check labs? and optical microscopy)
%Cannot do this part without device--not part of simulated data-running

%Power spectrum--basically an fft, check old Measurements labs for info
ps=fft(timedatavec, 500);
fs=100;
M=500;
fres=fs/M;  %fres=0.1Hz
fN=fs/2;  %highest frequency in fft is 50
f=(0.1:0.1:50);

%Remove noise from gravity, diskinesia, and voluntary movement
%(Band pass filter, leave only 3.25 to 12 Hz)
%Bin width is 0.1, so 3.2 Hz occurs at ps(32), 12Hz at ps(120)
ps(1:32)=0;
ps(120:500)=0;

%Find peak frequency
[psmax, indexF]=max(ps);
fpeak=f(indexF);

%Find peak power sum--sum of values within 0.3Hz of peakf
i1=indexF-3;
i2=indexF+3;
peakpower=sum(ps(i1:i2));
totpower=sum(ps(32:120));
rat=peakpower/totpower;
if rat>=0.85
    fprintf('Peak Power is %d of total power spectra\n',rat)
    fprintf('Tremor detected is valid Parkinsons tremor\n')
else
    fprintf('No Parkinsons, peak power is %d\n', rat)
end

%Might need to mess around with complex conjugates and crap if I don't
%limit fft to real values first.  Try both methods (no adjusting fft, yes 
%using complex conjugate; then adjusting fft, using just sum), see if 
%they output the same values?

%END FOR LOOP

%Find max peak power sum of all data channels
%Associated peak frequency is new peak frequency for all channels

%Determine validity of tremor using maxpeaksum channel ONLY:
%(Other options for this in reality, would want to try many methods to see
%what gave best results if we had actual data)
%Is peaksum>0.85*totalsum?  (totalsum=sum(power)/sum(index))

%FOR ALL DATA CHANNELS AGAIN, USE FOR LOOP

%Now use peakf to find peaksum (WITH PEAKF, NOT WITH MAXF FOR THAT CHANNEL)
%for all channels

%END FOR LOOP

%Sum peaksums and record totalpeaksum and peakf
%If peakf is between 3.5 and 7.5 Hz, and totalpeaksum>threshold, tremor=PD
