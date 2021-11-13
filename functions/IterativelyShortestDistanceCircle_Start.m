function TrackGroup_adjusted=IterativelyShortestDistanceCircle_Start(SpectrumAlongTime_normalize,HighFreRange)
%% get loop spectrum_x2
OverLappingReg=(HighFreRange/2):HighFreRange;
Spectrum_2x=imresize(SpectrumAlongTime_normalize(1:2000,:),[1000 size(SpectrumAlongTime_normalize,2)]);
Spectrum_2x=Spectrum_2x(OverLappingReg,:);
%%
global wmap;
wmap=imgaussfilt(SpectrumAlongTime_normalize,3);
%% get x2
startIdx=-1;
LowFreRange1=HighFreRange/2;
LowFreRange2=HighFreRange/3*2;
x2=LowFreRange2-LowFreRange1+1;
TrackGroup=IterativelyShortestDistanceCircle(Spectrum_2x,x2,startIdx);
%% Write Track
StartFre=OverLappingReg(1)-1;
TrackGroup_adjusted=GetAdjustedTrackGroup(TrackGroup,StartFre);
end