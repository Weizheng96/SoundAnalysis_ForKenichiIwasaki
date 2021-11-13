function SoundBoutTable=getF0byTime(FunFreAlongTime,Idx,Fs,nan_idx)

SoundBoutTable=zeros(1,5);
L=length(nan_idx);
Total_idx=false(1,L);
Total_idx(Idx)=true;

Total_idx_full=false(1,L);
Total_idx_full(Idx)=true;

Total_idx(nan_idx)=false;
idx=Idx/Fs;
SoundBoutTable(1,1)=min(idx);
SoundBoutTable(1,2)=max(idx);
[N,edges]=histcounts(FunFreAlongTime(Total_idx));
[~,I]=max(N);
SoundBoutTable(1,3)=(edges(I)+edges(I+1))/2;
SoundBoutTable(1,4)=std(FunFreAlongTime(Total_idx));
SoundBoutTable(1,5)=length(find(Total_idx==true))/length(find(Total_idx_full==true));

sentence2="\nThe fundamental frequency is:\t%fHZ\n";
sent = sprintf(sentence2,SoundBoutTable(1,3));
fprintf(sent);

end