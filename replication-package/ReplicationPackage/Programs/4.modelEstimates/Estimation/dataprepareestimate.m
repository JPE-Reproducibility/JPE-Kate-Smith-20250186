function [hh,t,x,p,IC,IP,IY,w,Z,pcf]=dataprepareestimate(Dir,DataFileName,...
    r,nZC,nRC,nZY,nRY,nZP,est)
      
p=append(DataFileName,'.raw');
DataFile=fullfile(Dir,p);
population=load(DataFile);    
    
N=length(population);

hh=population(:,1);
t=population(:,2);

x=population(:,3);
p=population(:,4:5);

ZC=population(:,6:5+nZC);
ZY=population(:,6:5+nZY);
IP=population(:,6:5+nZP);

s=5+nZC;
R=population(:,s+1:s+nRC);
RY=population(:,s+1:s+nRY);

IC=[ZC R];     
IY=[ZY RY]; 

if est==0
    w=[];
    Z=[];
    pcf=[];
elseif est==1
    w=population(:,end-1);
    y=population(:,end);

    rp=p(:,1)-p(:,2);
    Y=zeros(N,r);
    for f=1:r
       Y(:,f)=y.^f;       
    end  
    Z=[ones(N,1) IC rp rp.*IP Y y.*IY rp.*y];
    pcf=[];
elseif est==2
    w=[];
    Z=[];
    pcf=population(:,end);
end