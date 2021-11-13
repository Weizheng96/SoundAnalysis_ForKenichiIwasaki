function BoutIdx=RemoveComponentSmallerThan(BoutIdx,LengthThres)
CC = bwconncomp(BoutIdx);

for CCcnt=1:CC.NumObjects
    lst=CC.PixelIdxList{CCcnt};
    if length(lst)<LengthThres
        BoutIdx(lst)=false;
    end
end

end