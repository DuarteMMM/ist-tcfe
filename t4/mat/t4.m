clear all
%Ver melhor a cut-off frequency
%Gain stage

T=300.15;
k=1.38064852*(10e-23);
q=1.60217662*(10e-19);
VT=(k*T)/q;

%Beta_f usado no Ngspice para NPN model
Beta_f_NPN=178.7;

%Early Voltage usado no Ngspice para NPN model
VA_NPN=69.7;
  
%Valores usados no Ngspice
R1=70000;
R2=10000;
RC=1000;
RE_copy=100;
Rout = 50;
Ci=1.0e-3;
Cb=1.6e-3;
Co=1.2e-3;

%Talvez mudar VON
VON=0.7;
  
VCC=12;
RS=100;

RL=8;

RE=RE_copy;

%Slide 6 da aula 7

RB=1/(1/R1+1/R2);
VEQ=(R2/(R1+R2))*VCC;

IB=(VEQ-VON)/(RB+(1+Beta_f_NPN)*RE);
IC1=Beta_f_NPN*IB;
IE1=(1+Beta_f_NPN)*IB;
VE1=RE*IE1;
VO1=VCC-RC*IC1;
VCE=VO1-VE1;

%Slide 7 da aula 7
gm1=IC1/VT;
rpi1=Beta_f_NPN/gm1;
ro1=VA_NPN/IC1;

%Resistências RB e RS em paralelo, para usar em cálculos posteriores
R_BS=RB*RS/(RB+RS);

%Nota: AV designa o gain; AV1 no GainStage, AV2 no OutputStage, AV no total (no final, portanto)	    
%Verifiquei que, utilizando as duas fórmulas de calcular AV (com RE=0 e RE=RE_copy) e fazendo a média no final, dá melhores valores, considerando-se, assim, os dois modelos em simultâneo
			    
RE=RE_copy;
AV1 = (R_BS/RS)*RC*((RE-gm1*rpi1*ro1)/((ro1+RC+RE)*(R_BS+rpi1+RE)+gm1*RE*ro1*rpi1-RE*RE));
AV1_DB = 20*log10(abs(AV1));

%Considerando ro1=infinity
%AV1 = (RB/(RB+RS))*RC*((-gm1*rpi1)/(R_BS+rpi1+RE+gm1*RE*rpi1));
%AV1_DB = 20*log10(abs(AV1));

AV1_aux = AV1;
AV1_aux_DB = AV1_DB;

RE=0;
AV1 = (R_BS/RS)*RC*((RE-gm1*rpi1*ro1)/((ro1+RC+RE)*(R_BS+rpi1+RE)+gm1*RE*ro1*rpi1-RE*RE));
AV1_DB = 20*log10(abs(AV1));

%Considerando ro1=infinity
%AV1 = (RB/(RB+RS))*RC*((-gm1*rpi1)/(R_BS+rpi1+RE+gm1*RE*rpi1));
%AV1_DB = 20*log10(abs(AV1));


RE=RE_copy;
ZI1 = (RB*rpi1)/(RB+rpi1);
  
ZO1 = 1/(1/ro1+1/RC);

  
%Output stage
  
%Valores usados no Ngspice para o modelo PNP
Beta_f_PNP = 227.3;
Beta_r_PNP = 7.69;
VA_PNP = 37.2;

%O V1 do slide 14 da aula 17 é a tensão final que sai do GainStage
VI2 = VO1;
							   
IE2 = (VCC-VON-VI2)/Rout;

%Slide 13 da aula 15
%IC2 = ((Beta_r_PNP+1)/Beta_r_PNP)*IE2;
IC2 = (Beta_f_PNP/(1+Beta_f_PNP))*IE2;
  
VO2 = VCC - Rout*IE2;
VCE2 = VO2 + Rout*IE2;

%Expressões do slide 13 da aula 15, para PNP
gm2 = IC2/VT;
go2 = IC2/VA_PNP;
gpi2 = gm2/Beta_f_PNP;

%Slide 15 da aula 17
ge2 = 1/Rout;

%Slides 14 e 15 da aula 17
AV2 = gm2/(gpi2+ge2+go2+gm2);
ZI2 = (gpi2+ge2+go2+gm2)/(gpi2*(gpi2+ge2+go2));
ZO2 = 1/(gpi2+ge2+go2+gm2);


