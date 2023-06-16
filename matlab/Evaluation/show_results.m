close all
clear all
addpath('functions')
load(['data' filesep 'testing' filesep 'MonzaR6.mat'])
epcs = unique(test_data(:,3));
%% Plot data of the k-th tag
for i=1:length(epcs)
    fun_draw_data(i);
end

%% Plot average temperature errors of every tag
errors = zeros(1,length(epcs));
d=zeros(1,length(epcs));
for i = 1:length(epcs)
    [a,b,c]=fun_get_error(i);
    errors(i) = mean(a);
    d(i)=c;
end

figure
h = bar(1:1:length(epcs),errors,0.5);
hold on
h2=errorbar(1:1:length(epcs),errors,d,d);
h2.Color = [0 0 0];                            
h2.LineStyle = 'none';  
h2.LineWidth=0.8;

xticks(1:length(epcs))
xlim([0 5])
fun_set_axis_size('标签#','温度误差(\circC)',12,[350 250]);

%% Plot temperature errors at different temperature levels 
errors = zeros(1,length(epcs));
pertag_errors = [];
temps = [];
for i = 1:length(epcs)
    [errors,temp,c]= fun_get_error(i);
    temps = [temps;temp];
    pertag_errors = [pertag_errors;errors];
end
%%[pertag_errors,temps]=fun_get_error(1);
mean_errors = zeros(1,5);
d=zeros(1,5);
for i = 3:7
    index = temps>=i*10-10&temps<i*10;
    mean_errors(1,i-2) = mean(pertag_errors(index));
    d(1,i-2)=std(pertag_errors(index));
end

figure 
h = bar(1:1:5,mean_errors,0.5);
hold on
h2=errorbar(1:1:5,mean_errors,d,d);
h2.Color = [0 0 0];                            
h2.LineStyle = 'none';  
h2.LineWidth=0.8;


xticklabels({'20-30';'30-40';'40-50';'50-60';'60-70'})
set(gca,'FontSize',12,'fontname','Times New Roman');
set(gcf,'Position', [100 100 350 250]); 
xlabel('温度(\circC)','Fontsize',12,'fontname','SimHei');
ylabel('温度误差(\circC)','Fontsize',12,'fontname','SimHei');
ylim([0 5])

