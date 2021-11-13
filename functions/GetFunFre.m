function [fundFre,min_fundfre,max_fundfre]=GetFunFre(y,Fs,rt,FunRange,vis)
%%
min_HZ=200;
max_HZ=2000;
T = 1/Fs;             % Sampling period       
L = length(y);        % Length of signal
t = (0:L-1)*T;        % Time vector

%% fft
Y=fft(y);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
freUint=f(2);
%% remove out of range
min_f=round(min_HZ/freUint);
max_f=round(max_HZ/freUint);

P1_signal=P1;
P1_signal(1:min_f)=0;
P1_max=max(P1_signal);



%% remove noise

P1_smooth=smooth(P1_signal,ceil(1000*(L/4800000)));
[N,edges] = histcounts(P1_smooth(min_f:max_f),100);
[~,I] = max(N);
base=edges(I+1);
P1_smooth_2=P1_smooth-base;
P2_max=max(P1_smooth_2);

idx=P1_smooth_2>(P2_max/rt);
rds=max(floor(10/freUint),1);
idx_close=false(size(idx));
for i=min_f:max_f
    idx_close(i)=sum(idx(i-rds:i+rds))>rds/2;
end


P1_signal2=zeros(size(P1_signal));
P1_signal2(idx_close)=P1_smooth(idx_close);
%% regularize
P1_pure=zeros(size(P1));
Idx=idx_close;
CC=bwconncomp(Idx);

FreqAmpMap=zeros(2,CC.NumObjects);

for i=1:CC.NumObjects
    lst=CC.PixelIdxList{i};
    [~,lst_c]=max(P1(lst));
    ap=sum(P1(lst));

    
    FreqAmpMap(:,i)=[lst(lst_c)*freUint;ap];
end

PeakMap=[];
c_idx=[];
ValidReg=[];
k=0;
for i=1:CC.NumObjects
    if FreqAmpMap(2,i)>max(FreqAmpMap(2,:))/10
        PeakMap=[PeakMap FreqAmpMap(:,i)];
        c_idx=[c_idx i];
        ValidReg=[ValidReg [min(CC.PixelIdxList{i})*freUint;max(CC.PixelIdxList{i})*freUint]];
        k=k+1;
        
        P1_pure(CC.PixelIdxList{i})=P1_signal2(CC.PixelIdxList{i});
    end
end

%% calculate the fundamental frequency

fundFreCandi=FunRange(1):freUint:FunRange(2);
FunAmpSum=zeros(size(fundFreCandi));
flag=true(size(fundFreCandi));
for i=1:length(flag)
    for j=1:k
        if floor(ValidReg(1,j)/fundFreCandi(i))==floor(ValidReg(2,j)/fundFreCandi(i))
            flag(i)=false;
            break;
        else
            idx=round(floor(ValidReg(2,j)/fundFreCandi(i))*fundFreCandi(i)/freUint);
            FunAmpSum(i)=FunAmpSum(i)+P1_pure(idx);
        end
    end
end
if isempty(find(flag==true))
    funFlag=0;
    if 0
        fprintf("\nNo Fundamental Frenquency\n");
    end
    fundFre=nan;
else
    funFlag=1;
    CC=bwconncomp(flag);
    flags=CC.PixelIdxList{end};
    [~,I]=max(FunAmpSum);
    fundFre=mean(fundFreCandi(I));
    if 0
        sentence2="\nThe fundamental frequency is:\t%fHZ\t(%fHZ~%fHZ)\nThe frequnency unit is:\t%fHZ\n";
        sent = sprintf(sentence2,fundFre,min(fundFreCandi(flags)),max(fundFreCandi(flags)),freUint);
        fprintf(sent);
    end
end
if nargout>1
    if isempty(find(flag==true))
        min_fundfre=nan;
        max_fundfre=nan;
    else
        min_fundfre=min(fundFreCandi(flags));
        max_fundfre=max(fundFreCandi(flags));
    end
end
%%
if vis==true
    figure;
    a1=subplot(4,1,1);
    t_axis=(1:L)./Fs;
    plot(t_axis,y);
    xlabel('t(s)');
    ylabel('X(t)') ;     
    title('signal with noise');

    a2=subplot(4,1,2);
    plot(f(1:max_f),P1_signal(1:max_f));
    xlabel('f (Hz)');
    ylabel('|P1(f)|');
    title('Single-Sided Amplitude Spectrum of truncated signal');

    a3=subplot(4,1,3);
    plot(f(1:max_f),P1_smooth(1:max_f));
    xlabel('f (Hz)');
    ylabel('|P1(f)|');
    title('Single-Sided Amplitude Spectrum (smoothed)');

    a4=subplot(4,1,4);
    plot(f(1:max_f),P1_pure(1:max_f));
    if funFlag==1
        hold on;
        max_F=floor(ValidReg(2,end)/fundFre);
        fres=fundFre*(1:max_F);
        scatter(fres,P1_signal2(round(fres/freUint))-base,100,[1 0 0],'filled');
    end
    xlabel('f (Hz)');
    ylabel('|P1(f)|');
    title('Single-Sided Amplitude Spectrum with fundamental frequency');
    linkaxes([a2 a3 a4],'x')
end
end