%Complete circuit - hand calculations no GitHub

%Termo para cálculos		 
gB = 1/(1/gpi2+ZO1);
		 
AV = ((gB+(gm2/gpi2)*gB)/(gB+ge2+go2+(gm2/gpi2)*gB))*AV1;
AV_DB = 20*log10(abs(AV));
		 
AV_aux = ((gB+(gm2/gpi2)*gB)/(gB+ge2+go2+(gm2/gpi2)*gB))*AV1_aux;
AV_DB_aux = 20*log10(abs(AV_aux));

  
ZI=ZI1;
  
ZO=1/(go2+(gm2/gpi2)*gB+ge2+gB);

Vbase=VEQ-RB*IB;
Vcoll=VO1;
Vemit=VE1;
Vin = 0;
Vin2 = 0;
Vout = 0;
Vemit2=VCC-Rout*IE2;
Vvcc = 12;

%Escrever em ficheiros

file_chosen_values = fopen("ChosenValues.tex","w");
fprintf(file_chosen_values, "$R_1$ & %.0f k$\\Omega$ \\\\ \\hline\n$R_2$ & %.0f k$\\Omega$ \\\\ \\hline\n$R_C$ & %.0f k$\\Omega$ \\\\ \\hline\n$R_E$ & %.0f $\\Omega$ \\\\ \\hline\n$R_{out}$ & %.0f $\\Omega$ \\\\ \\hline\n$C_i$ & %.1f mF \\\\ \\hline\n$C_b$ & %.1f mF \\\\ \\hline\n$C_o$ & %.1f mF \\\\ \\hline", R1/1000, R2/1000, RC/1000, RE_copy, Rout, Ci*1000, Cb*1000, Co*1000);
fclose (file_chosen_values);

file_op_point = fopen("OP_Theo.tex","w");
fprintf(file_op_point, "$V_{base}$ & %.6e \\\\ \\hline\n$V_{coll}$ & %.6e \\\\ \\hline\n$V_{emit}$ & %.6e \\\\ \\hline\n$V_{emit2}$ & %.6e \\\\ \\hline\n$V_{in}$ & %.6e \\\\ \\hline\n$V_{in2}$ & %.6e \\\\ \\hline\n$V_{out}$ & %.6e \\\\ \\hline\n$V_{vcc}$ & %.6e \\\\ \\hline", Vbase, Vcoll, Vemit, Vemit2, Vin, Vin2, Vout, Vvcc);
fclose (file_op_point);

file_vce_vbeon = fopen("VCE_VBEON.tex","w");
fprintf(file_vce_vbeon, "$V_{CE}$ & %.4f\\\\ \\hline\n$V_{BE_{ON}}$ & %.1f \\\\ \\hline", VCE, VON);
fclose (file_vce_vbeon);

file_impedances = fopen("Impedances.tex","w");
fprintf(file_impedances,"$Z_{I1}$ & %.6f \\\\ \\hline\n$Z_{O1}$ & %.6f \\\\ \\hline\n$Z_{I2}$ & %.6f \\\\ \\hline\n$Z_{O2}$ & %.6f \\\\ \\hline\n$Z_I$ & %.6f \\\\ \\hline\n$Z_O$ & %.6f \\\\ \\hline", ZI1, ZO1, ZI2, ZO2, ZI, ZO);
fclose (file_impedances);

file_IE = fopen("IE.tex","w");
fprintf(file_IE, "$I_E$ (Gain Stage) & %.4f mA\\\\ \\hline\n$I_E$ (Output Stage) & %.4f mA\\\\ \\hline\n$|V_{CE}|$ & %.1f V\\\\ \\hline\n$V_{EB_{ON}}$ & %.1f V\\\\ \\hline", IE1*1000, IE2*1000, VCE2, VON);
fclose (file_IE);

%file_gains1 = fopen("Gains1.tex","w");
%fprintf(file_gains1,"$AV_1$ & %.6f \\\\ \\hline\n$AV_2$ & %.6f \\\\ \\hline\n$AV$ & %.6f \\\\ \\hline\n$AV$ & %.6f dB \\\\ \\hline\n", AV1, AV2, AV, AV_DB);
%fclose (file_gains1);

