function TrackGroup_adjusted_new=GetAdjustedTrackGroup(TrackGroup,StartFre)
TrackGroup_adjusted=cell(size(TrackGroup));
for TrackCnt=1:length(TrackGroup)
    Track=TrackGroup{TrackCnt};
    Track(2,:)=Track(2,:)+StartFre;
    TrackGroup_adjusted{TrackCnt}=Track;
end
DistMatrix=zeros(length(TrackGroup));
for TrackCnt=1:length(TrackGroup)
    for TrackCnt2=1:length(TrackGroup)
        Track=TrackGroup_adjusted{TrackCnt};
        Track2=TrackGroup_adjusted{TrackCnt2};
        StartTime=Track(1,1);
        EndTime2=Track2(1,end);
        DistMatrix(TrackCnt,TrackCnt2)=EndTime2-StartTime;
    end
end
RootIdxLst=1:length(TrackGroup);
global IntervalThres;
for TrackCnt=1:length(TrackGroup)
    SubD=-DistMatrix(TrackCnt,:);
    SubD(SubD<0)=inf;
    [M,I]=min(SubD);
    if M<IntervalThres&&M>0
        RootIdx=RootIdxLst(I);
        TrackGroup_adjusted{RootIdx}=[TrackGroup_adjusted{RootIdx} TrackGroup_adjusted{TrackCnt}];
        RootIdxLst(RootIdxLst==TrackCnt)=RootIdx;
    end
end
TrackLst_new=unique(RootIdxLst);
TrackGroup_adjusted_new=cell(size(TrackLst_new));
for TrackCnt=1:length(TrackLst_new)
    TrackGroup_adjusted_new{TrackCnt}=TrackGroup_adjusted{TrackLst_new(TrackCnt)};
end

end