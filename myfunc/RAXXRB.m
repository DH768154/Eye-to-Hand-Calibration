function R = RAXXRB(RA,RB,varargin)
% Find X for RA*X = X*RB
% RA,RB is 3*3*n Matrix, n>=3
% 
% Optional Input: Calculation method (default method 2)
% 1. Park & Martin Method From ASBR Lecture
% 2. Quaternion Method From CIS Lecture

if size(RA,3)<3
    error('Need at Least 3 Rotation Matrix')
end

if nargin == 3
    method = varargin{1};
else
    method = 2;
end

sets = size(RA,3);


%% Park & Martin Method
% From ASBR Lecture
if method == 1

    alphas = ExpRotInv(RA);
    betas  = ExpRotInv(RB);

    M = betas * alphas';
    R = (M' * M)^-0.5 * M';
    
    %% Quaternion Method
    % From CIS Lecture
    % Tsai-Lenz

elseif method == 2
    [qA,qB] = deal(R2Q(RA),R2Q(RB));

    [sA,vA] = deal(qA(:,1),qA(:,2:4));
    [sB,vB] = deal(qB(:,1),qB(:,2:4));

    Mqi = NaN(4,4,sets);
    Mqi(1,1,:) = reshape(sA-sB,1,1,sets);
    Mqi(1,2:4,:) = reshape((vB-vA)',1,3,sets);
    Mqi(2:4,1,:) = reshape((vA-vB)',3,1,sets);
    Mqi(2:4,2:4,:) = reshape(sA-sB,1,1,sets).*eye(3) + Hat3((vA+vB)');
    Mq = mx3cat(Mqi);

    [~,~,V] = svd(Mq);
    qX = V(:,4)';
    R = Q2R(qX);
end
end