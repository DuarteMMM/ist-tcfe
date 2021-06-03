clear all
w=1;
v=1;
C1=1;
C2=1;
R1=1;
R2=1;
R3=1;
R4=1;


##Calculanting input impedance and Vplus
Vplus=v/(1+R1*j*w*C1);
Zinput=R1+1/(j*w*C1);

##Calculating the final voltage and gain
Vzeta=Vplus*(1+R3/R4);
Vfinal=Vzeta/(1+R2*j*w*C2);
Gain=abs(Vfinal)/abs(v);

##No clue about how to calculate output impedance HELP!!!!!

##Computing gains for the vector of log
f = logspace(1,8,100);
w=2*pi*f;
Vplus=v./(1+R1*j*w.*C1);
Vzeta=Vplus.*(1+R3/R4);
Vfinal=Vzeta./(1+R2*j*w*C2);
Gain=abs(Vfinal)/abs(v);

close all;
