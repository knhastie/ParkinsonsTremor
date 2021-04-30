%Detecting tremor from simulated (one channel) data
%Read in simulated data
load RealData.mat

t=matdat(1,:);
tpersample=range(t)/length(t);
fs=1/tpersample;  %sampling frequency
M=length(t);  %number of samples
fres=fs/M;  %bin size
fN=fs/2;  %highest frequency in fft
f=(fres:fres:fs);
ps=zeros(3,M);

%Three channels now!  Must perform whole fft process for each
for i=2:4
    %Produce power spectrum via fft
    ps(i-1,:)=fft(matdat(i,:));
end
%Remove noise from gravity, diskinesia, and voluntary movement
%Use band pass filter, leave only 3.25 to 12 Hz

%Because fs is less than 3.2 Hz, all further processing will result in
%errors, so it will remain unrun, as an extended comment.  However,
%these are the next steps that could be taken with data sampled at a
%sampling frequency of 24 Hz or higher
i1=3.2/fres;
i2=12/fres;
psraw=ps;
ps(:,1:i1)=0;
ps(:,i2:M)=0;

index=zeros(1,3);
fpeak=zeros(1,3);
ps1s=zeros(size(ps));
peakpower=zeros(1,3);
totpower=zeros(1,3);
rat=zeros(1,3);
for i=1:3
    %Find peak frequency
    psn=ps(i,:);
    [psnmax, indexF]=max(psn);
    index(i)=indexF;
    fpeak(i)=f(indexF);
    
    %Make fft single-sided
    L=length(psn);
    P2 = abs(psn/L);
    Pnew = P2(1:L/2+1);
    Pnew(2:end-1) = 2*Pnew(2:end-1);
    ps1s(i,:)=Pnew;
    
    %Find peak power sum--sum of values within 0.3Hz of peakf
    ipp1=indexF-0.3/fres;
    ipp2=indexF+0.3/fres;
    peakpower(i)=sum(Pnew(ipp1:ipp2));
    totpower(i)=sum(Pnew(i1:i2));
    rat(i)=peakpower(i)/totpower(i);
end

[ratmax indexR]=max(rat);
peakf=fpeak(indexR);
%If any peak power sum is at least 85% of total sum, tremor is valid
%If tremor frequency is between 3.5 and 7.5, tremor is PD
if any(rat>=0.75) && peakf>3.5 && peakf<7.5
    fprintf('Peak Power is %d of total power spectra\n',max(rat))
    fprintf('Tremor detected is valid Parkinsons tremor\n')
else
    fprintf('No Parkinsons, peak power is %d\n', rat)
end

%plot fft
figure
    plot(f, abs(ps(1,:)))
    hold
    plot(f,abs(ps(2,:)))
    plot(f,abs(ps(3,:)))
    legend('X-data', 'Y-data','Z-data')
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
