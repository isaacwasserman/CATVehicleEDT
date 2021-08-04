function [u] = lon_vel(R,r)
%enter (R,r)
%R=meters, lateral coordinate of C (center of velocity)
%r=yaw rate
%u=longitudinal velocity
u=R.*r;
end

