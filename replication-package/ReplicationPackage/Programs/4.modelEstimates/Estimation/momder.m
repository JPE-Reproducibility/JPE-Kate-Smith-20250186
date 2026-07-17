function G = momder(theta,x,p,IC,IP,IY,w,Z,r,nZC,nRC,nZY,nRY,nZP)
    epsilon = 1e-8;
    G = zeros(length(theta), length(theta));
    for i = 1:length(theta)
        theta1 = theta;
        theta2 = theta;
        theta1(i) = theta1(i) + epsilon;
        theta2(i) = theta2(i) - epsilon;

        [A0,Ai,B0,Bi,C0,Ci,D]=parammap(theta1,r,nZC,nRC,nZY,nRY,nZP);
        [omega,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p(:,1),p(:,2),r);
        m1=(w-omega)'*Z;  %Nxk
        
        [A0,Ai,B0,Bi,C0,Ci,D]=parammap(theta2,r,nZC,nRC,nZY,nRY,nZP);
        [omega,~]=Marshallian(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,p(:,1),p(:,2),r);
        m2=(w-omega)'*Z;  %Nxk
        
        G(:, i) = (m1 - m2) / (2 * epsilon);
    end
    N=length(x);
    G=G/N;
end