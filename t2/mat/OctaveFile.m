close all
clear all
pkg load symbolic
pkg load miscellaneous 

%Read initial data given by t2_datagen.py

filePython = fopen("data.txt","r");
format = "%f";

%Data not in SI units
A = fscanf(filePython, format) ;

fclose (filePython) ;

%Data in SI units
R1=A([1])*1000;
R2=A([2])*1000;
R3=A([3])*1000;
R4=A([4])*1000;
R5=A([5])*1000;
R6=A([6])*1000;
R7=A([7])*1000;
Vs=A([8]);
C=A([9])*0.000001;
Kb=A([10])*0.001;
Kd=A([11])*1000;

%To be used in Exercise 5
Vs_initial_value=Vs;

%Text for Exercise1.net
file1 = fopen("../sim/dataNgspice1.txt","w");
fprintf(file1,"* supply voltage\n\nVs 1 0 %.11f\n\n* Resistances\n\nR1 2 1 %.11fk\nR2 3 2 %.11fk\nR3 2 5 %.11fk\nR4 0 5 %.11fk\nR5 5 6 %.11fk\nR6 7 0aux %.11fk\nR7 8 7 %.11fk\n\n*Linearly dependent sources\n\nGb 6 3 (2,5) %.11fm\nHc 5 8 vaux %.11fk\n\nvaux 0 0aux DC 0\n\n*Capacitor\n\nc1 6 8 %.11fuF\n\n", A([8]), A([1]), A([2]), A([3]), A([4]), A([5]), A([6]), A([7]), A([10]), A([11]), A([9]));
fclose (file1);

%Theoretical: Exercise 1

MN1=[1,0,0,0,0,0,0,0];
MN2=[-1/R1,1/R1+1/R2+1/R3,-1/R2,0,-1/R3,0,0,0];
MN3=[0,-Kb-1/R2,1/R2,0,Kb,0,0,0];
MN4=[0,0,0,1,0,0,0,0];
MN5=[0,-1/R3,0,0,1/R3+1/R4+1/R5,-1/R5,-1/R7,1/R7];
MN6=[0,Kb,0,0,-1/R5-Kb,1/R5,0,0];
MN7=[0,0,0,0,0,0,1/R6+1/R7,-1/R7];
MN8=[0,0,0,0,1,0,Kd/R6,-1];

MN=[MN1;MN2;MN3;MN4;MN5;MN6;MN7;MN8];

Sol=[Vs;0;0;0;0;0;0;0];

Data=MN\Sol;

%Currents
I1=(Data([2])-Data([1]))/R1;
I2=(Data([3])-Data([2]))/R2;
I3=(Data([2])-Data([5]))/R3;
I4=(Data([4])-Data([5]))/R4;
I5=(Data([5])-Data([6]))/R5;
I6=(Data([7])-Data([4]))/R6;
I7=(Data([8])-Data([7]))/R7;

filename="Exercise1.tex";
fid1=fopen(filename,"w");

%%Printing
fprintf(fid1,"$I_1$ & %.10E \\\\ \\hline \n",I1);
fprintf(fid1,"$I_2$ & %.10E \\\\ \\hline \n",I2);
fprintf(fid1,"$I_3$ & %.10E \\\\ \\hline \n",I3);
fprintf(fid1,"$I_4$ & %.10E \\\\ \\hline \n",I4);
fprintf(fid1,"$I_5$ & %.10E \\\\ \\hline \n",I5);
fprintf(fid1,"$I_6$ & %.10E \\\\ \\hline \n",I6);
fprintf(fid1,"$I_7$ & %.10E \\\\ \\hline \n",I7);
fprintf(fid1,"$I_b$ & %.10E \\\\ \\hline \n",I2);
fprintf(fid1,"$I_c$ & %.10E \\\\ \\hline \n",I5-I2);
fprintf(fid1,"$I_{V_s}$ & %.10E \\\\ \\hline \n",I1);
fprintf(fid1,"$I_{V_d}$ & %.10E \\\\ \\hline \n",I4+I3-I5);

