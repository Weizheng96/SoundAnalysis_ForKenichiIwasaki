function Boundary=removeRegion(BoutSpectrum,I,J,x2)
min_amp=1;
[H,W]=size(BoutSpectrum);
wmap_reciprocal=1./max(BoutSpectrum,min_amp);
global signalRemovalGaussianFilter;
wmap=imgaussfilt(wmap_reciprocal,signalRemovalGaussianFilter);
% figure;imagesc(wmap);
BiMap=double(wmap_reciprocal>=1);
[~,Fy]=gradient(BiMap);
Fy=abs(Fy);

Boundary=false(size(BoutSpectrum));
Boundary_min=nan(size(1,W));
Boundary_max=nan(size(1,W));
%%
for t=1:W
    [~,locs] = findpeaks(wmap(:,t));
    idx=find(J==t);
    FreMax_Track=max(I(idx));
    FreMin_Track=min(I(idx));
    
    FreMin_local=max(locs(locs<FreMin_Track));
    if isempty(FreMin_local)
        FreMin_local=1;
    end
    FreMax_local=min(locs(locs>FreMax_Track));
    if isempty(FreMax_local)
        FreMax_local=H;
    end
    
    idx_gradient=find(Fy(:,t)>0);
    FreMin_gradient=max(idx_gradient(idx_gradient<FreMin_Track));
    if isempty(FreMin_gradient)
        FreMin_gradient=0;
    end
    FreMax_gradient=min(idx_gradient(idx_gradient>FreMin_Track));
    if isempty(FreMax_gradient)
        FreMax_gradient=H;
    end
    
    Boundary_min(t)=max(FreMin_local,FreMin_gradient);
    Boundary_max(t)=min(FreMax_local,FreMax_gradient);
    
    Boundary(Boundary_min(t):Boundary_max(t),t)=true;
end

%%
% figure;
% imagesc(Boundary)
% hold on;
% plot(J,I,'r','LineWidth',3);
%%
xd=x2-1;
idx_1=find(Boundary_min<x2);
idx_2=find(Boundary_max>1.5*xd);
%%
if ~isempty(idx_1)
    I_1=(I(idx_1)+3*xd)*1.5-3*xd;
    J_1=J(idx_1);
    
    for t=1:W
        [~,locs] = findpeaks(wmap(:,t));
        idx=find(J_1==t);
        if ~isempty(idx)
            FreMax_Track=max(I_1(idx));
            FreMin_Track=min(I_1(idx));

            FreMin_local=max(locs(locs<FreMin_Track));
            if isempty(FreMin_local)
                FreMin_local=1;
            end
            FreMax_local=min(locs(locs>FreMax_Track));
            if isempty(FreMax_local)
                FreMax_local=H;
            end

            idx_gradient=find(Fy(:,t)>0);
            FreMin_gradient=max(idx_gradient(idx_gradient<FreMin_Track));
            if isempty(FreMin_gradient)
                FreMin_gradient=1;
            end
            FreMax_gradient=min(idx_gradient(idx_gradient>FreMin_Track));
            if isempty(FreMax_gradient)
                FreMax_gradient=H;
            end

            Boundary_min=max(FreMin_local,FreMin_gradient);
            Boundary_max=min(FreMax_local,FreMax_gradient);

            Boundary(Boundary_min:Boundary_max,t)=true;
        end
    end
end

%%
% figure;
% map=BoutSpectrum;
% map(Boundary)=-100;
% imagesc(map);
% hold on;
% plot(J,I,'r','LineWidth',3);

%%
if ~isempty(idx_2)
    I_2=(I(idx_2)+3*xd)*2/3-3*xd;
    J_2=J(idx_2);
    
    for t=1:W
        [~,locs] = findpeaks(wmap(:,t));
        idx=find(J_2==t);
        if ~isempty(idx)
            FreMax_Track=max(I_2(idx));
            FreMin_Track=min(I_2(idx));

            FreMin_local=max(locs(locs<FreMin_Track));
            if isempty(FreMin_local)
                FreMin_local=1;
            end
            FreMax_local=min(locs(locs>FreMax_Track));
            if isempty(FreMax_local)
                FreMax_local=H;
            end

            idx_gradient=find(Fy(:,t)>0);
            FreMin_gradient=max(idx_gradient(idx_gradient<FreMin_Track));
            if isempty(FreMin_gradient)
                FreMin_gradient=1;
            end
            FreMax_gradient=min(idx_gradient(idx_gradient>FreMin_Track));
            if isempty(FreMax_gradient)
                FreMax_gradient=H;
            end

            Boundary_min=max(FreMin_local,FreMin_gradient);
            Boundary_max=min(FreMax_local,FreMax_gradient);

            Boundary(Boundary_min:Boundary_max,t)=true;
        end
    end
end
end