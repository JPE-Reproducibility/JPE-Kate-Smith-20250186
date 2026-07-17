function EngelCurves(DataFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)

Mat=fullfile(OutDir,'GMMcoefficients.mat');
load(Mat,'thetahat');

est=2;
[id,t,x,p,IC,IP,IY,~,~,~]=dataprepareestimate(InDir,DataFileName,...
     r,nZC,nRC,nZY,nRY,nZP,est);

[A0,Ai,B0,Bi,C0,Ci,D]=parammap(thetahat,r,nZC,nRC,nZY,nRY,nZP);

pe=p(:,1);
pc=p(:,2);

%Demands at observed prices
[w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,pe,pc,r);

HHData=[id t w];

OutFile=fullfile(OutDir,'Engelpredictions.raw');
    
save(OutFile,'HHData','-ascii','-double','-tabs');