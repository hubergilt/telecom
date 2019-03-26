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

xlabel('Tráfico Telefónico Rural Entrante (Erlang)');
ylabel('Tráfico Telefónico Rural Saliente (Erlang)');
title('   Tráfico Telefónico Rural Saliente vs. Entrante');

X = [ones(length(x),1) x]; b = X\y;
yCalc2 = X*b; 
plot(x,yCalc2,'--g');
grid on;
Rsq1 = 1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2);
Rsq2 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2);
%legend('Datos', strcat('Regres. s/intercep. Rsq1=',num2str(Rsq1,3)),strcat('Regres. c/intercep. Rsq2=',num2str(Rsq2,3)),'Location','best');
legend('Datos', strcat('y=',num2str(b1,'%.2f'),'x, Rsq1=',num2str(Rsq1,3)),strcat('y=',num2str(b(1),'%.2f'),'+',num2str(b(2),'%.2f'),'x, Rsq2=',num2str(Rsq2,3)),'Location','best');


%datos de trafico entrada            
data1e = data;
data1e.Rural_traffic_out=[];

data2e = data1e;
data2e.Year=[];
data2e.MMS =[];
data2e.SMS =[];
data2e.PBI =[];

data3e = data2e;
data3e.Rural_vol_traffic_in =[];
data3e.Rural_vol_traffic_out=[];

%datos de trafico saliente
data1s = data;
data1s.Rural_traffic_in=[];

data2s = data1s;
data2s.Year=[];
data2s.MMS =[];
data2s.SMS =[];
data2s.PBI =[];

data3s = data2s;
data3s.Rural_vol_traffic_in =[];
data3s.Rural_vol_traffic_out=[];
%data3s.Rural_phones         =[];
data3s.Mobile_vol_traffic_in=[];

%modelo para el trafico entrante
disp('')
disp('-->Modelo para el trafico entrada');
disp('')
mdl1e=stepwiselm(data1e, 'linear');
mdl2e=stepwiselm(data2e, 'linear');
mdl3e=stepwiselm(data3e, 'linear');

%modelo para el trafico salida
disp('')
disp('<--modelo para el trafico salida');
disp('')
mdl1s=stepwiselm(data1s, 'linear');
mdl2s=stepwiselm(data2s, 'linear');
mdl3s=stepwiselm(data3s, 'linear');

% %figura fwl
figure()
subplot(2,1,1)
hold on
mdl2e.plot()
xlabel('Var. añadida para vizualizar ajuste del modelo');
ylabel('Tráfico Entrante (Erg)');
title('  Modelo de Tráfico Telefónico Rural Entrante');

subplot(2,1,2)
mdl3s.plot()
xlabel('Var. añadida para vizualizar ajuste del modelo');
ylabel('Tráfico saliente (Erg)');
title('  Modelo de Tráfico Telefónico Rural Saliente');

% %figura de error trafico entrada
% figure()
% subplot(2,1,1)
% plot(data.Year,mdl2e.Variables.Rural_traffic_in,'-bo')
% hold on;
% plot(data.Year,mdl2e.Fitted,'--rx')
% plot(data.Year,[mdl2e.Variables.Rural_traffic_in-mdl2e.Fitted],'-g.');
% xlabel('Tiempo en Años');
% ylabel('Tráfico Entrante (min)');
% title('  Modelo de Tráfico Telefónico Rural Entrante');
% legend('Datos Observados', 'Datos Calculados','Error del Modelo','Location','best');

% subplot(2,1,2)
% plot(data.Year,[mdl2e.Variables.Rural_traffic_in-mdl2e.Fitted],'-g.');
% xlabel('Tiempo en Años');
% ylabel('Error del Modelo (min)');
% title('  Error del Modelo de Tráfico Telefónico RE');

% %figura de error trafico salida
% figure()
% subplot(2,1,1)
% plot(data.Year,mdl3s.Variables.Rural_traffic_out,'-bo')
% hold on;
% plot(data.Year,mdl3s.Fitted,'--rx')
% plot(data.Year,[mdl3s.Variables.Rural_traffic_out-mdl3s.Fitted],'-g.');
% xlabel('Tiempo en Años');
% ylabel('Tráfico Saliente (min)');
% title('  Modelo de Tráfico Telefónico Rural Saliente');
% legend('Datos Observados', 'Datos Calculados','Error del Modelo','Location','best');

% subplot(2,1,2)
% plot(data.Year,[mdl3s.Variables.Rural_traffic_out-mdl3s.Fitted],'-g.');
% xlabel('Tiempo en Años');
% ylabel('Error del Modelo (min)');
% title('  Error del Modelo de Tráfico Telefónico RS');
