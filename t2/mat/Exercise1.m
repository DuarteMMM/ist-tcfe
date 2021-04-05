close all
clear all
pkg load symbolic
pkg load miscellaneous 

file1 = fopen("data.txt","r");
format = "%f";

A = fscanf(file1, format) ;
fclose (file1) ;

%Data
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

vssave=Vs;

file2 = fopen("../sim/dataNgspice1.txt","w");
fprintf(file2,"* supply voltage\n\nVs 1 0 %.11f\n\n* Resistances\n\nR1 2 1 %.11fk\nR2 3 2 %.11fk\nR3 2 5 %.11fk\nR4 0 5 %.11fk\nR5 5 6 %.11fk\nR6 7 0aux %.11fk\nR7 8 7 %.11fk\n\n*Linearly dependent sources\n\nGb 6 3 (2,5) %.11fm\nHc 5 8 vaux %.11fk\n\nvaux 0 0aux DC 0\n\n*Capacitor\n\nc1 6 8 %.11fuF\n\n", A([8]), A([1]), A([2]), A([3]), A([4]), A([5]), A([6]), A([7]), A([10]), A([11]), A([9]));
fclose (file2);

%%Knot method
%%Creating matrix

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
fid=fopen(filename,"w");

%%Printing
fprintf(fid,"$I_1$ & %.8E \\\\ \\hline \n",I1);
fprintf(fid,"$I_2$ & %.8E \\\\ \\hline \n",I2);
fprintf(fid,"$I_3$ & %.8E \\\\ \\hline \n",I3);
fprintf(fid,"$I_4$ & %.8E \\\\ \\hline \n",I4);
fprintf(fid,"$I_5$ & %.8E \\\\ \\hline \n",I5);
fprintf(fid,"$I_6$ & %.8E \\\\ \\hline \n",I6);
fprintf(fid,"$I_7$ & %.8E \\\\ \\hline \n",I7);
fprintf(fid,"$I_b$ & %.8E \\\\ \\hline \n",I2);
fprintf(fid,"$I_c$ & %.8E \\\\ \\hline \n",I5-I2);
fprintf(fid,"$I_{V_s}$ & %.8E \\\\ \\hline \n",I1);
fprintf(fid,"$I_{V_d}$ & %.8E \\\\ \\hline \n",I4+I3-I5);

fprintf(fid,"$V_1$ & %.8E \\\\ \\hline \n",Data([1]));
fprintf(fid,"$V_2$ & %.8E \\\\ \\hline \n",Data([2]));
fprintf(fid,"$V_3$ & %.8E \\\\ \\hline \n",Data([3]));
%fprintf(fid,"$V_4$ & %.8E \\\\ \\hline \n",Data([4]));
fprintf(fid,"$V_5$ & %.8E \\\\ \\hline \n",Data([5]));
fprintf(fid,"$V_6$ & %.8E \\\\ \\hline \n",Data([6]));
fprintf(fid,"$V_7$ & %.8E \\\\ \\hline \n",Data([7]));
fprintf(fid,"$V_8$ & %.8E \\\\ \\hline \n",Data([8]));
vtsave=Data([6]);
fclose (fid);

file3 = fopen("../sim/dataNgspice2.txt","w");
fprintf(file3,"Vs 1 0 0\n\n* Resistances\n\nR1 2 1 %.11fk\nR2 3 2 %.11fk\nR3 2 5 %.11fk\nR4 0 5 %.11fk\nR5 5 6 %.11fk\nR6 7 0aux %.11fk\nR7 8 7 %.11fk\n\n*Linearly dependent sources\n\nGb 6 3 (2,5) %.11fm\nHc 5 8 vaux %.11fk\n\nvaux 0 0aux DC 0\n\n", A([1]), A([2]), A([3]), A([4]), A([5]), A([6]), A([7]), A([10]), A([11]));
fclose (file3);


file4 = fopen("../sim/dataNgspice3.txt","w");
fprintf(file4,"* Resistances\n\nR1 2 1 %.11fk\nR2 3 2 %.11fk\nR3 2 5 %.11fk\nR4 0 5 %.11fk\nR5 5 6 %.11fk\nR6 7 0aux %.11fk\nR7 8 7 %.11fk\n\n*Linearly dependent sources\n\nGb 6 3 (2,5) %.11fm\nHc 5 8 vaux %.11fk\n\nvaux 0 0aux DC 0\n\n*Capacitor\n\nc1 6 8 %.11fuF\n\n.ic", A([1]), A([2]), A([3]), A([4]), A([5]), A([6]), A([7]), A([10]), A([11]), A([9]));
fclose (file4);

