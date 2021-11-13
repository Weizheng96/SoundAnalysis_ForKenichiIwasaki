function F0AlongTime=GetF0FromPeaks(track_collection,Isharmonic,bout_Idx_short,smoothUnit)

if isempty(find(Isharmonic==1,1))
    fprintf("\nerror! No harmonic bouts!\n");
end
F0AlongTime=zeros(size(track_collection{find(Isharmonic==1,1)}(1,:)));
CC_bout_short=bwconncomp(bout_Idx_short);



for bout_cnt=1:length(track_collection)

    if Isharmonic(bout_cnt)
        
        idx=CC_bout_short.PixelIdxList{bout_cnt};
        
%         x=[track_collection{bout_cnt}(1,:)/round(nanmean(track_collection{bout_cnt}(1,:))/210);...
%             track_collection{bout_cnt}(2,:)/round(nanmean(track_collection{bout_cnt}(2,:))/210);...
%             track_collection{bout_cnt}(3,:)/round(nanmean(track_collection{bout_cnt}(3,:))/210);...
%             track_collection{bout_cnt}(4,:)/round(nanmean(track_collection{bout_cnt}(4,:))/210)];
        
        candi=nanmean(track_collection{bout_cnt}(1,:));  
        candi=candi/round(candi/220);
%         candi=220;
        
        x=[...
            track_collection{bout_cnt}(2,:)/round(nanmean(track_collection{bout_cnt}(2,:))/candi);...
            track_collection{bout_cnt}(3,:)/round(nanmean(track_collection{bout_cnt}(3,:))/candi);...
            track_collection{bout_cnt}(4,:)/round(nanmean(track_collection{bout_cnt}(4,:))/candi)];

        xx_nan=nanmedian(x,1);
        xx=xx_nan;
        for t_cnt=idx(1):idx(end)
            start_idx=max(t_cnt-smoothUnit,idx(1));
            end_idx=min(t_cnt+smoothUnit,idx(end));
            xx(t_cnt)=nanmedian(xx_nan(start_idx:end_idx));
        end
        
        is_all_nan=all(isnan(x),1);
        xx(is_all_nan)=nan;
        
        F0AlongTime(idx)=xx(idx);
        
        
        
%         plot(x')
%         hold on;
%         plot(F0AlongTime)
%         legend
%         plot(track_collection{bout_cnt}')
    end
end

end