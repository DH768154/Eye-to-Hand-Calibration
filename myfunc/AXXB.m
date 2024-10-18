function X = AXXB(As,Bs,varargin)

%% Get Rotation

% Optional Input: Calculation method (default method 2)
% 1. Park & Martin Method From ASBR Lecture
% 2. Quaternion Method From CIS Lecture
if nargin<3
    R_calc = RAXXRB(As(1:3,1:3,:),Bs(1:3,1:3,:),2);
else
    R_calc = RAXXRB(As(1:3,1:3,:),Bs(1:3,1:3,:),varargin{1});
end

%% Get Translation

P_calc = solveTx(As(1:3,1:3,:), As(1:3,4,:), Bs(1:3,4,:), R_calc);

X = R2T(R_calc,P_calc);

end

%%
function tx = solveTx( RA,tA, tB, RX )
% A*X = X*B, find Translation Part for X
% RA: 3x3xN Rotation
% tA,tB: 3x1xN 

sets = size(RA,3);

%%

lf  = mx3cat(RA-eye(3));
rt = pagemtimes(RX.*ones([1,1,sets]),tB)-tA;
rt = reshape(rt,[3*sets,1]);
tx = lf\rt;

end