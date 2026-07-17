function F=Wdiff(Tc,A0,Ai,B0,Bi,C0,Ci,D,xLF,IC,IP,IY,xNS,pNS,pe,pn,r,vr,...
        id,unique_ids,ww,hhw,inc,cap,psi,WSR)

    x=log(exp(xLF)+vr.*Tc);

    [~,EVc]=Classical(A0,Ai,B0,Bi,C0,Ci,D,x,IC,IP,IY,xNS,pNS,pe,pn,r); 

    Lc = zeros(size(unique_ids)); 
    for i = 1:length(unique_ids)
        individual_id = unique_ids(i);
        ww_individual = ww(id == individual_id); 
        Lc(i) = sum(EVc(id == individual_id) .* ww_individual); 
    end

    lossc=(Lc./inc);
    lossc(lossc>cap)=cap;

    Wc=(1/psi).*(exp(psi*lossc)-1);
    F=(1/psi).*log(psi*sum(hhw.*Wc)+1)-WSR;
end