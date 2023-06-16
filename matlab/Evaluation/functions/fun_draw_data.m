% FUN_DRAW_DATA Plot the theoretical curve and the testing data of a selected tag.
%   Example:
%       fun_draw_data(TagID)
function [] = fun_draw_data(TagID)
%% Get parameters
para = fun_get_parameters(TagID);
%% Load data from file
temp_col = 1; % Temperature column
ptime_col = 2; % Persistence time column
epc_col =3; % ID column
load(['data' filesep 'testing' filesep 'MonzaR6.mat'])
epcs = unique(test_data(:,epc_col));
epc = epcs(TagID);
index = test_data(:,epc_col) == epc;
temps = test_data(index,temp_col);
ptimes = test_data(index,ptime_col);
%% Plot data 
figure
fun = @(para,temp)para(1)./(para(2).^temp+para(3));
temp = 20:1:70;
y = fun(para,temp);
cl = {[50,100,180]/255, [46,139,87]/255,  [210,105,30]/255, [128,128,128]/255,[205,92,92]/255}; % blue gree orange grey 
plot(temps,ptimes,'o','Color', [210,105,30]/255)
hold on 
plot(temp,y,'LineWidth',1.5,'Color',[50,100,180]/255);
h=legend('测试数据','拟合曲线','Location','southwest');
set(h,"FontName",'SimHei');
fun_set_axis_size('温度(\circC)','持续时间(s)',12,[350 250]);
end

