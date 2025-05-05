% Hanna Abraham
% egyha7@nottingham.ac.uk


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]
clear

a = arduino()
for i= 1:10                        %will cause the LED to blink 10 times
    writeDigitalPin(a, 'D12',1);   %LED turned on for 0.5s
    pause (0.5);                   
    writeDigitalPin(a, 'D12',0);   %LED switched off for 0.5s
    pause (0.5);        
end


%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
clear

a = arduino()
analogPin ='A0'
duration = 601;                    %Duration that data will be collected for 

%preallocate arrays for time, voltage and temperature
time = zeros(1,duration);         
voltage = zeros(1,duration);
temperature = zeros(1,duration);

TC = 0.01;                         %zero degree voltage
V0 = 0.5;                          %temperature coefficient

%loop to keep collect data from te thermistor every second for the entire
%duration
for t = 1:duration
    volts = readVoltage(a, analogPin);
    tempC = (volts - V0)/ TC;      %converts voltage into temperature
    
    voltage(t) = volts
    temperature(t) = tempC;
    time(t) = t
    pause(1);
end

%data from the aquired results
minTemp = min(temperature);
maxTemp = max(temperature);
avgTemp = mean(temperature);



%c)Plot a graph using the results of temperature against time
plot(time,temperature)
xlabel('Time,s')
ylabel('Temperature, °C')
title('Temperature/Time graph')


%d)displays the collected temperature data in the required table

%date and location
fprintf('\n');
today = datestr(now, 'dd/mm/yyyy');
fprintf('Data logging initiated - %s\n', today);
fprintf('Location - London\n\n');

%loop to display the temperature reading at every minute
for minute = 0:10
    index = minute*60+1;
    fprintf('Minute\t\t\t%d\n', minute);
    fprintf('Temperature\t\t%.2f C\n\n', temperature(index));
end

fprintf('Max temp\t\t%.2f C\n', maxTemp);
fprintf('Min temp\t\t%.2f C\n', minTemp);
fprintf('Average temp\t%.2f C\n\n', avgTemp);

% End log
fprintf('Data logging terminated\n');


%e)
clear

file_id = fopen('cabin_temperature.txt','w');


%date and location
fprintf(file_id, '\n');
today = datestr(now, 'dd/mm/yyyy');
fprintf(file_id, 'Data logging initiated - %s\n', today);
fprintf(file_id, 'Location - London\n\n');

%loop to display the temperature reading at every minute
for minute = 0:10
    index = minute*60+1
    fprintf(file_id, 'Minute\t\t\t%d\n', minute);
    fprintf(file_id, 'Temperature\t\t%.2f C\n\n', temperature(index));
end

fprintf(file_id, 'Max temp\t\t%.2f C\n', maxTemp);
fprintf(file_id, 'Min temp\t\t%.2f C\n', minTemp);
fprintf(file_id, 'Average temp\t%.2f C\n\n', avgTemp);

fprintf('Data logging terminated\n');

fclose(file_id);

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
clear
a = arduino();
temp_monitor(a, 'A0','D6', 'D5', 'D7');



%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert reflective statement here (400 words max)


%% TASK 5 - COMMENTING, VERSION CONTROL AND PROFESSIONAL PRACTICE [15 MARKS]

% No need to enter any answershere, but remember to:
% - Comment the code throughout.
% - Commit the changes to your git repository as you progress in your programming tasks.
% - Hand the Arduino project kit back to the lecturer with all parts and in working order.