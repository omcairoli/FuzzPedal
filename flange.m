% Flange effect function created by Oscar Cairoli and Paul Pacis
function [Y]=flange(X,FS,power)
   
lag = round(power*FS/10000);                          
n = 1 : length(X);                                          
z = zeros(lag,1);                                        
Y = [z;X];                                                     
theta = 2 * pi / round(FS*power/10);                       
lag = lag - round((lag/2) * (1-cos(theta*n)));    
                                                                
Y = Y(n) + Y(n+lag);                                      
Y = Y * max(abs(X))/max(abs(Y));                                

