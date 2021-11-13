function peak_map=getPeaksAlongTime(SpectrumAlongTime,bout_Idx_short)

vis=false;

[FEW_LEN,TIME_LEN]=size(SpectrumAlongTime);

%%
peak_map=zeros(size(SpectrumAlongTime));
for t=1:TIME_LEN
    if bout_Idx_short(t)==1
        
        if mod(t,100)==0&&vis==true
            plot(SpectrumAlongTime(:,t));
        end
        
        [pks,locs] = findpeaks(SpectrumAlongTime(:,t));
        [pks_sort,idx]=sort(pks,'descend');
        locs_sort=locs(idx);
        locs_sort_dif = padarray(locs_sort,[0 length(locs_sort)-1],'replicate','post');
        locs_sort_dif=abs(locs_sort_dif-locs_sort');
        min_fs_dist=150;
        locs_sort_removal=(locs_sort_dif<min_fs_dist).*(~triu(ones(size(locs_sort_dif))));
        locs_keep=find(sum(locs_sort_removal,2)==0);
        
        if mod(t,100)==0&&vis==true
            hold on;
            scatter(locs_sort(locs_keep),pks_sort(locs_keep));
            hold off;
            title(t/100);
            ylim([0 0.002]);
            pause(0.2);
        end   
        
        peak_map(locs_sort(locs_keep),t)=1;
        sprctrum_smooth=smooth(SpectrumAlongTime(:,t),20);
        curv_region=curva1d(sprctrum_smooth)>0;
        
        peak_map(:,t)=peak_map(:,t).*curv_region;
    end
end

%%
if vis==true
    ax1=subplot(1,2,1);
    imagesc(SpectrumAlongTime);
    ax2=subplot(1,2,2);
    imagesc(peak_map)
    linkaxes([ax1 ax2],'xy');
end


end