fprintf(fid1,"$V_1$ & %.10E \\\\ \\hline \n",Data([1]));
fprintf(fid1,"$V_2$ & %.10E \\\\ \\hline \n",Data([2]));
fprintf(fid1,"$V_3$ & %.10E \\\\ \\hline \n",Data([3]));
%fprintf(fid1,"$V_4$ & %.10E \\\\ \\hline \n",Data([4]));
fprintf(fid1,"$V_5$ & %.10E \\\\ \\hline \n",Data([5]));
fprintf(fid1,"$V_6$ & %.10E \\\\ \\hline \n",Data([6]));
fprintf(fid1,"$V_7$ & %.10E \\\\ \\hline \n",Data([7]));
fprintf(fid1,"$V_8$ & %.10E \\\\ \\hline \n",Data([8]));

fclose (fid1);

%To be used in Exercise 5
V6_initial_value=Data([6]);

%Text for Exercise2.net
file2 = fopen("../sim/dataNgspice2.txt","w");
fprintf(file2,"Vs 1 0 0\n\n* Resistances\n\nR1 2 1 %.11fk\nR2 3 2 %.11fk\nR3 2 5 %.11fk\nR4 0 5 %.11fk\nR5 5 6 %.11fk\nR6 7 0aux %.11fk\nR7 8 7 %.11fk\n\n*Linearly dependent sources\n\nGb 6 3 (2,5) %.11fm\nHc 5 8 vaux %.11fk\n\nvaux 0 0aux DC 0\n\n", A([1]), A([2]), A([3]), A([4]), A([5]), A([6]), A([7]), A([10]), A([11]));
fclose (file2);

%Text for Exercise3.net and Exercises4_5.net
file3 = fopen("../sim/dataNgspice3.txt","w");
fprintf(file3,"* Resistances\n\nR1 2 1 %.11fk\nR2 3 2 %.11fk\nR3 2 5 %.11fk\nR4 0 5 %.11fk\nR5 5 6 %.11fk\nR6 7 0aux %.11fk\nR7 8 7 %.11fk\n\n*Linearly dependent sources\n\nGb 6 3 (2,5) %.11fm\nHc 5 8 vaux %.11fk\n\nvaux 0 0aux DC 0\n\n*Capacitor\n\nc1 6 8 %.11fuF\n\n.ic", A([1]), A([2]), A([3]), A([4]), A([5]), A([6]), A([7]), A([10]), A([11]), A([9]));
fclose (file3);

%Theoretical: Exercise 2

%Voltage through capacitor
Vx=Data([6])-Data([8]);

MN1=[1,0,0,-1,0,0,0,0];
MN2=[-1/R1,1/R1+1/R2+1/R3,-1/R2,0,-1/R3,0,0,0];
MN3=[0,-Kb-1/R2,1/R2,0,Kb,0,0,0];
MN4=[0,0,0,1,0,0,0,0];
MN5=[0,Kb-1/R3,0,0,1/R3+1/R4-Kb,0,-1/R7,1/R7];
MN6=[0,0,0,0,0,1,0,-1];
MN7=[0,0,0,0,0,0,1/R6+1/R7,-1/R7];
MN8=[0,0,0,0,1,0,-Kd/R6,-1];

MN=[MN1;MN2;MN3;MN4;MN5;MN6;MN7;MN8];

Sol=[0;0;0;0;0;Vx;0;0];

Data=MN\Sol;

%Currents
I1=(Data([2])-Data([1]))/R1;
I2=(Data([3])-Data([2]))/R2;
I3=(Data([2])-Data([5]))/R3;
I4=(Data([4])-Data([5]))/R4;
I5=(Data([5])-Data([6]))/R5;
I6=(Data([7])-Data([4]))/R6;
I7=(Data([8])-Data([7]))/R7;

filename="Exercise2.tex";
fid2=fopen(filename,"w");

