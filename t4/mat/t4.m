clear all

%Gain stage

%Talvez mudar VT
VT=25e-3;
%Beta_f usado no Ngspice para NPN model
Beta_f_NPN=178.7;
%Early Voltage usado no Ngspice para NPN model
VA_NPN=69.7;
  
RE_copy=200;
RC=3800;
R1=33700;
R2=3600;

%Talvez mudar VON
VON=0.7;
  
VCC=12;
RS=100;
Ci=800e-6;
Cb=800e-6;
C2=600e-6;
RL=8;

RE=RE_copy;

%Slide 6 da aula 7

RB=1/(1/R1+1/R2);
%POR SINAL NEGATIVO NO VEQ???????
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
			    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VERIFICAR QUAL A MELHOR APROXIMACAO, RE=0 OU RE=RE_COPY
% O VALOR CERTO DEVE FICAR NO MEIO DOS DOIS, ENTRE OC E SC???????????

RE=RE_copy;
AV1 = (R_BS/RS)*RC*((RE-gm1*rpi1*ro1)/((ro1+RC+RE)*(R_BS+rpi1+RE)+gm1*RE*ro1*rpi1-RE*RE));
%Valor em decibéis, em módulo
  AV1_DB = 20*log10(abs(AV1));

%WHYYY??????????
AV1_aux = AV1;

%Mudei esta expressão, pois penso que estava mal; é considerando r0=infinity
%AV1_simple = RB/(RB+RS) * gm1*RC/(1+gm1*RE)
AV1_simple = (RB/(RB+RS))*RC*((-gm1*rpi1)/(R_BS+rpi1+RE+gm1*RE*rpi1));
AV1_simple_DB = 20*log10(abs(AV1_simple));


RE=0;
AV1 = (R_BS/RS)*RC*((RE-gm1*rpi1*ro1)/((ro1+RC+RE)*(R_BS+rpi1+RE)+gm1*RE*ro1*rpi1-RE*RE));
AV1_DB = 20*log10(abs(AV1));
%AV1_simple =  - R_BS/RS * gm1*RC/(1+gm1*RE)
  AV1_simple = (RB/(RB+RS))*RC*((-gm1*rpi1)/(R_BS+rpi1+RE+gm1*RE*rpi1));
AV1_simple_DB = 20*log10(abs(AV1_simple));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RE=RE_copy;
%Mudei, não percebo porquê esta expressão
%ZI1 = 1/(1/RB+1/(((ro1+RC+RE)*(rpi1+RE)+gm1*RE*ro1*rpi1 - RE^2)/(ro1+RC+RE)))
  ZI1 = (RB*rpi1)/(RB+rpi1);

%Tirei, não percebo as expressões...  
%ZX = ro1*((R_BS+rpi1)*RE/(R_BS+rpi1+RE))/(1/(1/ro1+1/(rpi1+R_BS)+1/RE+gm1*rpi1/(rpi1+R_BS)))
%ZX = ro1*(   1/RE+1/(rpi1+R_BS)+1/ro1+gm1*rpi1/(rpi1+R_BS)  )/(   1/RE+1/(rpi1+R_BS) )
%ZO1_aux = 1/(1/ZX+1/RC)
  
  RE=0;
%ZI1 = 1/(1/RB+1/(((ro1+RC+RE)*(rpi1+RE)+gm1*RE*ro1*rpi1 - RE^2)/(ro1+RC+RE)))
  ZI1 = (RB*rpi1)/(RB+rpi1);
  
  
ZO1 = 1/(1/ro1+1/RC);

  
%Output stage
  
%Beta_f usado no Ngspice para o modelo PNP
Beta_f_PNP = 227.3;
%Beta_r usado no Ngspice para o modelo PNP
Beta_r_PNP = 7.69;
%Early Voltage usado no Ngscpice para o modelo PNP
VA_PNP = 37.2;
  
Rout = 400;

