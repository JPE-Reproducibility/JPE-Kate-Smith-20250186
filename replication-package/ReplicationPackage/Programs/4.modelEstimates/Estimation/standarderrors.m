function [Vr,se]=standarderrors(theta,hh,x,p,IC,IP,IY,w,Z,r,nZC,nRC,nZY,nRY,nZP)

[A0,Ai,B0,Bi,C0,Ci,D]=parammap(theta,r,nZC,nRC,nZY,nRY,nZP);

[omega,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p(:,1),p(:,2),r);

N=length(x);
m=Z.*(w-omega);    %Nxk

[ii,jj]=ndgrid(hh, 1:size(m, 2 )) ;
iijj=[ii(:), jj(:)] ;
im=accumarray( iijj, m(:) ) ;
avm=sum(im.*(1/N),1);

V=(1/N)*(im'*im)-avm'*avm;

%W=eye(size(Z, 2));
G=momder(theta,x,p,IC,IP,IY,w,Z,r,nZC,nRC,nZY,nRY,nZP);

% Sand=(G'/W)*G;
% Sand=(Sand\G')/W;
% Sand=inv(G);
% Vr=(1/N)*Sand*V*Sand';

Vr=(1/N)*(G\V/G');

se=sqrt(diag(Vr));


