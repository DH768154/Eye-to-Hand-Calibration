function [err,str] = EyeToHandError(E,X,S)
% v1.0
% 10-10-2023, Ding, Hao-sheng
% 
% err: [avg,max,std]

ptnum = size(E,3);

tooldata = pagemtimes(pagemtimes(HomInv(E),X),S);

e_mag = NaN(2,ptnum-1);

for i = 1:ptnum-1
    e_mag(:,i) = diffSE3(tooldata(:,:,i),tooldata(:,:,i+1),'self');
end

err = [mean(e_mag,2),max(e_mag,[],2),std(e_mag,0,2)];

scale = [1000;180/pi];
str{1} = sprintf('Calibration Error\n');
str{2} = sprintf('%.0f Measurements\n',ptnum);
str{3} = sprintf('Avg Tran / Rot: %5.2f mm / %5.2f deg',err(:,1).*scale);
str{4} = sprintf('Max Tran / Rot: %5.2f mm / %5.2f deg',err(:,2).*scale);
str{5} = sprintf('Std Tran / Rot: %5.2f mm / %5.2f deg',err(:,3).*scale);

end
