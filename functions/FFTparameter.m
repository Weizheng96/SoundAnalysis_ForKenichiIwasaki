function [P1,f,freUint]=FFTparameter(y_sample,Fs)
L=length(y_sample);
Y_sample=fft(y_sample);
P2 = abs(Y_sample/L);
if(mod(L,2)==1)
    P1 = P2(1:(L+1)/2);
    P1(2:end) = 2*P1(2:end);
else
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
end
f = Fs*(0:(L/2))/L;
freUint=f(2);
end