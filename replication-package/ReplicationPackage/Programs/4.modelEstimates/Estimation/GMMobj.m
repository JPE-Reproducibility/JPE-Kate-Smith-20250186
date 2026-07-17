function g=GMMobj(theta,x,p,IC,IP,IY,w,Z,r,nZC,nRC,nZY,nRY,nZP)

[A0,Ai,B0,Bi,C0,Ci,D]=parammap(theta,r,nZC,nRC,nZY,nRY,nZP);

[omega,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p(:,1),p(:,2),r);

m=(w-omega)'*Z;

N=length(w);

W = eye(size(Z, 2));
g = (1/N)*m * W * m';