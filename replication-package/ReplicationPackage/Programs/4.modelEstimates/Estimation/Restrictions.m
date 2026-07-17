function Restrictions(DataFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)

    Mat=fullfile(OutDir,'GMMcoefficients.mat');
    load(Mat,'thetahat');

    est=0;
    [id,t,x,p,IC,IP,IY,~,~,~]=dataprepareestimate(InDir,DataFileName,...
        r,nZC,nRC,nZY,nRY,nZP,est);

    [A0,Ai,B0,Bi,C0,Ci,D]=parammap(thetahat,r,nZC,nRC,nZY,nRY,nZP);

    [w,y]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p(:,1),p(:,2),r);

    [conc]=concavity(w,y,B0,Bi,D,IP);
    [mono]=monotonicity(y,r,p,IY,C0,Ci,D);
    [belas]=budgetelas(w,y,r,p,IY,C0,Ci,D);
    
    OutFile=fullfile(OutDir,'restrictions.raw');

    Data=[id t w conc mono belas];
    save(OutFile,'Data','-ascii','-double','-tabs');

end

function [conc]=concavity(w,y,b0,bi,d,IP)
    conc=w.^2-w+(b0+IP*bi)+d*y;
end

function [mono]=monotonicity(y,r,p,IY,c0,ci,d)
    Y=zeros(length(y),r);
    for f=1:r
        Y(:,f)=f*y.^(f-1);       
    end 

    rp=p(:,1)-p(:,2);
    mono=1+rp.*(Y*c0+IY*ci+0.5*d*rp);
end

function [belas]=budgetelas(w,y,r,p,IY,c0,ci,d)
    Y=zeros(length(y),r);
    for f=1:r
         Y(:,f)=f*y.^(f-1);     
    end    
    
    rp=p(:,1)-p(:,2);
    
    belas=(Y*c0+IY*ci.*Y(:,1))+d*rp;
    belas=(1./w).*belas.*(1./(1-0.5*d*rp.^2+rp.*belas))+1;
end
    
