%Reversing tremordetection steps to make simulated data
%Parkinson's patient, no voluntary motion

%Simulated data should end up with peakf between 3.5 and 7.5 Hz.  Studies
%show 4, 5, 6, one shows 8; use 5.5 Hz, halfway point
peakf=5.5;
f=(0.1:0.1:50);
ps=zeros(1,500);
fs=100;

div1=3.2*10;
divf=50*10;

%With directional voluntary motion, low frequencies have high amp, 2 to 3
volampa=2;
volampb=3;
for i=1:div1
    ps(i)=volampa+(volampb-volampa)*rand;
end

%Between 0 and 1 percent for all other frequencies
for i=div1+1:divf
    ps(i)=0.01*rand;
end

%ps is simulated frequency data; perform ifft to get simulated
%accelerometer data

%"Unprocess" first, make more realistic/"raw"
%Add in noise
angles=rand(1,500)*2*pi;
Re=zeros(1,500);
Im=zeros(1,500);
for i=1:500
    Re(i)=ps(i)*cos(angles(i));
    Im(i)=ps(i)*sin(angles(i));
end
psnew=Re+(Im*1j);
%Taper ends with tukeywin
psnew=psnew.*tukeywin(500,0.75)';

%Now convert to time
simdatmag=ifft(psnew);
save('SimulatedData2b','simdatmag')

%plot Accelerometer data
x=0.01*(1:500);
figure
plot(x,simdatmag)
xlabel('Time (seconds)')
ylabel('Accelerometer Data (m/s^2)')
title('Simulated Accelerometer Data for Parkinsons Patient')

%Does the simulated frequency data actually match the PD metrics?
peakpower=sum(ps(52:58));
totpower=sum(ps(32:120));
rat=peakpower/totpower;
if rat>=0.85
    fprintf('Peak Power is %d of total power spectra\n',rat)
    fprintf('Tremor detected is valid Parkinsons tremor\n')
else
    fprintf('No Parkinsons, peak power is %d\n', rat)
end