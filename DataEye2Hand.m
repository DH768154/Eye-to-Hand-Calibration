function [T_bh, T_s, X] = DataEye2Hand(N,varargin)

if nargin == 2
    nois = varargin{1};
else
    nois = [0,0];
end

%% Base to Hand

T_bh = NaN(4,4,N);
for i = 1:N
    % +-180 degree, +-1.5m
    T_bh(:,:,i) = randSE3(pi,1.5); 
end

%% Hand to Checker Board

% +-180 degree, +-0.5m
T_ht = randSE3(pi,0.5);

%% Base to Camera

% +-180 degree, +-2.5m
X = randSE3(pi,2.5);

%% Sensor(Camera Reading)
T_s = pagemtimes(pagemtimes(HomInv(X),T_bh),T_ht);

%% Random Noise
% Optional Input

if sum(nois) ~= 0
    Tn = NaN(4,4,N);
    Tn(:,:,1) = eye(4); % Set 1st Points as Ground Truth
    for i = 2:N
        Tn(:,:,i) = randSE3(nois(1),nois(2));
    end
    T_s = pagemtimes(T_s,Tn);

end



end