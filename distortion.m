% Distortion effect function created by Oscar Cairoli and Paul Pacis
function [Y] = distortion(X,FS,A,overdrive)

limit = (overdrive/100);
Y = 1:length(X);

for i = 1:numel(X)
    if X(i) > limit*X(i)
        Y(i) = limit*X(i);
    elseif X(i) < (-1)*limit*X(i) 
            Y(i) = (-1)*limit*X(i);
    else
        Y(i) = X(i);
    end
end
