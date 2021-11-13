function TrackGroup=IterativelyShortestDistanceSub(BoutSpectrum,startIdx,PeakMap)

%% 5 connection

min_amp=1;

wmap_reciprocal=1./max(BoutSpectrum,min_amp);
[H,W]=size(BoutSpectrum);
wmap=wmap_reciprocal*10;

wmap(PeakMap)=wmap_reciprocal(PeakMap);

s=1:H*(W-1);
s_matrix=reshape(1:H*W,H,W);

s0=zeros(1,H);
s1=s;
s2=s;
s3=s;
s4=H*(W-1)+1:H*W;
% s_all=[s0,s1,s2,s3,s4]+1;
s5=s;
s6=s;
s_all=[s0,s1,s2,s3,s4,s5,s6]+1;

t0=1:H;
t1=reshape([s_matrix(end,1:end-1);s_matrix(1:end-1,1:end-1)],1,[]);
t2=reshape([s_matrix(2:end,1:end-1);s_matrix(1,1:end-1)],1,[]);
t3=reshape(s_matrix(:,2:end),1,[]);
t4=(H*W+1)*ones(1,H);
% t_all=[t0,t1,t2,t3,t4]+1;
t5=reshape([s_matrix(end,2:end);s_matrix(1:end-1,2:end)],1,[]);
t6=reshape([s_matrix(2:end,2:end);s_matrix(1,2:end)],1,[]);
t_all=[t0,t1,t2,t3,t4,t5,t6]+1;

w0=wmap(:,1)';
w1=reshape([wmap(end,1:end-1);wmap(1:end-1,1:end-1)],1,[]);
w2=reshape([wmap(2:end,1:end-1);wmap(1,1:end-1)],1,[]);
w3=reshape(wmap(:,2:end),1,[]);
w4=zeros(1,H);
% w_all=[w0,w1,w2,w3,w4];
w5=reshape([wmap(end,2:end);wmap(1:end-1,2:end)],1,[])*sqrt(2);
w6=reshape([wmap(2:end,2:end);wmap(1,2:end)],1,[])*sqrt(2);
w_all=[w0,w1,w2,w3,w4,w5,w6];

G = digraph(s_all,t_all,w_all);
[P,~] = shortestpath(G,1,H*W+2);
P_real=P(2:end-1)-1;
[I,J]=ind2sub([H,W],P_real);
track=[J+startIdx;I];
TrackGroup={track};

%%
%%
plot(J+startIdx,I,'r','LineWidth',3);
pause(1);
%%
I_remove=[];
J_remove=[];
for remIdx=-10:10
    J_remove=[J_remove,J];
    I_remove=[I_remove,I+remIdx];
end
I_remove=min(I_remove,H);
I_remove=max(I_remove,1);

BoutSpectrum_new=BoutSpectrum;
BoutSpectrum_new(sub2ind([H W],I_remove,J_remove))=0;
AmpAlongTime_sub=sum(BoutSpectrum_new)/80;
%%
BoutIdx_back=AmpAlongTime_sub>1.5;
CC_back_sub = bwconncomp(BoutIdx_back);
BoutIdx_fore=false(size(BoutIdx_back));

for boutCnt=1:CC_back_sub.NumObjects
    lst=CC_back_sub.PixelIdxList{boutCnt};
    if length(lst)>20
        BoutIdx_fore(lst)=true;
    end
end
CC_BoutFore_sub=bwconncomp(BoutIdx_fore);

% figure;
% ax(1)=subplot(2,1,1);
% imagesc(BoutSpectrum_new);
% ax(2)=subplot(2,1,2);
% AmpAlongTime_sub=sum(BoutSpectrum_new)/80;
% plot(AmpAlongTime_sub)
% hold on;
% plot(BoutIdx_fore*1.5);
% hold off;
% linkaxes(ax,'x');

if CC_BoutFore_sub.NumObjects>0
    for SubBoutCnt=1:CC_BoutFore_sub.NumObjects
        SubLst=CC_BoutFore_sub.PixelIdxList{SubBoutCnt};
        TrackGroup_sub=IterativelyShortestDistance(BoutSpectrum_new(:,SubLst),SubLst(1)+startIdx-1);
        TrackGroup=[TrackGroup,TrackGroup_sub];
    end
end

end