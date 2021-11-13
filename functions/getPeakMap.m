function PeakMap=getPeakMap(BoutSpectrum)

PeakMap=false(size(BoutSpectrum));

for TimeCnt=1:size(BoutSpectrum,2)
    [~,locs] = findpeaks(BoutSpectrum(:,TimeCnt));
    PeakMap(locs,TimeCnt)=true;
end

end