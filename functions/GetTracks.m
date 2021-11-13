function Track_new=GetTracks(track,x2)
I=track(2,:);
DIff=I(2:end)-I(1:end-1);
TransLocation=find(abs(DIff)>1);
StartFreIdx=3*(x2-1)-1;
global wmap;
if isempty(TransLocation) % no transfer point
    Track_new=FindPeak(track,wmap,StartFreIdx);
else                      % with transfer point
    TransOld=0;
    Track_new=[];
    for TransCnt=1:length(TransLocation)
        TransNew=TransLocation(TransCnt);
        Track_part=track(:,TransOld+1:TransNew);
        Track_new_part=FindPeak(Track_part,wmap,StartFreIdx);
        Track_new=[Track_new,Track_new_part];
        TransOld=TransNew;
    end
    Track_part=track(:,TransOld+1:end);
    Track_new_part=FindPeak(Track_part,wmap,StartFreIdx);
    Track_new=[Track_new,Track_new_part];
    
end
Track_new(2,:)=Track_new(2,:)-StartFreIdx;
end