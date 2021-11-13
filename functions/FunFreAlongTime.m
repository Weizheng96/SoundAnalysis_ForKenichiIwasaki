function [FunFreAlongTime,FunFreAlongTime_min,FunFreAlongTime_max]=FunFreAlongTime(y,Fs,rt,FunRange,bout_Idx,sampleTime,stepTime)

L=length(y);
SampleUint=sampleTime*Fs;
stepUint=stepTime*Fs;
FunFreAlongTime_min=zeros(size(y));
FunFreAlongTime_max=zeros(size(y));
FunFreAlongTime=zeros(size(y));
for t=1:ceil(L/stepUint)
    step_idx_min=(t-1)*stepUint+1;
    step_idx_max=min(t*stepUint,L);
    time_step=step_idx_min:step_idx_max;
    if sum(bout_Idx(time_step))>0
        
        step_idx_mid=round((step_idx_min+step_idx_max)/2);
        sample_idx_min=max(step_idx_mid-SampleUint,1);
        sample_idx_max=sample_idx_min+SampleUint-1;

        if sample_idx_max>L
            sample_idx_min=L-SampleUint+1;
            sample_idx_max=L;
        end
        time_sample=sample_idx_min:sample_idx_max;
        if(length(time_sample)<Fs)
            sample=zeros(Fs,1);
            sample(1:length(time_sample))=y(time_sample);
        else
            sample=y(time_sample);
        end
        [FunFre,min_fundfre,max_fundfre]=GetFunFre(sample,Fs,rt,FunRange,false);

        FunFreAlongTime_min(time_step)=min_fundfre;
        FunFreAlongTime_max(time_step)=max_fundfre;
        FunFreAlongTime(time_step)=FunFre;
    end
end

end