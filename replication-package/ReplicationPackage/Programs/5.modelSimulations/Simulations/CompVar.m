function [CV]=CompVar(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p1,p2,r,y0)

[~,~,CV]=Hicksian(A0,Ai,B0,Bi,C0,Ci,D,y0,IC,IP,IY,p1,p2,r);
CV=exp(CV)-exp(x);