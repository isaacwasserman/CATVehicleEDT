function [R] =lat_of_c(l,s,lr)
%enter (l,s)
%l=wheelbase 
%s=steering angle in degrees
%R=lateral coordinate of C (center of velocity)
%lr=rear axle to center of gravity
%R=atand(l./s);
R=sqrt(lr^2+l^2*cotd(s).^2);
end

