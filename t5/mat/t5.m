close all
clear all

%Used values for resistances and capacitances
C1=220e-9;
C2=220e-9;
C2s=220e-9;
R1=1.e+3;
R2=1.e+3;
%R2p=infinity;
R3=100.e+3;
R4=10.e+3;
R4p=1.e+3;

%Write values in a file
file_chosen_values = fopen("ChosenValues.tex","w");
fprintf(file_chosen_values, "$C_1$ & %.0f\\\\ \\hline\n$C_2$ & %.0f\\\\ \\hline\n$C_{2s}$ & %.0f\\\\ \\hline\n$R_1$ & %.0f\\\\ \\hline\n$R_2$ & %.0f\\\\ \\hline\n$R_{2p}$ & $\\infty$ \\\\ \\hline\n$R_3$ & %.0f\\\\ \\hline\n$R_4$ & %.0f\\\\ \\hline\n$R_{4p}$ & %.0f\\\\ \\hline", C1/(1.e-9), C2/(1.e-9), C2s/(1.e-9), R1/1000, R2/1000, R3/1000, R4/1000, R4p/1000);
fclose (file_chosen_values);

%Compute equivalent R4 and C2 (R2p=infinity, thus it is not necessary)
C2=(C2*C2s)/(C2+C2s);
R4=(R4*R4p)/(R4+R4p);

%Write equivalent resistance and capacitance in a file
file_equivalent_values = fopen("EquivalentValues.tex","w");
fprintf(file_equivalent_values, "$C_{2,eq}$ & %.0f\\\\ \\hline\n$R_{4,eq}$ & %.6e\\\\ \\hline", C2/(1.e-9), R4/1000);
fclose (file_equivalent_values);

%Computing gains for the vector of log with 10 points per decade (7 decades, thus 70 points)
f=logspace(1,8,70);
w=2*pi*f;
teta=((R1*C1*j*w)*(1+R3/R4))./((1+R1*C1*j*w).*(1+R2*C2*j*w));
Gain=20*log10(abs(teta));
Phase=angle(teta)/pi*180;

%Lower and higher cut-off and central frequencies and gain at the central frequency
wL=1/(R1*C1);
fL=wL/(2*pi);
wH=1/(R2*C2);
fH=wH/(2*pi);
wO=sqrt(wL*wH);
fO=wO/(2*pi);
zeta=((R1*C1*j*wO)*(1+R3/R4))/((1+R1*C1*j*wO)*(1+R2*C2*j*wO));
GainFinal=20*log10(abs(zeta));

%Input and output impedances at the calculated central frequency
Zinput=R1+1/(j*wO*C1);
Zoutput=1/(1/R2+j*wO*C2);
  
%Write final values in file
file_final = fopen("FinalValues.tex","w");
fprintf(file_final,"$|Z_I|$ & %.6e \\\\ \\hline\n$|Z_O|$ & %.6e \\\\ \\hline\n$f_L$ & %.6e \\\\ \\hline\n$f_H$ & %.6e \\\\ \\hline\n $f_O$ & %.6e \\\\ \\hline\n Gain & %.6e \\\\ \\hline", abs(Zinput), abs(Zoutput), fL, fH, fO, GainFinal);
fclose (file_final);

%Plot the gain
fig_gain = figure ("Visible", "off");
semilogx(f, Gain, "r");
xlabel("f [Hz]");
ylabel("Gain [dB]");
title("Theoretical Gain");
print (fig_gain, "gain_plot.eps", "-depsc");

%Plot the phase
fig_phase = figure ("Visible", "off");
semilogx(f, Phase, "b");
xlabel("f [Hz]");
ylabel("Phase [degrees]");
title("Theoretical Phase");
print (fig_phase, "phase_plot.eps", "-depsc");

close all;
