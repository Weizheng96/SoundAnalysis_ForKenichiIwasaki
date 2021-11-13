function TrackGroup=IterativelyShortestDistanceCircle(BoutSpectrum,x2,startIdx)
%% find start and end time
[StartTime,EndTime]=GetStartAndEndTime(Spectrum_2x,BoutIdx_fore);
BoutSpectrum=Spectrum_2x(:,StartTime:EndTime);
%% 5 connection
min_amp=1;

wmap_reciprocal=1./max(BoutSpectrum,min_amp);
[H,W]=size(BoutSpectrum);
wmap=wmap_reciprocal.^2;

% wmap(PeakMap)=wmap_reciprocal(PeakMap);

s=1:H*(W-1);
s_matrix=reshape(1:H*W,H,W);

s0=zeros(1,H);              % Source to first column
s1=s;                       % UP 1->2   (1->151)
s2=s;                       % Down 2->1 (151->1)
s3=s;                       % Right
s4=H*(W-1)+1:H*W;           % Last colum to Sink
s5=s;                       % Up Right 1->2
s6=s;                       % Down Right 2->1
s7=s_matrix(x2,1:end-1);    % Up 2->3   (51->151)
s8=s_matrix(x2,1:end-1);    % Down 3->2 (151->51)
s9=s_matrix(end,1:end-1);
s10=s_matrix(end,1:end-1);
s_all=[s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10]+1;

t0=(1:H);
t1=reshape([s_matrix(end,1:end-1);s_matrix(1:end-1,1:end-1)],1,[]);
t2=reshape([s_matrix(2:end,1:end-1);s_matrix(1,1:end-1)],1,[]);
t3=reshape(s_matrix(:,2:end),1,[]);
t4=(H*W+1)*ones(1,H);
t5=reshape([s_matrix(end,2:end);s_matrix(1:end-1,2:end)],1,[]);
t6=reshape([s_matrix(2:end,2:end);s_matrix(1,2:end)],1,[]);
t7=s_matrix(end,1:end-1);
t8=s_matrix(end,2:end);
t9=s_matrix(x2,1:end-1);
t10=s_matrix(x2,2:end);
t_all=[t0,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10]+1;

w0=wmap(:,1)';
w1=reshape([wmap(end,1:end-1);wmap(1:end-1,1:end-1)],1,[]);
w2=reshape([wmap(2:end,1:end-1);wmap(1,1:end-1)],1,[]);
w3=reshape(wmap(:,2:end),1,[]);
w4=zeros(1,H);
w5=reshape([wmap(end,2:end);wmap(1:end-1,2:end)],1,[])*sqrt(2);
w6=reshape([wmap(2:end,2:end);wmap(1,2:end)],1,[])*sqrt(2);
w7=wmap(end,1:end-1);
w8=wmap(end,2:end);
w9=wmap(x2,1:end-1);
w10=wmap(x2,2:end);
w_all=[w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10];

G = digraph(s_all,t_all,w_all);
[P,~] = shortestpath(G,1,H*W+2);
P_real=P(2:end-1)-1;
[I,J]=ind2sub([H,W],P_real);
clear("G","P","P_real");

clearvars -except I J BoutSpectrum x2 startIdx PeakMap H W;
%%
if startIdx==-1
    figure;
    ax(1)=subplot(2,1,1);
    imagesc(Spectrum_2x);
    ax(2)=subplot(2,1,2);
    imagesc(Spectrum_2x);
    hold on;
    linkaxes(ax,'xy');
    startIdx=0;
end
%%
track=[J+StartTime-1;I];
tracks=GetTracks(track,x2);
TrackGroup={tracks};
track=tracks{1};
plot(track(1,:),track(2,:),'r','LineWidth',3);
pause(1);
%%
Boundary=removeRegion(BoutSpectrum,I,J,x2);

BoutSpectrum_new=BoutSpectrum;
BoutSpectrum_new(Boundary)=0;
Spectrum_2x_sub=Spectrum_2x;
Spectrum_2x_sub(:,StartTime:EndTime)=BoutSpectrum_new;

% SampleNumber=sum(BoutSpectrum_new~=0);
Spectrum_2x_sub=mean(BoutSpectrum_new);
%%
BoutIdx_back=AmpAlongTime_sub>2;
LengthThres=10;
BoutIdx_back=RemoveComponentSmallerThan(BoutIdx_back,LengthThres);
% subplot(2,1,1)
% imagesc(BoutSpectrum_new)
% subplot(2,1,2)
% plot(BoutIdx_back)
%%
CC_back_sub = bwconncomp(BoutIdx_back);
BoutIdx_fore=false(size(BoutIdx_back));

for boutCnt=1:CC_back_sub.NumObjects
    lst=CC_back_sub.PixelIdxList{boutCnt};
    if length(lst)>20
        BoutIdx_fore(lst)=true;
    end
end
CC_BoutFore_sub=bwconncomp(BoutIdx_fore);


if CC_BoutFore_sub.NumObjects>0
    for SubBoutCnt=1:CC_BoutFore_sub.NumObjects
        SubLst=CC_BoutFore_sub.PixelIdxList{SubBoutCnt};
        TrackGroup_sub=IterativelyShortestDistanceCircle(BoutSpectrum_new(:,SubLst),x2,SubLst(1)+startIdx-1);
        TrackGroup=[TrackGroup,TrackGroup_sub];
    end
end


end