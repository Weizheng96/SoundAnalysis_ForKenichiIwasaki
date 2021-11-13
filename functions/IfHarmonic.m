CC_bout_removeShort=bwconncomp(bout_Idx);

    each_idx=CC_bout_removeShort.PixelIdxList{i};
    if length(each_idx)<Fs
        sound_bout=zeros(Fs,1);
        sound_bout(1:length(each_idx))=y(each_idx);
    else
        sound_bout=y(each_idx);
    end
    [sound_bout_Sprectrum,f,freUint]=FFTparameter(sound_bout,Fs);
    sound_bout_Sprectrum=smooth(sound_bout_Sprectrum,100);
    f_max_idx=max(find(f<=max_HZ));
    f_min_idx=min(find(f>=min_HZ));
    f_max_candidate=max(find(f<=FunRange(2)));
    f_min_candidate=min(find(f>=FunRange(1)));
    
    f_candidate=f(f_min_candidate:f_max_candidate);
    
    sound_bout_Sprectrum_truncated=sound_bout_Sprectrum(1:f_max_idx);
    sound_bout_Sprectrum_truncated(1:f_min_idx-1)=nan;
    f_truncated=f(1:f_max_idx);
    
    F0_candidate=zeros(size(f_min_candidate:f_max_candidate));
    AmpLevel=zeros(size(F0_candidate));
    for candidate_idx_cnt=f_min_candidate:f_max_candidate
        F0_candidate(candidate_idx_cnt-f_min_candidate+1)=f(candidate_idx_cnt);
        candidate_idx_cnt_times=candidate_idx_cnt:candidate_idx_cnt:f_max_idx;
        AmpLevel(candidate_idx_cnt-f_min_candidate+1)=nanmean(sound_bout_Sprectrum(candidate_idx_cnt_times));
        
    end
    
    subplot(2,1,1);
    plot(f_truncated,sound_bout_Sprectrum_truncated)
    subplot(2,1,2);
    plot(F0_candidate,AmpLevel);
    
