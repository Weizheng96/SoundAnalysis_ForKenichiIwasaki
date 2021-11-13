function RMS=Orig2RMS(Orig)

RMS1=3535*Orig+5.487;
RMS2=4485*Orig;

RMS=min(RMS1,RMS2);

end