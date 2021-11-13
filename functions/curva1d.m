function y=curva1d(x)
y=2*x;

for cnt=1:length(x)
    if cnt==1
        y(cnt)=y(cnt)/2-x(2);
    elseif cnt==length(x)
        y(cnt)=y(cnt)/2-x(length(x)-1);
    else
        y(cnt)=y(cnt)-x(cnt-1)-x(cnt+1);
    end
end

end