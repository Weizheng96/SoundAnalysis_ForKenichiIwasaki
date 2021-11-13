function [parameters_new,RMSEachPeak_new,TrackGroup_adjusted_new]=GetParameters(TrackGroup_adjusted,SpectrumAlongTime_normalize,RMS)
% colorSequence=["r","m","g","w"];
% imagesc(SpectrumAlongTime_normalize);
% hold on;
global max_HZ_for_search;
global higherSignalZscoreThreshold;
global stepTime_track;
parameters=[];
%% find lowest fundamental frequency
FumFre_min=max_HZ_for_search;
for TrackCnt=1:length(TrackGroup_adjusted)
    ThisTrackFum=TrackGroup_adjusted{TrackCnt};
    FumFre=min(ThisTrackFum(2,:));
    if FumFre_min>FumFre
        FumFre_min=FumFre;
    end
end
global max_peak_num;
max_peak_num=ceil(max_HZ_for_search/FumFre_min);
RMSEachPeak=zeros(length(TrackGroup_adjusted),max_peak_num);

%% search higher peaks
for TrackCnt=1:length(TrackGroup_adjusted)
    ThisTrackFum=TrackGroup_adjusted{TrackCnt};
    Time=ThisTrackFum(1,:); FumFre=ThisTrackFum(2,:);
    peakNum=0;
    for peakCnt=1:max_peak_num
        ThisFre=round(FumFre*peakCnt);
        if max(ThisFre)>max_HZ_for_search
            break;
        end
        idx=sub2ind(size(SpectrumAlongTime_normalize),ThisFre,Time);
        PeakMeanZ=mean(SpectrumAlongTime_normalize(idx));
        if PeakMeanZ>higherSignalZscoreThreshold % || peakCnt==1
%             plot(Time,ThisFre,colorSequence(mod(TrackCnt,length(colorSequence))+1)...
%                 ,'LineWidth',3);
            RMSEachPeak(TrackCnt,peakCnt)=mean(RMS(idx));
            peakNum=peakNum+1;
        else
%             RMSEachPeak(TrackCnt,peakCnt)=nan;
        end
    end
    parameters(TrackCnt,1)=Time(1)*stepTime_track;% start time
    parameters(TrackCnt,2)=Time(end)*stepTime_track;% end time
    parameters(TrackCnt,3)=(Time(end)-Time(1))*stepTime_track;% duration
    parameters(TrackCnt,4)=peakNum; % peak number
    parameters(TrackCnt,5)=mean(FumFre); % F0 average;
    parameters(TrackCnt,6)=std(FumFre); % F0 std
    idx_vertical=~((Time(2:end)-Time(1:end-1))==0);
    parameters(TrackCnt,7)=mean(abs(gradient(FumFre(idx_vertical))))*stepTime_track; %F0 speed
    parameters(TrackCnt,8)=max(FumFre)-FumFre(1); %F0 max-start
    parameters(TrackCnt,9)=max(FumFre)-FumFre(end); %F0 max-end
end
if length(parameters)>0
    [~,sequence]=sort(parameters(:,1));

parameters_new=parameters(sequence,:);
RMSEachPeak_new=RMSEachPeak(sequence,:);
TrackGroup_adjusted_new=cell(size(TrackGroup_adjusted));
for TrackCnt=1:length(TrackGroup_adjusted)
    TrackGroup_adjusted_new{TrackCnt}=TrackGroup_adjusted{sequence(TrackCnt)};%% error!!!!
end

else
    disp("No sound Bout detected");
    return;
end

end