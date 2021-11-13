function GetBoutSpectrum(SpectrumAlongTime_normalize,BoutIdx_fore)
%% Get Second BoutSpectrum
HighFreRange=300;
OverLappingReg=(HighFreRange/2):HighFreRange;
Spectrum_2x=imresize(SpectrumAlongTime_normalize,[1000 size(SpectrumAlongTime_normalize,2)]);
Spectrum_2x=Spectrum_2x(OverLappingReg,:);

%% Clean mute part
% Spectrum_2x_clean=zeros(size(Spectrum_2x));
% Spectrum_2x_clean(:,BoutIdx_fore)=Spectrum_2x(:,BoutIdx_fore);
% %% Clean noise
% LengthThres=100;
% Spectrum_2x_bi=Spectrum_2x_clean>2;
% Spectrum_2x_bi_clean=RemoveComponentSmallerThan_2D(Spectrum_2x_bi,LengthThres);
% CC_Spectrum = bwconncomp(Spectrum_2x_bi_clean);
%%
CC_Spectrum = bwconncomp(BoutIdx_fore);
%%
TrackGroup_all={};
for CC_cnt=1:CC_Spectrum.NumObjects
    Lst=CC_Spectrum.PixelIdxList{CC_cnt};
    TimeRange=[min(Lst) max(Lst)];
    BoutSpectrum=Spectrum_2x(:,TimeRange(1):TimeRange(2));
    disp(CC_cnt);
    TrackGroup=IterativelyShortestDistanceCircle_Start(BoutSpectrum,HighFreRange);
    close all;
    TrackGroup_new=ArrangeTracks(TrackGroup,TimeRange,HighFreRange,SpectrumAlongTime_normalize);
    TrackGroup_all=[TrackGroup_all,TrackGroup_new];
end
%%

end