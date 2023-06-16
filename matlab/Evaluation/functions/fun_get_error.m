function [E,T,D] = fun_get_pertag_error(TagID)
%% Extract parameters
para = fun_get_parameters(TagID);
%% Calculate temperature errors
temp_col = 1; % Temperature column
ptime_col = 2; % Persistence time column
epc_col =3; % ID column
test_data=[]; % initial test_data
load(['data' filesep 'testing' filesep 'MonzaR6.mat'])
epcs = unique(test_data(:,epc_col));
epc = epcs(TagID);
index = test_data(:,epc_col) == epc;
T = test_data(index,temp_col); 
ptimes = test_data(index,ptime_col);
E = abs(fun_get_temperature(para,ptimes)-T);
D = std(E);
function temperature = fun_get_temperature(parameters,ptime)
temperature = log(parameters(1)./ptime-parameters(3))/log(parameters(2));
end
end

