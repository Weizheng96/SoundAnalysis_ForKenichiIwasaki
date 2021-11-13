function SpectrumAlongTime_normalize=normalizeSpectrum(SpectrumAlongTime,bout_Idx_short)

SpectrumAlongTime_smooth=SpectrumAlongTime;
SpectrumAlongTime_smooth(200:end,:)=imgaussfilt(SpectrumAlongTime(200:end,:),2);

global Background_shrink;

CC_bout_idx_short=bwconncomp(bout_Idx_short==0);
bout_idx_short_valid=false(size(bout_Idx_short));
for cc_cnt=1:CC_bout_idx_short.NumObjects
    lst=CC_bout_idx_short.PixelIdxList{cc_cnt};
    if length(lst)>Background_shrink*2
        lst_mid=lst(Background_shrink:end-Background_shrink);
        bout_idx_short_valid(lst_mid)=true;
    end
end


Spectrum_noise=SpectrumAlongTime_smooth(:,bout_idx_short_valid);


Spectrum_noise_mean=mean(Spectrum_noise,2);
Spectrum_noise_std=std(Spectrum_noise,0,2);
Spectrum_noise_std(Spectrum_noise_std==0)=1;

SpectrumAlongTime_normalize=(SpectrumAlongTime_smooth-Spectrum_noise_mean)./Spectrum_noise_std;

end