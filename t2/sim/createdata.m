close all
clear all
pkg load symbolic
pkg load miscellaneous 

file1 = fopen("../mat/data.txt","r");
format = "%f";

A = fscanf(file1, format) ;
fclose (file1) ;

fileaws1 = fopen("Data2_data.txt","r");
format = "%f";

B = fscanf(fileaws1, format) ;
fclose (fileaws1) ;

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

file3 = fopen("dataNgspice2.txt","w");
fprintf(file3,"* supply voltage\n\nVs 1 0 0\n\n* Resistances\n\nR1 2 1 %.11fk\nR2 3 2 %.11fk\nR3 2 5 %.11fk\nR4 0 5 %.11fk\nR5 5 6 %.11fk\nR6 7 0aux %.11fk\nR7 8 7 %.11fk\n\n*Linearly dependent sources\n\nGb 6 3 (2,5) %.11fm\nHc 5 8 vaux %.11fk\n\nvaux 0 0aux DC 0\n\n*Capacitor\n\nVx 6 8 %.11f\n\n", A([1]), A([2]), A([3]), A([4]), A([5]), A([6]), A([7]), A([10]), A([11]), B([1])-B([2]));
fclose (file3);

file4 = fopen("dataNgspice3.txt","w");
fprintf(file4,"* supply voltage\n\nVs 1 0 0\n\n* Resistances\n\nR1 2 1 %.11fk\nR2 3 2 %.11fk\nR3 2 5 %.11fk\nR4 0 5 %.11fk\nR5 5 6 %.11fk\nR6 7 0aux %.11fk\nR7 8 7 %.11fk\n\n*Linearly dependent sources\n\nGb 6 3 (2,5) %.11fm\nHc 5 8 vaux %.11fk\n\nvaux 0 0aux DC 0\n\n*Capacitor\n\nc1 6 8 %.11fuF\n\n.ic v(6)=%.11f v(8)=0.0\n\n", A([1]), A([2]), A([3]), A([4]), A([5]), A([6]), A([7]), A([10]), A([11]), A([9]),B([1])-B([2]));
fclose (file4);
