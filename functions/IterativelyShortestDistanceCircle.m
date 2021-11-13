function TrackGroup=IterativelyShortestDistanceCircle(Spectrum_2x,x2,startIdx)
%% find start and end time
[StartTime,EndTime,Spectrum_2x_bi_clean]=GetStartAndEndTime(Spectrum_2x);
if StartTime==0
    TrackGroup={};
    return;
end
BoutSpectrum=Spectrum_2x(:,StartTime:EndTime);
ValidStartFre=find(Spectrum_2x_bi_clean(:,StartTime));
ValidEndFre=find(Spectrum_2x_bi_clean(:,EndTime));
%% 5 connection
min_amp=1;

wmap_reciprocal=1./max(BoutSpectrum,min_amp);
[H,W]=size(BoutSpectrum);
wmap=wmap_reciprocal.^2;

% wmap(PeakMap)=wmap_reciprocal(PeakMap);

s=1:H*(W-1);
s_matrix=reshape(1:H*W,H,W);

TransCost=1;

s0=zeros(size(ValidStartFre'));              % Source to first column
s1=s;                       % UP 1->2   (1->151)
s2=s;                       % Down 2->1 (151->1)
s3=s;                       % Right
s4=H*(W-1)+ValidEndFre';     % Last colum to Sink
s5=s;                       % Up Right 1->2
s6=s;                       % Down Right 2->1
s7=s_matrix(x2,1:end-1);    % Up 2->3   (51->151)
s8=s_matrix(x2,1:end-1);    % Down 3->2 (151->51)
s9=s_matrix(end,1:end-1);
s10=s_matrix(end,1:end-1);
s_all=[s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10]+1;

t0=ValidStartFre';
t1=reshape([s_matrix(end,1:end-1);s_matrix(1:end-1,1:end-1)],1,[]);
t2=reshape([s_matrix(2:end,1:end-1);s_matrix(1,1:end-1)],1,[]);
t3=reshape(s_matrix(:,2:end),1,[]);
t4=(H*W+1)*ones(size(s4));
t5=reshape([s_matrix(end,2:end);s_matrix(1:end-1,2:end)],1,[]);
t6=reshape([s_matrix(2:end,2:end);s_matrix(1,2:end)],1,[]);
t7=s_matrix(end,1:end-1);
t8=s_matrix(end,2:end);
t9=s_matrix(x2,1:end-1);
t10=s_matrix(x2,2:end);
t_all=[t0,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10]+1;

w0=wmap(ValidStartFre,1)';
w1=reshape([wmap(end,1:end-1)+TransCost;wmap(1:end-1,1:end-1)],1,[]);
w2=reshape([wmap(2:end,1:end-1);wmap(1,1:end-1)]+TransCost,1,[]);
w3=reshape(wmap(:,2:end),1,[]);
w4=zeros(size(t4));
w5=reshape([wmap(end,2:end)+TransCost;wmap(1:end-1,2:end)],1,[])*sqrt(2);
w6=reshape([wmap(2:end,2:end);wmap(1,2:end)+TransCost],1,[])*sqrt(2);
w7=wmap(end,1:end-1)+TransCost;
w8=wmap(end,2:end)+TransCost;
w9=wmap(x2,1:end-1)+TransCost;
w10=wmap(x2,2:end)+TransCost;
w_all=[w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10];

G = digraph(s_all,t_all,w_all);
[P,~] = shortestpath(G,1,H*W+2);
P_real=P(2:end-1)-1;
[I,J]=ind2sub([H,W],P_real);
%%
clear("G","P","P_real");
clearvars -except I J BoutSpectrum x2 startIdx PeakMap H W Spectrum_2x StartTime EndTime Spectrum_2x_bi_clean;
%%
% if startIdx==-1
%     figure;
%     ax(1)=subplot(3,1,1);
%     imagesc(Spectrum_2x);
%     ax(2)=subplot(3,1,2);
%     imagesc(Spectrum_2x);
%     hold on;
%     ax(3)=subplot(3,1,3);
%     imagesc(Spectrum_2x_bi_clean);
%     linkaxes(ax,'xy');
%     startIdx=0;
% end
%%
track=[J+StartTime-1;I];
track=GetTracks(track,x2);
TrackGroup={track};
%%
Boundary=removeRegion(BoutSpectrum,I,J,x2);

BoutSpectrum_new=BoutSpectrum;
BoutSpectrum_new(Boundary)=0;
Spectrum_2x_sub=Spectrum_2x;
Spectrum_2x_sub(:,StartTime:EndTime)=BoutSpectrum_new;
%%
% subplot(3,1,3);
% imagesc(Spectrum_2x_bi_clean);
% hold on;
% plot(track(1,:),track(2,:),'r','LineWidth',3);
% hold off;
% subplot(3,1,2);
% plot(track(1,:),track(2,:),'r','LineWidth',3);
% pause(1);
%%
TrackGroup_sub=IterativelyShortestDistanceCircle(Spectrum_2x_sub,x2,startIdx);
if ~isempty(TrackGroup_sub)
    TrackGroup=[TrackGroup,TrackGroup_sub];
end


end