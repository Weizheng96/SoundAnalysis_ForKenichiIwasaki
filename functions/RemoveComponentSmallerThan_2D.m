function BoutIdx=RemoveComponentSmallerThan_2D(BoutIdx,LengthThres)
CC = bwconncomp(BoutIdx);

for CCcnt=1:CC.NumObjects
    lst=CC.PixelIdxList{CCcnt};
    TimeLength=(max(lst)-min(lst))/CC.ImageSize(1);
    if TimeLength<LengthThres
        BoutIdx(lst)=false;
    end
end
    
end