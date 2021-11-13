function bout_Idx_smooth=smooth_order(bout_Idx,rds,ratio)
rds=round(rds);
L=length(bout_Idx);
bout_Idx_smooth=false(size(bout_Idx));
for i=1:L
    start_idx=max(i-rds,1);
    end_idx=min(i+rds,L);
    thres=(end_idx-start_idx)*ratio;
    bout_Idx_smooth(i)=sum(bout_Idx(start_idx:end_idx))>thres;
end
end