fprintf(fid2,"$I_1$ & %.10E \\\\ \\hline \n",I1);
fprintf(fid2,"$I_2$ & %.10E \\\\ \\hline \n",I2);
fprintf(fid2,"$I_3$ & %.10E \\\\ \\hline \n",I3);
fprintf(fid2,"$I_4$ & %.10E \\\\ \\hline \n",I4);
fprintf(fid2,"$I_5$ & %.10E \\\\ \\hline \n",I5);
fprintf(fid2,"$I_6$ & %.10E \\\\ \\hline \n",I6);
fprintf(fid2,"$I_7$ & %.10E \\\\ \\hline \n",I7);
fprintf(fid2,"$I_b$ & %.10E \\\\ \\hline \n",I2);
fprintf(fid2,"$I_{V_x}$ & %.10E \\\\ \\hline \n",I5-I2);
fprintf(fid2,"$I_{V_s}$ & %.10E \\\\ \\hline \n",I1);
fprintf(fid2,"$I_{V_d}$ & %.10E \\\\ \\hline \n",I4+I3-I5);

fprintf(fid2,"$V_1$ & %.10E \\\\ \\hline \n",Data([1]));
fprintf(fid2,"$V_2$ & %.10E \\\\ \\hline \n",Data([2]));
fprintf(fid2,"$V_3$ & %.10E \\\\ \\hline \n",Data([3]));
%fprintf(fid2,"$V_4$ & %.10E \\\\ \\hline \n",Data([4]));
fprintf(fid2,"$V_5$ & %.10E \\\\ \\hline \n",Data([5]));
fprintf(fid2,"$V_6$ & %.10E \\\\ \\hline \n",Data([6]));
fprintf(fid2,"$V_7$ & %.10E \\\\ \\hline \n",Data([7]));
fprintf(fid2,"$V_8$ & %.10E \\\\ \\hline \n",Data([8]));

fclose (fid2);

%Value to be used in Exercise 5
V6middle=Data([6]);

%Values used to calculate the equivalent resistance
filename="Exercise2_1.tex";
fid21=fopen(filename,"w");

fprintf(fid21,"$V_x$ & %.10E \\\\ \\hline \n",Vx);
fprintf(fid21,"$I_x$ & %.10E \\\\ \\hline \n",I2-I5);
fprintf(fid21,"$R_{eq}$ & %.10E \\\\ \\hline \n",Vx/(I2-I5));
fprintf(fid21,"$\\tau$ & %.10E \\\\ \\hline \n", (Vx*C)/(I2-I5)); 

fclose (fid21);

%Theoretical: Exercise 3

%Equivalent resistance
Req=Vx/(I2-I5);
%Initial condition
Vxn=Data([6]);

t=0:2e-5:20e-3;
vn=Vxn*exp(-t/(Req*C));

hf = figure ("Visible", "off");
plot (t*1000, vn, "r");
hold on;

xlabel ("t [ms]");
ylabel ("v_{6n} [V]");
txt = "v_{6n}(t) = v_{6n}(0) exp[-t/(RC)]";
text(7.5,Vxn,txt,"FontSize",14)
print (hf, "natural.eps", "-depsc");


%Theoretical: Exercise 4

%Frequency and voltage source phasor
f=1000;
Vs=1;

M1=[1,0,0,0,0,0,0,0];
M2=[-1/R1,1/R1+1/R2+1/R3,-1/R2,0,-1/R3,0,0,0];
M3=[0,-1/R2-Kb,1/R2,0,Kb,0,0,0];
M4=[0,0,0,1,0,0,0,0];
M5=[0,-1/R3,0,0,1/R3+1/R4+1/R5,-1/R5-j*2*pi*f*C,-1/R7,1/R7+j*2*pi*f*C];
M6=[0,Kb,0,0,-1/R5-Kb,1/R5+j*2*pi*f*C,0,-j*2*pi*f*C];
M7=[0,0,0,0,0,0,1/R6+1/R7,-1/R7];
M8=[0,0,0,0,1,0,Kd/R6,-1];

M=[M1;M2;M3;M4;M5;M6;M7;M8];

Sol=[Vs;0;0;0;0;0;0;0];

Data=M\Sol;

