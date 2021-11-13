function Distortion=EstimateDistortion(track_collection)

Distortion.AlongTime=cell(size(track_collection));
Distortion.EachBout=cell(size(track_collection));
Distortion.meanofAllTrackAlongTime=cell(size(track_collection));

for bout_cnt=1:length(track_collection)
    bout=track_collection{bout_cnt};
    
    [Distortion.AlongTime{bout_cnt},~]=gradient(bout);
    Distortion.AlongTime{bout_cnt}=abs(Distortion.AlongTime{bout_cnt});
    
    
    Distortion.EachBout{bout_cnt}=nanstd(bout,0,2);
    Distortion.meanofAllTrackAlongTime{bout_cnt}=nanmean(Distortion.AlongTime{bout_cnt});

end

end