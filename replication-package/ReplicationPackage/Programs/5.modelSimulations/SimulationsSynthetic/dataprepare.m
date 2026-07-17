function [id,t,x,p,ZC,R,ZP,ZY,RY,pcf,wgt,T,F,Fcf,v]=dataprepare(Dir,DataFileName,...
    nZC,nRC,nZY,nRY,nZP,cf)
     
p=append(DataFileName,'.raw');
DataFile=fullfile(Dir,p);
population=load(DataFile);    

id=population(:,1);
t=population(:,2);

x=population(:,3);
p=population(:,4:5);

ZC=population(:,6:5+nZC);
ZY=population(:,6:5+nZY);
ZP=population(:,6:5+nZP);

s=5+nZC;
R=population(:,s+1:s+nRC);
RY=population(:,s+1:s+nRY);

s=s+nRC;
pcf=population(:,s+1);
wgt=population(:,s+2)./mean(population(:,s+2));
T=population(:,s+3);
F=population(:,s+4);
Fcf=population(:,s+5);
if cf==0
    v=population(:,s+6);
elseif cf==1
    v=[ones(size(id)) population(:,s+6:end)];
end