%file_gains2 = fopen("Gains2.tex","w");
%fprintf(file_gains2,"$AV_1$ & %.6f \\\\ \\hline\n$AV_2$ & %.6f \\\\ \\hline\n$AV$ & %.6f \\\\ \\hline\n$AV$ & %.6f dB \\\\ \\hline\n", AV1_aux, AV2, AV_aux, AV_DB_aux);
%fclose (file_gains2);

file_gains = fopen("Gains.tex","w");
fprintf(file_gains,"$AV_1$ & %.6f \\\\\n$AV_1$ [dB] & %.6f \\\\ \\hline\n$AV_2$ & %.6f \\\\\n$AV_2$ [dB] & %.6f \\\\ \\hline\n$AV$ & %.6f \\\\\n$AV$ [dB] & %.6f\\\\ \\hline\n", 0.5*(AV1_aux+AV1), 20*log10(0.5*(AV1_aux+AV1)), AV2, 20*log10(AV2), 0.5*(AV_aux+AV), 20*log10(0.5*(AV_aux+AV)));
fclose (file_gains);

file_impedances_compare = fopen("ImpedancesCompare.tex","w");
fprintf(file_impedances_compare,"$Z_I$ & %.6e \\\\ \\hline\n$Z_O$ & %.6e \\\\ \\hline", ZI, ZO);
fclose (file_impedances_compare);

%Lower cut-off frequency

RE=RE_copy;

Req_b = (R_BS+rpi1)/(1+gm1*rpi1);
Req_b = (Req_b*RE)/(Req_b+RE);

w_L= 1/((ZI+RS)*Ci)+1/(Cb*Req_b)+1/((ZO+RL)*Co);
f_L=w_L/(2*pi);

file_cutoff = fopen("CutOff.tex","w");
fprintf(file_cutoff,"$f_L$ & %.6f \\\\ \\hline", f_L);
fclose (file_cutoff);

file_cutoff_gain = fopen("CutOffGain.tex","w");
fprintf(file_cutoff_gain,"$f_L$ [Hz] & %.6e \\\\ \\hline\n$AV$ [dB] & %.6e\\\\ \\hline", f_L, 20*log10(0.5*(AV_aux+AV)));
fclose (file_cutoff_gain);

%High cut-off frequency, retirada diretamente do Ngspice
f_H = 1.928995e+6;
%f_L = 1.991176e+1;


%Plot

f = logspace(1,8,100);

%Variáveis auxiliares para fazer os plots; existe declive 20dB até f_L e declive -20 dB após f_H

%Considerando RE=RE_copy
Aux_gain_11 = (10^(AV_DB_aux/20))/f_L;
Aux_gain_12 = (10^(-AV_DB_aux/(20)))/f_H;

%Considerando RE=0
Aux_gain_21 = (10^(AV_DB/20))/f_L;
Aux_gain_22 = (10^(-AV_DB/20))/f_H;

%Fazendo uma média dos dois
Aux_gain_31 = (10^((AV_DB_aux+AV_DB)/40))/f_L;
Aux_gain_32 = (10^((-AV_DB_aux-AV_DB)/40))/f_H;

Gain_1 = @(f) 20*log10(f*Aux_gain_11).*(f<f_L)+AV_DB_aux*(f>=f_L & f<f_H+1)-20*log10(f*Aux_gain_12).*(f>=f_H);
Gain_2 = @(f) 20*log10(f*Aux_gain_21).*(f<f_L)+AV_DB*(f>=f_L & f<f_H)-20*log10(f*Aux_gain_22).*(f>=f_H);
Gain_3 = @(f) 20*log10(f*Aux_gain_31).*(f<f_L)+0.5*(AV_DB_aux+AV_DB)*(f>=f_L & f<f_H)-20*log10(f*Aux_gain_32).*(f>=f_H);


fig_gain = figure ("Visible", "off");

%semilogx(f, Gain_1(f), f , Gain_2(f), f, Gain_3(f), "");
semilogx(f, Gain_3(f), "r");

xlabel("Frequency [Hz]");
ylabel("Gain [dB]");

title("Theoretical Gain");

%hleg1=legend ("RE=100\\Omega","RE=0\\Omega","Average of both AV values","Location","southeast");
%set(hleg1, "FontSize", 14);

print (fig_gain, "gain_plot.eps", "-depsc");

close all;
