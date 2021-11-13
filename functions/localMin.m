function AmpAlongTime_smooth=localMin(AmpAlongTime,sampleTime,stepTime)

AmpAlongTime_smooth=nan(size(AmpAlongTime));
ScaleP=ceil(sampleTime/stepTime/2);

for t=1:length(AmpAlongTime)

    sample_idx_min=max(t-ScaleP,1);
    sample_idx_max=min(t+ScaleP,length(AmpAlongTime));
    
    time_sample=sample_idx_min:sample_idx_max;

    AmpAlongTime_smooth(t)=min(AmpAlongTime(time_sample));
end

end