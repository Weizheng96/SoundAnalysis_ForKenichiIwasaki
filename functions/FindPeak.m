function Track_new=FindPeak(Track_new,wmap,StartFreIdx)
I=Track_new(2,:);
Time=Track_new(1,:);

FreTrack{1}=(I+StartFreIdx)*2;
FreTrack{2}=I+StartFreIdx;
FreTrack{3}=(I+StartFreIdx)*2/3;

Score=zeros(3,4);
for CandidateCnt=1:3
    ThisTrack=FreTrack{CandidateCnt};
    for PeakCnt=1:4
        ThisFre=min(round(ThisTrack*PeakCnt),size(wmap,1));
        idx=sub2ind(size(wmap),ThisFre,Time);
        Score(CandidateCnt,PeakCnt)=mean(wmap(idx));
    end
end

if sum(Score(1,3:4))<10*(Score(2,1)+Score(2,3))
    Score(1,:)=0;
end

[~,PeakCnt]=max(sum(Score,2));
Track_new(2,:)=FreTrack{PeakCnt};

end