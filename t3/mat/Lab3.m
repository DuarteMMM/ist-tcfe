close all
clear all

pkg load symbolic;

format long;

R1 = 10.75e3;
C = 5000.e-6;

f=50;
V1 = 230.;
w=2*pi*f;


%Time vector for 10 periods and 1000 points
t=linspace(0, 5/f, 1000);

%Voltage in transformer 2
V2 = 50.;
n=V1/V2;
v2 = V2*cos(w*t);

%Full-wave rectified
vrec = zeros(1, length(t));

for i=1:length(t)
	vrec(i) = abs(v2(i));
endfor

%Final voltage after envelope detector
vOenv = zeros(1, length(t));

%tOFF and exponencial due to capacitor

tOFF = (1/w) * atan(1/(w*R1*C))
tOFF_copy=tOFF;
vOexp = V2*cos(w*tOFF)*exp(-(t-tOFF)/(R1*C));

%Variables used in Newton-Raphson calculations and/or in the voltage regulator calculations

Half_period=1/(2*f);

global R2;
R2=5.10979e3;
global eta;
eta=1;
T=300.15;
k=1.38064852*(10e-23);
q=1.60217662*(10e-19);
global V_T;
V_T=(k*T)/q;
global I_S;
I_S=1.e-14;
global N_diodes;
N_diodes=17;


%Obtain output voltage of envelope detector
for i=1:length(t)
	if t(i) < tOFF
	  vOenv(i) = vrec(i);
	  elseif vOexp(i) > vrec(i)
	    vOenv(i) = vOexp(i);
	  else
	    tOFF = tOFF + Half_period;
            vOexp = V2*abs(cos(w*tOFF_copy))*exp(-(t-tOFF)/(R1*C));
	    vOenv(i) = vrec(i);
	 endif
endfor

% Mean value of the output voltage of the envelope detector	 
global v_env_average;
v_env_average=mean(vOenv);

%Functions used in Newton-Rapshon method
function f_out = f_out(V_OUT)
global R2;
global I_S;
global N_diodes;
global eta;
global V_T;
global v_env_average;
f_out=V_OUT+R2*I_S*(exp(V_OUT/(N_diodes*eta*V_T))-1)-v_env_average;
endfunction;

function f_out_der = f_out_der(V_OUT)
global R2;
global I_S;
global N_diodes;
global eta;
global V_T;
f_out_der=1+((R2*I_S)/(N_diodes*eta*V_T))*exp(V_OUT/(N_diodes*eta*V_T));
endfunction;

function f_out_solve = f_out_solve ()
  delta=1e-6;
  x_next=12; 
  do
    x=x_next;
    x_next=x-f_out(x)/f_out_der(x);
  until (abs(x_next-x)<delta)
  f_out_solve=x_next;
endfunction

% DC component of final output voltage
V_OUT=f_out_solve();

% AC component of the output voltage in the envelope detector
v_out_vec=zeros(1, length(t));

for i=1:length(t)
	v_out_vec(i) = vOenv(i)-v_env_average;
endfor

% Incremental resistance
r_d=(eta*V_T)/(I_S*exp(V_OUT/(N_diodes*V_T)));

% Final output voltage (=DC+AC)
v_OUT=zeros(1, length(t));

factor=(N_diodes*r_d)/(N_diodes*r_d+R2);
  
for i=1:length(t)
	v_OUT(i)=V_OUT+factor*v_out_vec(i);
disp(v_OUT(i));
endfor

% Difference bewteen final output voltage and desired 12V over time
v_OUT_diff_from_12=zeros(1, length(t));

for i=1:length(t)
	v_OUT_diff_from_12(i)=v_OUT(i)-12;
endfor

% Average and ripple of final output voltage
v_OUT_average=mean(v_OUT)
max_ripple=max(v_out_vec)*factor
ripple_v_OUT_average=max(v_OUT)-min(v_OUT)

%Write values to files
  
file_chosen_values = fopen("ChosenValues.tex","w");
fprintf(file_chosen_values,"$R_1$ & %.5f $k\\Omega$ \\\\ \\hline\n$R_2$ & %.5f $k\\Omega$ \\\\ \\hline\n$C$ & %.0f $\\mu F$ \\\\ \\hline\n$V_{T2}$ & %.0f $V$ \\\\ \\hline\n$n$ & %.1f \\\\ \\hline", R1*0.001, R2*0.001, C*(1.e6), V2, n);
fclose (file_chosen_values);
  
file_final = fopen("FinalVoltage_Average_Ripple.tex","w");
fprintf(file_final,"$\\overline{v}_{OUT}$ & %.6e \\\\ \\hline\n$max (v_{OUT})$ & %.6e \\\\ \\hline\n$min (v_{OUT})$ & %.6e \\\\ \\hline\n$ripple (v_{OUT})$ & %.6e \\\\ \\hline", v_OUT_average, max(v_OUT), min(v_OUT), ripple_v_OUT_average);
fclose (file_final);


%Plots

% Vectors for plots of only 6 periods
subVector_t = t(1:600);
subVector_vrec = vrec(1:600);
subVector_vOenv = vOenv(1:600);
subVector_v_OUT = v_OUT(1:600);
  
fig_voltages = figure ("Visible", "off");
title("Voltages in Envelope Detector and Voltage Regulator")
plot (t*1000, vrec, ";v_{O_{rectified}} (t);", t*1000, vOenv, ";v_{O_{env}} (t);", t*1000, v_OUT, ";v_{OUT} (t);");
hleg0=legend();
set(hleg0, "FontSize", 11);
ylim([0 1.05*V2]);
xlabel ("t [ms]")
ylabel ("v [V]")
legend("Location", "southwest");
print (fig_voltages, "rec_env_reg.eps", "-depsc");

fig_rectified_envelope = figure ("Visible", "off");
title("Voltage in Envelope Detector")
plot (subVector_t*1000, subVector_vrec, ";v_{O_{rectified}} (t);", subVector_t*1000, subVector_vOenv, ";v_{O_{env}} (t);");
hleg1=legend();
set(hleg1, "FontSize", 14);
ylim([0.995*min(subVector_vOenv) 1.0001*max(subVector_vOenv)]);
xlabel ("t [ms]")
ylabel ("v [V]")
legend("Location", "southwest");
print (fig_rectified_envelope, "rec_env.eps", "-depsc");

fig_regulator = figure ("Visible", "off");
title("Voltage in Voltage Regulator")
p2=plot (subVector_t*1000, subVector_v_OUT, ";v_{OUT} (t);");
hleg2=legend();
set(hleg2, "FontSize", 14);
ylim([0.99999*min(subVector_v_OUT) 1.00001*max(subVector_v_OUT)]);
set(p2, "Color", [0.9290 0.6940 0.1250])
xlabel ("t [ms]")
ylabel ("v [V]")
legend("Location", "southwest");
print (fig_regulator, "reg.eps", "-depsc");

fig_difference = figure ("Visible", "off");
title("Difference between the final output voltage obtained and 12V")
p3=plot (t*1000, v_OUT_diff_from_12, ";v_{OUT}(t)-12;");
ylim([0.99*min(v_OUT_diff_from_12) 1.01*max(v_OUT_diff_from_12)]);
set(p3, "Color", "b")
xlabel ("t [ms]")
ylabel ("\\Delta v [V]")
legend("Location", "southwest");
print (fig_difference, "difference.eps", "-depsc");

close all;
