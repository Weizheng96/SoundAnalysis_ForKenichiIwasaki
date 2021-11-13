function AmpAlongTime=getAmpAlongTime(y,Fs,min_HZ,sampleTime,stepTime)
%% along time
L=length(y);
SampleUint=sampleTime*Fs;
stepUint=stepTime*Fs;
AmpAlongTime=zeros(size(y));

stepUint=stepTime*Fs;

for t=1:ceil(L/stepUint)
    step_idx_min=(t-1)*stepUint+1;
    step_idx_max=min(t*stepUint,L);
    time_step=step_idx_min:step_idx_max;
    
    step_idx_mid=round((step_idx_min+step_idx_max)/2);
    sample_idx_min=max(step_idx_mid-SampleUint,1);
    sample_idx_max=sample_idx_min+SampleUint-1;
    
    if sample_idx_max>L
        sample_idx_min=L-SampleUint+1;
        sample_idx_max=L;
    end
    
    time_sample=sample_idx_min:sample_idx_max;

    [P1,~,freUint]=FFTparameter(y(time_sample),Fs);
    AmpAlongTime(time_step)=sum(P1(round(min_HZ/freUint):end));
end

end