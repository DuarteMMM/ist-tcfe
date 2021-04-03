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

fclose (fid);

file3 = fopen("../sim/dataNgspice2.txt","w");
fprintf(file3,"Vs 1 0 0\n\n* Resistances\n\nR1 2 1 %.11fk\nR2 3 2 %.11fk\nR3 2 5 %.11fk\nR4 0 5 %.11fk\nR5 5 6 %.11fk\nR6 7 0aux %.11fk\nR7 8 7 %.11fk\n\n*Linearly dependent sources\n\nGb 6 3 (2,5) %.11fm\nHc 5 8 vaux %.11fk\n\nvaux 0 0aux DC 0\n\n", A([1]), A([2]), A([3]), A([4]), A([5]), A([6]), A([7]), A([10]), A([11]));
fclose (file3);


file4 = fopen("../sim/dataNgspice3.txt","w");
fprintf(file4,"* Resistances\n\nR1 2 1 %.11fk\nR2 3 2 %.11fk\nR3 2 5 %.11fk\nR4 0 5 %.11fk\nR5 5 6 %.11fk\nR6 7 0aux %.11fk\nR7 8 7 %.11fk\n\n*Linearly dependent sources\n\nGb 6 3 (2,5) %.11fm\nHc 5 8 vaux %.11fk\n\nvaux 0 0aux DC 0\n\n*Capacitor\n\nc1 6 8 %.11fuF ic=", A([1]), A([2]), A([3]), A([4]), A([5]), A([6]), A([7]), A([10]), A([11]), A([9]));
fclose (file4);
