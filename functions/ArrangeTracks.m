function TrackGroup_new=ArrangeTracks(TrackGroup,TimeRange,HighFreRange,SpectrumAlongTime_normalize)
StartTimeIdx=TimeRange(1)-1;
StartFreIdx=(HighFreRange/2-1);
wmap=imgaussfilt(SpectrumAlongTime_normalize,1);
TrackGroup_new=cell(size(TrackGroup));

for TrackCnt=1:length(TrackGroup)

    Tracks=TrackGroup{TrackCnt};
    PossiblePeaks=Tracks{2};
    Track=Tracks{1};
    Track_new=Track;
    Track_new(1,:)=Track_new(1,:)+StartTimeIdx;
    if length(PossiblePeaks)==1 % Belong to peak 2
        Track_new(2,:)=Track_new(2,:)+StartFreIdx;
    else %Belong to 1/2/3
        Track_new=FindPeak(Track_new,wmap,StartFreIdx);
    end
    TrackGroup_new{TrackCnt}=Track_new;
end

end