%Exercise2
%Defining matriix

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

%%Printing
fprintf(fid2,"$I_1$ & %.8E \\\\ \\hline \n",I1);
fprintf(fid2,"$I_2$ & %.8E \\\\ \\hline \n",I2);
fprintf(fid2,"$I_3$ & %.8E \\\\ \\hline \n",I3);
fprintf(fid2,"$I_4$ & %.8E \\\\ \\hline \n",I4);
fprintf(fid2,"$I_5$ & %.8E \\\\ \\hline \n",I5);
fprintf(fid2,"$I_6$ & %.8E \\\\ \\hline \n",I6);
fprintf(fid2,"$I_7$ & %.8E \\\\ \\hline \n",I7);
fprintf(fid2,"$I_b$ & %.8E \\\\ \\hline \n",I2);
fprintf(fid2,"$I_x$ & %.8E \\\\ \\hline \n",I5-I2);
fprintf(fid2,"$I_{V_s}$ & %.8E \\\\ \\hline \n",I1);
fprintf(fid2,"$I_{V_d}$ & %.8E \\\\ \\hline \n",I4+I3-I5);

fprintf(fid2,"$V_1$ & %.8E \\\\ \\hline \n",Data([1]));
fprintf(fid2,"$V_2$ & %.8E \\\\ \\hline \n",Data([2]));
fprintf(fid2,"$V_3$ & %.8E \\\\ \\hline \n",Data([3]));
%fprintf(fid,"$V_4$ & %.8E \\\\ \\hline \n",Data([4]));
fprintf(fid2,"$V_5$ & %.8E \\\\ \\hline \n",Data([5]));
fprintf(fid2,"$V_6$ & %.8E \\\\ \\hline \n",Data([6]));
fprintf(fid2,"$V_7$ & %.8E \\\\ \\hline \n",Data([7]));
fprintf(fid2,"$V_8$ & %.8E \\\\ \\hline \n",Data([8]));

fclose (fid2);

filename="Exercise2.1.tex";
fid21=fopen(filename,"w");

%%Printing
fprintf(fid21,"$I_b$ & %.8E \\\\ \\hline \n",I2);
fprintf(fid21,"$I_5$ & %.8E \\\\ \\hline \n",I5);
fprintf(fid21,"$I_x$ & %.8E \\\\ \\hline \n",I5-I2);
fprintf(fid21,"$R_{eq}$ & %.8E \\\\ \\hline \n",-Vx/(I5-I2));

fclose (fid21);


%Exercise3
Req=-Vx/(I5-I2);
A=Data([6]);
t=0:2e-5:20e-3;
vn=A*exp(-t/(Req*C));

hf = figure ("Visible", "off");
plot (t*1000, vn, "");
hold on;

xlabel ("t[ms]");
ylabel ("vn(t) [V]");
print (hf, "natural.eps", "-depsc");


%Exercise4

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

%%Printing
%fprintf(fid4,"$I_1$ & %.8E \\\\ \\hline \n",I1);
%fprintf(fid4,"$I_2$ & %.8E \\\\ \\hline \n",I2);
%fprintf(fid4,"$I_3$ & %.8E \\\\ \\hline \n",I3);
%fprintf(fid4,"$I_4$ & %.8E \\\\ \\hline \n",I4);
%fprintf(fid4,"$I_5$ & %.8E \\\\ \\hline \n",I5);
%fprintf(fid4,"$I_6$ & %.8E \\\\ \\hline \n",I6);
%fprintf(fid4,"$I_7$ & %.8E \\\\ \\hline \n",I7);
%fprintf(fid4,"$I_b$ & %.8E \\\\ \\hline \n",I2);
%fprintf(fid4,"$I_x$ & %.8E \\\\ \\hline \n",I5-I2);
%fprintf(fid4,"$I_{V_s}$ & %.8E \\\\ \\hline \n",I1);
%fprintf(fid4,"$I_{V_d}$ & %.8E \\\\ \\hline \n",I4+I3-I5);


