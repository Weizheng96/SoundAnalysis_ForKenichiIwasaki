function [StartTime,EndTime,Spectrum_2x_bi_clean]=GetStartAndEndTime(Spectrum_2x)

%% smooth
% Spectrum_2x=imgaussfilt(Spectrum_2x,[3 5]);
%% Clean noise
global LengthThres;
global SignalZscoreThreshold;
% global ComponentClose;
% global signalRemovalGaussianFilter;
% Spectrum_2x=imgaussfilt(Spectrum_2x,signalRemovalGaussianFilter);
Spectrum_2x_bi=Spectrum_2x>3;
Spectrum_2x_bi_clean=RemoveComponentSmallerThan_2D(Spectrum_2x_bi,LengthThres);
% SE=strel('rectangle',ComponentClose);
% Spectrum_2x_bi_clean=imclose(Spectrum_2x_bi_clean_raw,SE);
% [~,W]=size(Spectrum_2x_bi_clean);
% Spectrum_2x_bi_clean_all=[zeros(149,W);Spectrum_2x_bi_clean];
% Spectrum_2x_bi_clean_all_3T2=imresize(Spectrum_2x_bi_clean_all,[200 W]);
% Spectrum_2x_bi_clean_new=Spectrum_2x_bi_clean;
% Spectrum_2x_bi_clean_new(1:51,:)=Spectrum_2x_bi_clean(1:51,:)+Spectrum_2x_bi_clean_all_3T2(150:200,:);
CC_Spectrum = bwconncomp(Spectrum_2x_bi_clean);
%% Find largest CC
if CC_Spectrum.NumObjects>0
    for CCcnt=1:CC_Spectrum.NumObjects
        lst=CC_Spectrum.PixelIdxList{CCcnt};
        L(CCcnt)=sum(Spectrum_2x(lst));
    end
    [~,CCidx]=max(L);
    lst=CC_Spectrum.PixelIdxList{CCidx};
    if mean(Spectrum_2x(lst))<SignalZscoreThreshold
        StartTime=0;
        EndTime=0;
    else
        [~,StartTime]=ind2sub(CC_Spectrum.ImageSize,min(lst));
        [~,EndTime]=ind2sub(CC_Spectrum.ImageSize,max(lst));
    end
else
    StartTime=0;
    EndTime=0;
end
