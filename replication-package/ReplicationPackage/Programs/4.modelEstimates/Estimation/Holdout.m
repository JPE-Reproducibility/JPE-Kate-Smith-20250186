function Holdout(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)

    p=append(CoefFileName,'.mat');
    Mat=fullfile(OutDir,p);
    load(Mat,'thetahat');

    est=0;
    [id,t,x,p,IC,IP,IY,~,~,~]=dataprepareestimate(InDir,DataFileName,...
        r,nZC,nRC,nZY,nRY,nZP,est);

    [A0,Ai,B0,Bi,C0,Ci,D]=parammap(thetahat,r,nZC,nRC,nZY,nRY,nZP);

    [w,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p(:,1),p(:,2),r);

    p=append(OutputFileName,'.raw');
    OutFile=fullfile(OutDir,p);

    Data=[id t w];
    save(OutFile,'Data','-ascii','-double','-tabs');
end
