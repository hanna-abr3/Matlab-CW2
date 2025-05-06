% Hanna Abraham
% egyha7@nottingham.ac.uk

%% 

function temp_monitor(a, an, g, y, r)
%Temp_monitor - This is a function which blinks certain LEDs based off the temperature of
%the room. In the brackets input the variable a, the anaolog pin that the thermistor inputs to, the
%digitial pin of the green, yellow and red LED's in that order. The green
%LED will trun on steadliy if the temperature is between 18-24C. The yellow
%LED will blink at s if the temperature is greater than 18C and the red LED
%will blink at 0.25s if the temperature is less than 24C. A live graph of
%temperature over time is also plotted.
% a = arduino object
% an = analogue pin for the thermistor
% g = digital pin for the green LED
% y = digital pin for the yellow LED
% r = digital pin for the red LED


%Configuring the pins to set the LEDs as output and the thermistor pin as
%the analog inpu
configurePin(a,r,'DigitalOutput');
configurePin(a,g,'DigitalOutput');
configurePin(a,y,'DigitalOutput');
configurePin(a,an,'AnalogInput');


TC = 0.01;  % Temperature coefficient
V0 = 0.5;   % 0 degree voltage

%arrays for time & temperature created and the timer started
t= [];
tempLog = [];
startTime = tic;


%graph set up for the live plotting
figure;
title('Live Temperature Monitoring');

%main loop for the continuous temperature monitoring   
while true

        elapsed = toc(startTime);

        %reading voltage from the thermistor and converting the temperature
        volts = readVoltage(a, an); 
        tempC = (volts - V0) / TC;

        % Store data, both time and temperature for plotting
        t(end+1) = elapsed;
        tempLog(end+1) = tempC;

        % Plot live graph
        plot(t, tempLog, 'b', 'LineWidth',2);
        xlabel('Time (s)');
        ylabel('Temperature (°C)');
        title('Live Temperature Monitoring');
        grid on;
        xlim([max(0, elapsed - 60), elapsed + 5]);
        ylim([min(10, min(tempLog) - 1), max(30, max(tempLog) + 1)]);
        drawnow;


        % Temperature recorded in the room displayed in the command window
        fprintf('Temperature: %.2f °C\n', tempC);

        % All the LEDs turned off
        writeDigitalPin(a, g, 0);
        writeDigitalPin(a, y, 0);
        writeDigitalPin(a, r, 0);

  %LED control based on room temperature
        if tempC >= 18 & tempC <= 24
            writeDigitalPin(a, g, 1); %green steadily on
            pause(1); 
        elseif tempC < 18
            writeDigitalPin(a, y, 1); %yellow blinking as too cold
            pause(0.5);
            writeDigitalPin(a, y, 0);
            pause(0.5);
        else
            writeDigitalPin(a, r, 1); %red blinking as too hot
            pause(0.25);
            writeDigitalPin(a, r, 0);
            pause(0.25);
        end
    end
end
