function Isharmonic=OverlappingSpectrum(SpectrumAlongTime_normalize,bout_Idx_short,overlap_range)



%%
SpectrumAlongTime_normalize_r=cell(4,1);

SpectrumAlongTime_normalize_r{1}=SpectrumAlongTime_normalize;
SpectrumAlongTime_normalize_r{2}=imresize(SpectrumAlongTime_normalize,[1000 10000]);
SpectrumAlongTime_normalize_r{3}=imresize(SpectrumAlongTime_normalize,[667 10000]);
SpectrumAlongTime_normalize_r{4}=imresize(SpectrumAlongTime_normalize,[500 10000]);


SpectrumAlongTime_normalize_r{1}=SpectrumAlongTime_normalize_r{1}(overlap_range,:);
SpectrumAlongTime_normalize_r{2}=SpectrumAlongTime_normalize_r{2}(overlap_range,:);
SpectrumAlongTime_normalize_r{3}=SpectrumAlongTime_normalize_r{3}(overlap_range,:);
SpectrumAlongTime_normalize_r{4}=SpectrumAlongTime_normalize_r{4}(overlap_range,:);

% SpectrumAlongTime_normalize_r1=SpectrumAlongTime_normalize_r1/sum(SpectrumAlongTime_normalize_r1(:));
% SpectrumAlongTime_normalize_r2=SpectrumAlongTime_normalize_r2/sum(SpectrumAlongTime_normalize_r2(:));
% SpectrumAlongTime_normalize_r3=SpectrumAlongTime_normalize_r3/sum(SpectrumAlongTime_normalize_r3(:));
% SpectrumAlongTime_normalize_r4=SpectrumAlongTime_normalize_r4/sum(SpectrumAlongTime_normalize_r4(:));

% for peak_cnt=1:4
%     SpectrumAlongTime_normalize_r{peak_cnt}(SpectrumAlongTime_normalize_r{peak_cnt}<2)=0;
% end


bout_overlapping=zeros(size(bout_Idx_short));
r_n=cell(4,1);
r_nanmean=cell(4,1);

CC_bout_idx_short=bwconncomp(bout_Idx_short>0);

Isharmonic=zeros(CC_bout_idx_short.NumObjects,1);
for cc_cnt=1:CC_bout_idx_short.NumObjects
    lst=CC_bout_idx_short.PixelIdxList{cc_cnt};
    
    for peak_cnt=1:4
        r_n{peak_cnt}=SpectrumAlongTime_normalize_r{1}(:,lst);
        r_n{peak_cnt}=sqrt(max(r_n{peak_cnt},0));
        r_n{peak_cnt}=r_n{peak_cnt}/max(r_n{peak_cnt},[],'all');
%         r_n{peak_cnt}=mat2gray(r_n{peak_cnt});
    end 
    
%     for peak_cnt=1:4
%         r_n{peak_cnt}(isnan(r_n{peak_cnt}))=0;
%     end
    
%     for peak_cnt=3:4
%         r_n{peak_cnt}=histeq(r_n{peak_cnt},imhist(r_n{2}));
%     end
    
%     for peak_cnt=1:4
%         r_n{peak_cnt}(r_n{peak_cnt}==0)=nan;
%     end
    
    for peak_cnt=1:4
        r_nanmean{peak_cnt}=nanmean(r_n{peak_cnt},'all');
    end
    
    SpectrumAlongTime_normalize_lap=r_n{2}.*r_n{3}.*r_n{4};
    
    normal_factor=r_nanmean{2}.*r_nanmean{3}.*r_nanmean{4};
    
    overlappingScore=nanmean(SpectrumAlongTime_normalize_lap/normal_factor,'all');
    bout_overlapping(lst)=overlappingScore;
    Isharmonic(cc_cnt)=overlappingScore>1;
end

%%
% figure;
% ax1=subplot(3,1,1);
% imagesc(SpectrumAlongTime_normalize)
% title("Spectrum along time")
% 
% ax2=subplot(3,1,2);
% plot(bout_Idx_short>0);
% title("all sound bout")
% ylim([0 2])
% 
% ax3=subplot(3,1,3);
% plot((bout_overlapping));
% title("overlapping score");
% ylim([-10 inf]);
% linkaxes([ax1 ax2 ax3],'x');