fprintf(fid4,"$V_1$ & %.8E+%.8Ei \\\\ \\hline \n",real(Data([1])),imag(Data([1])));
fprintf(fid4,"$V_2$ & %.8E%.8Ei \\\\ \\hline \n",real(Data([2])),imag(Data([2])));
fprintf(fid4,"$V_3$ & %.8E%.8Ei \\\\ \\hline \n",real(Data([3])),imag(Data([3])));
fprintf(fid4,"$V_4$ & %.8E+%.8Ei \\\\ \\hline \n",real(Data([4])),imag(Data([4])));
fprintf(fid4,"$V_5$ & %.8E%.8Ei \\\\ \\hline \n",real(Data([5])),imag(Data([5])));
fprintf(fid4,"$V_6$ & %.8E%.8Ei \\\\ \\hline \n",real(Data([6])),imag(Data([6])));
fprintf(fid4,"$V_7$ & %.8E+%.8Ei \\\\ \\hline \n",real(Data([7])),imag(Data([7])));
fprintf(fid4,"$V_8$ & %.8E+%.8Ei \\\\ \\hline \n",real(Data([8])),imag(Data([8])));

fclose (fid4);


%Exercise5
%[0;20]ms
vt=vn+Data([6])*sin(2*pi*f*t-pi\2);
vs=sin(2*pi*f*t);
hf2 = figure ("Visible", "off");
plot (t*1000, vt, "");
hold on;
plot (t*1000,vs, "");

xlabel ("t[ms]");
ylabel ("vs(t),v6(t) [V]");
print (hf2, "finaloct.eps", "-depsc");

f=-5.1:1:-0.1;
vsr=vssave*f./f;
vtr=vtsave*f./f;

hf20 = figure ("Visible", "off");
plot (f, vsr, "");
hold on;
plot (f,vtr, "");

xlabel ("t[ms]");
ylabel ("vs(t),v6(t) [V]");
print (hf20, "finaloct2.eps", "-depsc");

%Exercise6
%In order to get he voltage in 6 is easier to solve as symbolic
%in order to f, but as it is very difficult to convert symbolic to a function
%we solved the expression before and simply applied it

%Frequency
f=logspace(-1, 6, 7*5);

%Voltage and phase in source
Vs=f.*0;
fases=f.*0;

%Voltage and phase in capacitor
Vl=sqrt(1+4*pi*pi*Req*Req*C*C*f.^2);
Vl=Vl.^(-1);
VC=20*log10(Vl);
faseC=-atan(2*pi*f*Req*C)/pi*180;

%Voltage and phase in V6 (solved before to get expression)
f=logspace(-1, 6, 7*5);
fz=f./f;
V666=(-j*Kd*R4+j*Kb*Kd*R3*R4+j*Kb*Kd*R3*R5-j*Kb*R3*R4*R5+j*R4*R6-
      j*Kb*R3*R4*R6-j*Kb*R3*R5*R6-2*C*f.*pi*R4*R5*R6+ 
     2*C*f*Kb*pi*R3*R4*R5*R6+j*R4*R7-j*Kb*R3*R4*R7-j*Kb*R3*R5*R7-2*C*f.*pi*R4*R5*R7+ 
     2*C*f.*Kb*pi*R3*R4*R5*R7)./((-j+2*C*f.*pi*R5)*(Kd*R1+
      Kd*R3-Kb*Kd*R1*R3+Kd*R4-R1*R4-R3*R4-Kb*Kd*R3*R4+ 
     Kb*R1*R3*R4-R1*R6-R3*R6+Kb*R1*R3*R6-R4*R6+Kb*R3*R4*R6-
      R1*R7-R3*R7+Kb*R1*R3*R7-R4*R7+Kb*R3*R4*R7))  
VM=abs(V666);  
V6M=20*log10(VM);
fase6=angle(V666)/pi*180

 
%Magnitude
hf3 = figure ("Visible", "off");
semilogx (f*36, Vs, "");
hold on;
semilogx (f*36,VC, "");
hold on;
semilogx (f*36,V6M, "");

xlabel ("f[HZ]");
ylabel ("Vs,Vc,V6 [dB]");
print (hf3, "dBoct.eps", "-depsc");


%phase
hf4 = figure ("Visible", "off");
semilogx (f*36, fases, "");
hold on;
semilogx (f*36,faseC, "");
hold on;
semilogx (f*36,fase6, "");


xlabel ("f[HZ]");
ylabel ("Vs,Vc [Degrees]");
print (hf4, "phaseoct.eps", "-depsc");