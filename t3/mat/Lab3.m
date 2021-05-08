close all
clear all

pkg load symbolic;

%To be chosen
%R1 = 5.e3;
R1 = 0.10275e3;
C = 5.e-4;

%Write values to file
file_chosen_values = fopen("ChosenValues.tex","w");
fprintf(file_chosen_values,"$R_1$ & %f $\\Omega$ \\\\ \\hline\n$C$ & %f $F$ \\\\ \\hline", R1, C);
fclose (file_chosen_values);

f=50;
V1 = 230.;

	
%Envelope detector

%Time vector and angular frequency
t=linspace(0, 5/f, 1000);
w=2*pi*f;

%Voltage in transformer 2
V2 = 96.575+2*1*0.025;
n=V1/V2;
v2 = V2 * cos(w*t);

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

Half_period=1/(2*f);

%Write tOFF value to file
file_toff = fopen("tOFF.tex","w");
fprintf(file_toff,"$t_{OFF}$ & %f $s$ \\\\ \\hline", tOFF);
fclose (file_toff);

global R2;
R2=4621.8;
global eta;
eta=1;
global V_T;
V_T=0.025;
global I_S;
I_S=1.e-14;
global N_diodos;
N_diodos=17;


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

	 global v_env_average;
	 v_env_average=mean(vOenv);

function f_out = f_out(V_OUT)
  global R2;
global I_S;
global N_diodos;
global eta;
global V_T;
global v_env_average;
f_out=V_OUT+R2*I_S*(exp(V_OUT/(N_diodos*eta*V_T))-1)-v_env_average;
endfunction;

function f_out_der = f_out_der(V_OUT)
  global R2;
global I_S;
global N_diodos;
global eta;
global V_T;
f_out_der=1+((R2*I_S)/(N_diodos*eta*V_T))*exp(V_OUT/(N_diodos*eta*V_T));
endfunction;

%Newton-Raphson
function f_out_solve = f_out_solve ()
  delta=1e-6;
  x_next=12; 
  do
    x=x_next;
    x_next=x-f_out(x)/f_out_der(x);
  until (abs(x_next-x)<delta)
  f_out_solve=x_next;
endfunction

V_OUT=f_out_solve();

v_out_vec=zeros(1, length(t));

for i=1:length(t)
	v_out_vec(i) = vOenv(i)-v_env_average;
%disp(v_out_vec(i));
endfor

r_d=(eta*V_T)/(I_S*exp(V_OUT/(N_diodos*V_T)));

v_OUT=zeros(1, length(t));
factor=(N_diodos*r_d)/(N_diodos*r_d+R2);
  
for i=1:length(t)
	v_OUT(i)=V_OUT+factor*v_out_vec(i);
endfor

v_OUT_average=mean(v_OUT)

%Plot

fig_voltages = figure ("Visible", "off");
title("Voltages in Envelope Detector and Voltage Regulator")
plot (t*1000, vrec, ";v_2 (rectified) (t);", t*1000, vOenv, ";v_O (envelope) (t);", t*1000, v_OUT, ";v_{OUT} (t);");
xlabel ("t [ms]")
ylabel ("v [V]")
legend("Location", "southwest");
print (fig_voltages, "envelope.eps", "-depsc");

%Write values to file
file_chosen_values2 = fopen("ChosenValues2.tex","w");
fprintf(file_chosen_values2,"$R_2$ & %f $\\Omega$ \\\\ \\hline", R2);
fclose (file_chosen_values2);

close all;