%O V1 do slide 14 da aula 17 é a tensão final que sai do GainStage
VI2 = VO1;
							   
IE2 = (VCC-VON-VI2)/Rout;

%Mudei a expressão, de acordo com o que está no slide 13 da aula 15
%IC2 = Beta_f_PNP/(Beta_f_PNP+1)*IE2
  IC2 = ((Beta_r_PNP+1)/Beta_r_PNP)*IE2;
  
VO2 = VCC - Rout*IE2;

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
		 
AV_aux = AV*AV1_aux/AV1;

AV_DB = 20*log10(abs(AV));
  
  AV_DB_aux = 20*log10(abs(AV_aux));

  %Nota: os aux são basicamente uma forma diferente de calcular...
  
  ZI=ZI1;
  
ZO=1/(go2+(gm2/gpi2)*gB+ge2+gB);


%Escrever em ficheiros

file_impedances = fopen("Impedances.tex","w");
fprintf(file_impedances,"$Z_{I1}$ & %.6f $\\Omega$ \\\\ \\hline\n$Z_{O1}$ & %.6f $\\Omega$ \\\\ \\hline\n$Z_{I2}$ & %.6f $\\Omega$ \\\\ \\hline\n$Z_{O2}$ & %.6f $\\Omega$ \\\\ \\hline\n$Z_O$ & %.6f $\\Omega$ \\\\ \\hline", ZI1, ZO1, ZI2, ZO2, ZO);
fclose (file_impedances);

file_gains = fopen("Gains.tex","w");
fprintf(file_gains,"$AV_1$ & %.6f \\\\ \\hline\n$AV_2$ & %.6f \\\\ \\hline\n$AV$ & %.6f \\\\ \\hline\n$AV$ & %.6f dB \\\\ \\hline\n", AV1, AV2, AV, AV_DB);
fclose (file_gains);

file_gains2 = fopen("Gains2.tex","w");
fprintf(file_gains2,"$AV_1$ & %.6f \\\\ \\hline\n$AV_2$ & %.6f \\\\ \\hline\n$AV$ & %.6f \\\\ \\hline\n$AV$ & %.6f dB \\\\ \\hline\n", AV1_aux, AV2, AV_aux, AV_DB_aux);
fclose (file_gains2);

%Lower cut-off frequency

RE=RE_copy;

Aux =(rpi1+R_BS)/(rpi1*gm1);
Aux = Aux*RE/(Aux+RE);

w_L= 1/(Cb*Aux)+ 1/((ZO+RL)*C2) +1/((ZI+RS)*Ci);
f_L=w_L/(2*pi);

file_cutoff = fopen("CutOff.tex","w");
fprintf(file_cutoff,"Lower cut-off frequency & %.6f \\\\ \\hline", f_L);
fclose (file_cutoff);


%Plot

f = logspace(1,8,100);

b = (10^(AV_DB/20))/f_L;
c = (10^(AV_DB_aux/20))/f_L;
d = (10^((AV_DB_aux+AV_DB)/40))/f_L;

gain_func_h = @(f) 20*log10(f*b).*(f<f_L & f>0)+AV_DB*(f>=f_L & f>0);
gain_func_l = @(f) 20*log10(f*c).*(f<f_L & f>0)+AV_DB_aux*(f>=f_L & f>0);
gain_func_m = @(f) 20*log10(f*d).*(f<f_L & f>0)+0.5*(AV_DB_aux+AV_DB)*(f>=f_L & f>0);

fig_gain = figure ("Visible", "off");

semilogx(f, gain_func_h(f), f , gain_func_l(f), f, gain_func_m(f), "--");

xlabel("Frequency [Hz]");
ylabel("Gain [dB]");
ylim([-10 50]);

title("Theoretical Gains");

hleg1=legend ("Upper Gain Bound","Lower Gain Bound","Gain approximation","Location","southeast");
set(hleg1, "FontSize", 14);

print (fig_gain, "gain_plot.eps", "-depsc");

close all;
