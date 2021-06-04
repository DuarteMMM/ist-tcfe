clear all

%Valores utilizados
C1=220e-9;
C2=220e-9;
R1=1.e+3;
R2=1.e+3;
R2p=1.e+3;
R3=100.e+3;
R4=1.3e+3;
R4p=1.e+3;

file_chosen_values = fopen("ChosenValues.tex","w");
fprintf(file_chosen_values, "$C_1$ & %.0f $\\mu$ F \\\\ \\hline\n$C_2$ & %.0f $\\mu$ F \\\\ \\hline\n$R_1$ & %.0f k$\\Omega$ \\\\ \\hline\n$R_2$ & %.0f k$\\Omega$ \\\\ \\hline\n$R_{2p}$ & %.0f k$\\Omega$ \\\\ \\hline\n$R_3$ & %.0f k$\\Omega$ \\\\ \\hline\n$R_4$ & %.0f k$\\Omega$ \\\\ \\hline\n$R_{4p}$ & %.0f k$\\Omega$ \\\\ \\hline", C1/(1.e-9), C2/(1.e-9), R1/1000, R2/1000, R2p/1000, R3/1000, R4/1000, R4p/1000);
fclose (file_chosen_values);

R2=(R2*R2p)/(R2+R2p);
R4=(R4*R4p)/(R4+R4p);

fmain=1.e+3;
wmain=2*pi*fmain;
v=113.e-3;


%Calculanting input impedance and Vplus
#Vplus=v/(1+R1*j*wmain*C1);
Zinput=R1+1/(j*wmain*C1);

Zoutput=1/(-1/R2-j*wmain*C2);

%Calculating the final voltage and gain
#Vzeta=Vplus*(1+R3/R4);
#Vfinal=Vzeta/(1+R2*j*wmain*C2);
#Gain=20*log10(abs(Vfinal)/abs(v));

%No clue about how to calculate output impedance HELP!!!!!

%Computing gains for the vector of log
f = logspace(1,8,100);
w=2*pi*f;
Vplus=v./(1+R1*j*w.*C1);
Vzeta=Vplus.*(1+R3/R4);
Vfinal=Vzeta./(1+R2*j*w*C2);
teta=((R1*C1*j*w)*(1+R3/R4))./((1+R1*C1*j*w).*(1+R2*C2*j*w));
Gain=20*log10(abs(teta));

%Lower and higher cut-off frequencies and central frequency

wL=1/(R1*C1);
fL=wL/(2*pi);
wH=1/(R2*C2);
fH=wH/(2*pi);
wO=sqrt(wL*wH);
fO=wO/(2*pi);
VplusFinal=v/(1+R1*j*wO*C1);
VzetaFinal=VplusFinal*(1+R3/R4);
VfinalFinal=VzetaFinal/(1+R2*j*wO*C2);
GainFinal=20*log10(abs(VfinalFinal)/abs(v));
  
%Write in files

file_impedances = fopen("Impedances.tex","w");
fprintf(file_impedances,"$|Z_I|$ & %.6f \\\\ \\hline\n$|Z_O|$ & %.6f \\\\ \\hline", abs(Zinput), abs(Zoutput));
fclose (file_impedances);

file_gain_frequencies = fopen("GainFrequencies.tex","w");
fprintf(file_gain_frequencies,"$f_L$ & %.6f \\\\ \\hline\n$f_H$ & %.6f \\\\ \\hline\n$f_O$ & %.6f \\\\ \\hline\nGain & %.6f \\\\ \\hline", fL, fH, fO, GainFinal);
fclose (file_gain_frequencies);

%Plotting

fig_gain = figure ("Visible", "off");

semilogx(f, Gain, "r");

xlabel("Frequency [Hz]");
ylabel("Gain [dB]");

title("Theoretical Gain");
print (fig_gain, "gain_plot.eps", "-depsc");

close all;
