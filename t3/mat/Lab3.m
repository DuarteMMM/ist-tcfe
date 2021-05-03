close all
clear all

pkg load symbolic;

global R1;
global R2;
global C;
global w;
global tOFF;

%To be chosen
R1 = 1.e3;
R2 = 1.e3;
C = 0.0005;

%Write values to file
file_chosen_values = fopen("ChosenValues.tex","w");
fprintf(file_chosen_values,"$R_1$ & %.0f $\\Omega$ \\\\ \\hline\n$R_2$ & %.0f $\\Omega$ \\\\ \\hline\n$C$ & %.4f $F$ \\\\ \\hline", R1, R2, C);
fclose (file_chosen_values);

%Given values
f=50;
V1 = 230.;
V2 = 12.;
n=V1/V2;
	
%Envelope detector

%Time vector and angular frequency
t=linspace(0, 5/f, 1000);
w=2*pi*f;

%Voltage in transformer 2
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
vOexp = V2*cos(w*tOFF)*exp(-(t-tOFF)/(R1*C));

%Function
function f_t_on = f_t_on(tON)
  global R1;
  global R2;
  global C;
  global w;
  global tOFF;
  f_t_on=cos(w*tON)-cos(w*tOFF)*exp(-(tON-tOFF)/(R1*C));
endfunction

%Derivative
function f_t_on_derivative = f_t_on_derivative(tON)
  global R1;
  global R2;
  global C;
  global w;
  global tOFF;
  f_t_on_derivative=-w*sin(w*tON)+(1/(R1*C))*cos(w*tOFF)*exp(-(tON-tOFF)/(R1*C));
endfunction

%Newton-Raphson
function f_t_on_solve = f_t_on_solve ()
  global R1;
  global R2;
  global C;
  global w;
  global tOFF;
  delta=1e-6;
  x_next=0.01; 
  do
    x=x_next;
    x_next=x-f_t_on(x)/f_t_on_derivative(x);
  until (abs(x_next-x)<delta)
  f_t_on_solve=x_next;
endfunction

tON=f_t_on_solve()
tON=1/(2*f)

  %{
%Obtain the final voltage after the envelope detector
for i=1:length(t)
	if t(i) < tOFF
	  vOenv(i) = vrec(i);
        elseif ((t(i) >= tOFF) & (t(i)<tOFF+tON))
	  vOenv(i) = vOexp(i);
	else
	    tOFF = tOFF + tON;
            vOexp = V2*abs(cos(w*tOFF))*exp(-(t-tOFF)/(R1*C));
	    vOenv(i) = vrec(i);
        endif
endfor
%}

%Write tON and tOFF values to file
file_toff_ton = fopen("tOFF_tON.tex","w");
fprintf(file_chosen_values,"$t_{OFF}$ & %f $s$ \\\\ \\hline\n$t_{ON}$ & %f $s$ \\\\ \\hline", tOFF, tON);
fclose (file_toff_ton);

for i=1:length(t)
	if t(i) < tOFF
	  vOenv(i) = vrec(i);
	  elseif vOexp(i) > vrec(i)
	    vOenv(i) = vOexp(i);
	  else
	    tOFF = tOFF + tON;
            vOexp = V2*abs(cos(w*tOFF))*exp(-(t-tOFF)/(R1*C));
	    vOenv(i) = vrec(i);
	 endif
endfor


    

%Plot

fig_envelope = figure ("Visible", "off");
title("Voltages in Envelope Detector")
plot (t*1000, vrec, ";v_2 (rectified) (t);", t*1000, vOenv, ";v_O (envelope) (t);");
xlabel ("t [ms]")
ylabel ("v [V]")
legend("Location", "southwest");
print (fig_envelope, "envelope.eps", "-depsc");

close all;
