function [A0,Ai,B0,Bi,C0,Ci,D]=parammap(theta,r,nZC,nRC,nZY,nRY,nZP)

A0=theta(1);
Ai=theta(2:nZC+nRC+1);
s=1+nZC+nRC;
C0=theta(s+1:s+r);
s=s+r;
Ci=theta(s+1:s+nZY+nRY);
s=s+nZY+nRY;
B0=theta(s+1);
s=s+1;
Bi=theta(s+1:s+nZP);
s=s+nZP;
D=theta(s+1);