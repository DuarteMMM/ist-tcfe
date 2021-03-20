close all
clear all
pkg load symbolic
pkg load miscellaneous 

%%Symbolic Resistances
R1=1040.53890347;
R2=2001.85929606;
R3=3065.93231919;
R4=4151.63583349;
R5=3034.09481751;
R6=2056.54586148;
R7=1005.87575204;

%%Symbolic Variables
Va=5.16821048288;
Id=0.0010127707267;
Kb=0.00729055867767;
Kc=8226.49929708;
%a=1;

%% Mesh method
%%Creating matrix
MM1=[R1+R3+R4,R3,R4];
MM2=[Kb*R3,Kb*R3-1,0];
MM3=[R4,0,R4+R6+R7-Kc];

MM=[MM1;MM2;MM3];

Sol1=[Va;0;0];

Data1=MM\Sol1;

%%Knot method
%%Symbolic

%%Creating matrix
%%Creating matrix
MN1=[-1/R3,0,0,1/R3+1/R1+1/R2,0,-1/R1,-1/R2];
MN2=[0,-1/R6,0,0,1/R6+1/R7,0,0];
MN3=[0,-1,0,0,0,1,0];
MN4=[1,-Kc/R6,0,0,Kc/R6,0,0];
MN5=[-Kb-1/R5,0,1/R5,Kb,0,0,0];
MN6=[Kb,0,0,-1/R2-Kb,0,0,1/R2];
MN7=[1/R4,-1/R4-1/R6,0,1/R1,1/R6,-1/R1,0];

MN=[MN1;MN2;MN3;MN4;MN5;MN6;MN7];

Sol2=[0;0;Va;0;Id;0;0];

Data2=MN\Sol2;

filename="ofile.tex";
fid=fopen(filename,"w");

%%Printing Voltages
fprintf(fid,"V0 & 0 \\\\ \\hline \n");
fprintf(fid,"V1 & %E \\\\ \\hline \n",Data2([1]));
fprintf(fid,"V2 & %E \\\\ \\hline \n",Data2([2]));
fprintf(fid,"V3 & %E \\\\ \\hline \n",Data2([3]));
fprintf(fid,"V4 & %E \\\\ \\hline \n",Data2([4]));
fprintf(fid,"V5 & %E \\\\ \\hline \n",Data2([5]));
fprintf(fid,"V6 & %E \\\\ \\hline \n",Data2([6]));
fprintf(fid,"V7 & %E \\\\ \\hline \n",Data2([7]));
%%Printing Currents
fprintf(fid,"Ia & %E \\\\ \\hline \n",Data1([1]));
fprintf(fid,"Ib & %E \\\\ \\hline \n",Data1([2]));
fprintf(fid,"Ic & %E \\\\ \\hline \n",Data1([3]));
%%Printing Results
Vb=Data2([4])-Data2([1]);
fprintf(fid,"Vb & %E \\\\ \\hline \n",Vb);
fclose (fid);