filename='acceldata.xlsx';
acceldatx=xlsread(filename,'F5:F513');
index=1:4:509;
acceldatx=acceldatx(index);
acceldaty=xlsread(filename,'H5:H513');
acceldaty=acceldaty(index);
acceldatz=xlsread(filename,'J5:J513');
acceldatz=acceldatz(index);
acceldatt=xlsread(filename,'AB5:AB513');
acceldatt=acceldatt(index);
matdat=[acceldatt'; acceldatx'; acceldaty'; acceldatz'];
save('Realdata','matdat');
%matdat(1,:) will be time data, matdat(2,:) will be x acceleration data,
%matdat(3,:)=y, matdat(4,:)=z