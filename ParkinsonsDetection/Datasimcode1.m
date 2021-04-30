%Reversing tremordetection steps to make simulated data
%Parkinson's patient, no voluntary motion

%Simulated data should end up with peakf between 3.5 and 7.5 Hz.  Studies
%show 4, 5, 6, one shows 8; use 5.5 Hz, halfway point
peakf=5.5;
f=(0.1:0.1:50);
ps=zeros(1,500);
fs=100;

div1=3.2*10;
div2=4.9*10;
div3=5.2*10;
div4=5.5*10;
div5=5.8*10;
div6=6.1*10;
boxf=(50-6.1)*10;
divf=50*10;

%Without voluntary motion, low frequencies have low amplitude, 3-8% of peak
volampa=0.03;
volampb=0.08;
for i=1:div1
    ps(i)=volampa+(volampb-volampa)*rand;
end

%Between 0 and 1 percent
for i=div1+1:div2
    ps(i)=0.01*rand;
end

%Between 0 and 8 percent, steadily building, with 0 to 2 percent deviation
ps(50)=0.08/3;
ps(51)=2*0.08/3;
ps(52)=0.08;
signvec=[1 -1];
for i=div2+1:div3
    sign=signvec(randi(2));
    ps(i)=ps(i)+sign*rand*0.02;
end

%Between 8 and 100 percent, steadily building and falling (peak at ps(55)),
%0 to 8 percent deviation
ps(53)=0.08+1.12/3;
ps(54)=0.08+2*1.12/3;
ps(55)=1.2;
ps(56)=ps(54);
ps(57)=ps(53);
for i=div3+1:div5-1
    sign=signvec(randi(2));
    ps(i)=ps(i)+sign*rand*0.08;
end

%Between 8 and 0 perecent, steadily falling, 0 to 2 percent deviation
ps(58)=0.08;
ps(59)=ps(51);
ps(60)=ps(50);
for i=div5:div6-1
    sign=signvec(randi(2));
    ps(i)=ps(i)+sign*rand*0.02;
end

%Between 0 and 1 percent
for i=div6:divf
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
save('SimulatedData1','simdatmag')

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