%Currents
I1=(Data([2])-Data([1]))/R1;
I2=(Data([3])-Data([2]))/R2;
I3=(Data([2])-Data([5]))/R3;
I4=(Data([4])-Data([5]))/R4;
I5=(Data([5])-Data([6]))/R5;
I6=(Data([7])-Data([4]))/R6;
I7=(Data([8])-Data([7]))/R7;

filename="Exercise4.tex";
fid4=fopen(filename,"w");

%fprintf(fid4,"$I_1$ & %.10E \\\\ \\hline \n",I1);
%fprintf(fid4,"$I_2$ & %.10E \\\\ \\hline \n",I2);
%fprintf(fid4,"$I_3$ & %.10E \\\\ \\hline \n",I3);
%fprintf(fid4,"$I_4$ & %.10E \\\\ \\hline \n",I4);
%fprintf(fid4,"$I_5$ & %.10E \\\\ \\hline \n",I5);
%fprintf(fid4,"$I_6$ & %.10E \\\\ \\hline \n",I6);
%fprintf(fid4,"$I_7$ & %.10E \\\\ \\hline \n",I7);
%fprintf(fid4,"$I_b$ & %.10E \\\\ \\hline \n",I2);
%fprintf(fid4,"$I_x$ & %.10E \\\\ \\hline \n",I5-I2);
%fprintf(fid4,"$I_{V_s}$ & %.10E \\\\ \\hline \n",I1);
%fprintf(fid4,"$I_{V_d}$ & %.10E \\\\ \\hline \n",I4+I3-I5);

fprintf(fid4,"$V_1$ & %.10E + (%.10E) i \\\\ \\hline \n",real(Data([1])),imag(Data([1])));
fprintf(fid4,"$V_2$ & %.10E + (%.10E) i \\\\ \\hline \n",real(Data([2])),imag(Data([2])));
fprintf(fid4,"$V_3$ & %.10E + (%.10E) i \\\\ \\hline \n",real(Data([3])),imag(Data([3])));
fprintf(fid4,"$V_4$ & %.10E + (%.10E) i \\\\ \\hline \n",real(Data([4])),imag(Data([4])));
fprintf(fid4,"$V_5$ & %.10E + (%.10E) i \\\\ \\hline \n",real(Data([5])),imag(Data([5])));
fprintf(fid4,"$V_6$ & %.10E + (%.10E) i \\\\ \\hline \n",real(Data([6])),imag(Data([6])));
fprintf(fid4,"$V_7$ & %.10E + (%.10E) i \\\\ \\hline \n",real(Data([7])),imag(Data([7])));
fprintf(fid4,"$V_8$ & %.10E + (%.10E) i \\\\ \\hline \n",real(Data([8])),imag(Data([8])));

fclose (fid4);

%Plot the forced solution in time interval [0,20] ms

Amplitude_v6 = abs(Data([6]));
Phase_v6 = angle(Data([6]));

  
%t1=0:2e-5:20e-3;
vf=Amplitude_v6*sin(2*pi*f*t+Phase_v6);

hf1 = figure ("Visible", "off");
plot (t*1000, vf, "");
hold on;

xlabel ("t [ms]");
ylabel ("v_{6f} [V]");
txt = "v_{6f}(t) = V_{6}sin(\\omega t - \\phi)";
text(7,Amplitude_v6+0.1,txt,"FontSize",14)
print (hf1, "forced.eps", "-depsc");


%Theoretical: Exercise 5

%Final solution for v6
%vt=vn+Data([6])*sin(2*pi*f*t-pi\2);
vt = vn+vf;

%Voltage source for t>0
vs = sin(2*pi*f*t);

%Time for t<=0
t3=-5e-3:2e-5:0;
vs_initial=Vs_initial_value*t3./t3;
v6_initial=V6_initial_value*t3./t3;

hf2 = figure ("Visible", "off");
plot (t3*1000, v6_initial, "r", t*1000, vt, "r");
hold on;
plot (t3*1000, vs_initial, "b", t*1000, vs, "b");
hold on;
plot(0,V6middle,".r");

