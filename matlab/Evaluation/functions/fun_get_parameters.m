% FUN_GET_PARAMETERS  Get parameters of a tag. 
%   P = FUN_GET_PARAMETERS(TagID) returns the parameters of a tag. 

%   Example:
%       P = fun_get_parameters(TagID)
function P = fun_get_parameters(TagID)
%% Load data from file
temp_col = 1; % Temperature column
ptime_col = 2; % Persistence time column
epc_col =3; % ID column
load(['data' filesep 'training' filesep 'MonzaR6.mat'])
epcs = unique(train_data(:,epc_col));
epc = epcs(TagID);
index = train_data(:,epc_col) == epc;
temps = train_data(index,temp_col); % Temperature
ptimes = train_data(index,ptime_col); % Persistence time
fun = @(para,temp)para(1)./(para(2).^temp+para(3));
x0 = [1,1,1];
P =  lsqcurvefit(fun,x0,temps,ptimes);
end

