function truck_collection=track_by_e(distLimit,alpha,CC_bout,peak_map,TIME_LEN,stepUint)

bout_t=zeros(CC_bout.NumObjects,2);
for bout_cnt=1:CC_bout.NumObjects
    bout_t(bout_cnt,1)=ceil(min(CC_bout.PixelIdxList{bout_cnt}/stepUint));
    bout_t(bout_cnt,2)=ceil(max(CC_bout.PixelIdxList{bout_cnt}/stepUint));
end

truck_collection=cell(CC_bout.NumObjects,1);
for bout_cnt=1:CC_bout.NumObjects
    
    if max(peak_map(:,bout_t(bout_cnt,1):bout_t(bout_cnt,2)),[],'all')>=0
        track_list=nan(20,TIME_LEN);
        for t=bout_t(bout_cnt,1):bout_t(bout_cnt,2)-1
            peak_now=(find(peak_map(:,t)>0));
            peak_next=(find(peak_map(:,t+1)>0));

            if t==bout_t(bout_cnt,1)
                peak_record=peak_now;
                track_list(1:length(peak_now),t)=peak_now;
            end

            avaliable_peak=true(size(peak_record));

            for peak_cnt=1:length(peak_next)
                [dist,record_idx]=min(abs(peak_record(avaliable_peak)-peak_next(peak_cnt)));
                valid_idx=find(avaliable_peak==true);
                real_idx=valid_idx(record_idx);
                if dist<distLimit
                    peak_record(real_idx)=alpha*peak_next(peak_cnt)+(1-alpha)*peak_record(real_idx);
                    track_list(real_idx,t+1)=peak_next(peak_cnt);
                    avaliable_peak(record_idx)=false;
                else
                    peak_record=[peak_record;peak_next(peak_cnt)];
                    track_list(length(peak_record),t+1)=peak_next(peak_cnt);
                    avaliable_peak=[avaliable_peak;false];
                end

            end

        end
        track_num=min(find(all(isnan(track_list),2)))-1;
        track_list=track_list(1:track_num,:);
        track_list(track_list==0)=nan;
    else
        track_list=nan;
    end
    
%     [track_list_sort,idx_sort]=sort(nanmean(track_list,2));
%     combine_flag=zeros(length(track_list_sort)-1,1);
%     min_peak_dist=100;
%     for peak_sort_cnt=1:length(track_list_sort)-1
%         lower_dist=track_list_sort(peak_sort_cnt+1)-track_list_sort(peak_sort_cnt);
%         if lower_dist<min_peak_dist
%             combine_flag(peak_sort_cnt)=1;
%         end
%     end
%     CC_peaks=bwconncomp(combine_flag);
%     
%     for CC_cnt=1:CC_peaks.NumObjects
%         lst=CC_peaks.PixelIdxList{CC_cnt};
%         num_cc_peaks=length(lst);
%         track_list(lst(1),:)=nanmean(track_list(lst(1):lst(num_cc_peaks)+1,:));
%         track_list(lst(1)+1:lst(num_cc_peaks)+1,:)=nan;
%     end
%     track_list=track_list(~isempty(track_list));


    [~,idx_sort]=sort(nanmean(track_list,2));
    track_list=track_list(idx_sort,:);
    truck_collection{bout_cnt}=track_list;
    
end

end