%Draw dashed line in t=0
y = ylim;
plot([0,0],[y(1)+0.1,y(2)-0.1],"--k");

xlabel ("t [ms]");
ylabel ("v_s, v_6 [V]");
hleg=legend("v_s (t)","v_6 (t)");
chleg=get(hleg,"children");
set(chleg(1),"color","r");
set(chleg(2),"color","b");
print (hf2, "final.eps", "-depsc");


%Theoretical: Exercise 6

%Frequencies
%f=logspace(-1, 6, 7*5);
f=logspace(log10(0.1),log10(1000000),35);

%Voltage and phase in source
Vs=f.*0;
fases=f.*0;

%Voltage and phase in capacitor

%Vl=sqrt(1+4*pi*pi*Req*Req*C*C*f.^2);
%Vl=Vl.^(-1);
%VC=20*log10(Vl);

faseC=-atan(2*pi*f*Req*C)/pi*180;

%Voltage and phase in V6 (solved before, in order to get an expression)
fz=f./f;
V666=(-j*Kd*R4+j*Kb*Kd*R3*R4+j*Kb*Kd*R3*R5-j*Kb*R3*R4*R5+j*R4*R6-
      j*Kb*R3*R4*R6-j*Kb*R3*R5*R6-2*C*f.*pi*R4*R5*R6+ 
     2*C*f*Kb*pi*R3*R4*R5*R6+j*R4*R7-j*Kb*R3*R4*R7-j*Kb*R3*R5*R7-2*C*f.*pi*R4*R5*R7+ 
     2*C*f.*Kb*pi*R3*R4*R5*R7)./((-j+2*C*f.*pi*R5)*(Kd*R1+
      Kd*R3-Kb*Kd*R1*R3+Kd*R4-R1*R4-R3*R4-Kb*Kd*R3*R4+ 
     Kb*R1*R3*R4-R1*R6-R3*R6+Kb*R1*R3*R6-R4*R6+Kb*R3*R4*R6-
      R1*R7-R3*R7+Kb*R1*R3*R7-R4*R7+Kb*R3*R4*R7));  
VM=abs(V666);  
V6M=20*log10(VM);
fase6=angle(V666)/pi*180;

%Voltage and phase in capacitor
%Voltage in 8
V8=((-1+Kb*R3)*R4*(R6+R7))/(
Kd*R1+Kd*R3-Kb*Kd*R1*R3+Kd*R4-R1*R4-R3*R4-Kb*Kd*R3*R4+ 
 Kb*R1*R3*R4-R1*R6-R3*R6+Kb*R1*R3*R6-R4*R6+Kb*R3*R4*R6- 
 R1*R7-R3*R7+Kb*R1*R3*R7-R4*R7+Kb*R3*R4*R7);
Vl=V666.-V8;
Vlz=abs(Vl);
VC=20*log10(Vlz);

faseC=angle(Vl)/pi*180;

 
%Magnitude plots
hf3 = figure ("Visible", "off");
semilogx (f, Vs, "");
hold on;
semilogx (f,V6M, "");
hold on;
semilogx (f,VC, "");

%xlim([0.1 1000000]);
xlabel ("f [HZ]");
ylabel ("V_s, V_6, V_c [dB]");
hleg1=legend("V_s","V_6","V_c","Location","southwest");
set(hleg1, "FontSize", 14);
print (hf3, "dBoct.eps", "-depsc");


%Phase plots
hf4 = figure ("Visible", "off");
semilogx (f, fases, "");
hold on;
semilogx (f,fase6, "");
hold on;
semilogx (f,faseC, "");

hleg2=legend("\\phi_{v_s}","\\phi_{v_6}","\\phi_{v_c}","Location","southwest");
set(hleg2, "FontSize", 14);
%xlim([0.1 1000000]);
xlabel ("f [HZ]");
ylabel ("\\phi_{v_s}, \\phi_{v_6}, \\phi_{v_c} [Degrees]");
print (hf4, "phaseoct.eps", "-depsc");

close all;
