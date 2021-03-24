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
MN1=[1,-Kc/R6,0,0,Kc/R6,0,0];
MN2=[1/R4,-1/R4-1/R6,0,1/R1,1/R6,-1/R1,0];
MN3=[-Kb-1/R5,0,1/R5,Kb,0,0,0];
MN4=[-1/R3,0,0,1/R3+1/R1+1/R2,0,-1/R1,-1/R2];
MN5=[0,-1/R6,0,0,1/R6+1/R7,0,0];
MN6=[0,-1,0,0,0,1,0];
MN7=[Kb,0,0,-1/R2-Kb,0,0,1/R2];

MN=[MN1;MN2;MN3;MN4;MN5;MN6;MN7];

Sol2=[0;0;Id;0;0;Va;0];

Data2=MN\Sol2;

filename="ofile.tex";
fid=fopen(filename,"w");

%%Printing Currents
fprintf(fid,"$I_a$=$I_1$ & %E \\\\ \\hline \n",Data1([1]));
fprintf(fid,"$I_b$=$I_2$ & %E \\\\ \\hline \n",Data1([2]));
fprintf(fid,"$I_c$=$I_6$=$I_7$ & %E \\\\ \\hline \n",Data1([3]));
%%Printing Results
I3=Data1([1])+Data1([2]);
fprintf(fid,"$I_3$=$I_a$+$I_b$ & %E \\\\ \\hline \n",I3);
I4=Data1([1])+Data1([3]);
fprintf(fid,"$I_4$=$I_a$+$I_c$ & %E \\\\ \\hline \n",I4);
I5=Id-Data1([2]);
fprintf(fid,"$I_5$=$I_d$-$I_b$ & %E \\\\ \\hline \n",I5);

%%Printing Voltages
%fprintf(fid,"$V_0$ & 0 \\\\ \\hline \n");
fprintf(fid,"$V_1$=$V_c$ & %E \\\\ \\hline \n",Data2([1]));
fprintf(fid,"$V_2$ & %E \\\\ \\hline \n",Data2([2]));
fprintf(fid,"$V_3$ & %E \\\\ \\hline \n",Data2([3]));
fprintf(fid,"$V_4$ & %E \\\\ \\hline \n",Data2([4]));
fprintf(fid,"$V_5$ & %E \\\\ \\hline \n",Data2([5]));
fprintf(fid,"$V_6$ & %E \\\\ \\hline \n",Data2([6]));
fprintf(fid,"$V_7$ & %E \\\\ \\hline \n",Data2([7]));

%%Printing Results
Vb=Data2([4])-Data2([1]);
fprintf(fid,"$V_b$=$V_4$-$V_1$ & %E \\\\ \\hline \n",Vb);

fclose (fid);
