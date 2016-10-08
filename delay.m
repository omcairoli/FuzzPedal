% Delay effect function created by Oscar Cairoli and Paul Pacis
function [Y]=delay(X,FS,att,d)
    
delay = round(d*FS/1000);
n = 1 : length(X)+delay; 
R = zeros(delay,1);
X = [X ; R];
Z = [R ; att * X];
Y(n) = X(n) + Z(n);
Y = Y * max(abs(X))/max(abs(Y));