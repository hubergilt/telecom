clear all;
close all;
% data = importfile('data.csv', 2, 12);
data = readtable('data.csv');

%modelando el trafico de salida vs el trafico de entrante

x=[data.Rural_traffic_in];
y=[data.Rural_traffic_out];

b1=mldivide(x,y);
yCalc1=b1*x;

hold on;

scatter(x,y,'bo','LineWidth',1.5);
plot(x,yCalc1);

xlabel('Tráfico Telefónico rural entrante (min)');
ylabel('Tráfico Telefónico rural saliente (min)');
title('  Tráfico Telefónico rural saliente vs. entrante');

X = [ones(length(x),1) x]; b = X\y;
yCalc2 = X*b; 
plot(x,yCalc2,'--g');
grid on;

Rsq1 = 1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2);
Rsq2 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);
%legend('Datos', strcat('Regres. s/intercep. Rsq1=',num2str(Rsq1,3)),strcat('Regres. c/intercep. Rsq2=',num2str(Rsq2,3)),'Location','best');
legend('Datos', strcat('y=',num2str(b1,'%.2f'),'x, Rsq1=',num2str(Rsq1,3)),strcat('y=',num2str(b(1),'%.2f'),'+',num2str(b(2),'%.2f'),'x, Rsq2=',num2str(Rsq2,3)),'Location','best');
    
data1=data(:,{'Year', 'Rural_phones', 'Locations', 'Mobile_phones',...
                'Mobile_traffic_in','Mobile_traffic_out','MMS','SMS',...
                'Rural_population','PBI','PBI_per_capita'});
            
data2=data(:,{'Rural_phones', 'Locations', 'Mobile_phones',...
                'Mobile_traffic_in','Mobile_traffic_out','MMS','SMS',...
                'Rural_population','PBI_per_capita'});

data3=data(:,{'Rural_phones', 'Locations', 'Mobile_phones',...
                'Mobile_traffic_in','Mobile_traffic_out','MMS','SMS',...
                'Rural_population','PBI_per_capita'});

data4=data(:,{'Rural_phones', 'Locations', 'Mobile_phones',...
                'Mobile_traffic_in','Mobile_traffic_out','MMS','SMS',...
                'PBI_per_capita'});            
            
data5=data(:,{'Rural_phones', 'Locations', 'Mobile_phones',...
                'Mobile_traffic_in','Mobile_traffic_out','SMS',...
                'PBI_per_capita'}); 

data6=data(:,{'Rural_phones', 'Locations', 'Mobile_phones',...
                'Mobile_traffic_in','Mobile_traffic_out',...
                'PBI_per_capita'})            
            
%modelo para el trafico entrante
disp('')
disp('-->Modelo para el trafico entrada');
disp('')
mdl11=stepwiselm(data1.Variables, data.Rural_traffic_in);
mdl21=stepwiselm(data2.Variables, data.Rural_traffic_in);
mdl31=stepwiselm(data3.Variables, data.Rural_traffic_in);
mdl41=stepwiselm(data4.Variables, data.Rural_traffic_in);
mdl51=stepwiselm(data5.Variables, data.Rural_traffic_in);
mdl61=stepwiselm(data6.Variables, data.Rural_traffic_in)

%modelo para el trafico salida
disp('')
disp('<--modelo para el trafico salida');
disp('')
mdl12=stepwiselm(data1.Variables, data.Rural_traffic_out);
mdl22=stepwiselm(data2.Variables, data.Rural_traffic_out);
mdl32=stepwiselm(data3.Variables, data.Rural_traffic_out);
mdl42=stepwiselm(data4.Variables, data.Rural_traffic_out);
mdl52=stepwiselm(data5.Variables, data.Rural_traffic_out);
mdl62=stepwiselm(data6.Variables, data.Rural_traffic_out)

figure()
subplot(2,1,1)
mdl61.plot()
xlabel('Ajuste del Modelo Completo');
ylabel('Tráfico entrante (min)');
title('  Modelo de Tráfico Telefónico rural entrante');

subplot(2,1,2)
mdl62.plot()
xlabel('Ajuste del Modelo Completo');
ylabel('Tráfico saliente (min)');
title('  Modelo de Tráfico Telefónico rural saliente');







