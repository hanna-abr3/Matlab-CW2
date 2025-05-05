% Hanna Abraham
% egyha7@nottingham.ac.uk

%% 
clear

function temp_monitor (a, an, g, y, r)

%This is a function which blinks certain LEDs based off the temperature of
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

TC = 0.01;  % Temperature coefficient
V0 = 0.5;   % 0 degree voltage

figure
    while true

         elapsed = toc(startTime);
        volts = readVoltage(a, an);
        tempC = (volts - V0) / TC;

        % Store data
        t(end+1) = elapsed;
        tempLog(end+1) = tempC;

        % Plot live graph
        plot(t, tempLog, 'b', 'LineWidth', 2);
        xlabel('Time (s)');
        ylabel('Temperature (°C)');
        title('Live Temperature Monitoring');
        grid on;
        xlim([max(0, elapsed - 60), elapsed + 5]);
        ylim([min(10, min(tempLog) - 1), max(30, max(tempLog) + 1)]);
        drawnow;

      
        volts = readVoltage(a, analogPin);
        tempC = (volts - V0) / TC;

        % Temperature recorded in the room displayed
        fprintf('Temperature: %.2f °C\n', tempC);

        % All the LEDs start with m=being turned off
        writeDigitalPin(a, greenLED, 0);
        writeDigitalPin(a, yellowLED, 0);
        writeDigitalPin(a, redLED, 0);

  
        if tempC >= 18 & tempC <= 24
            writeDigitalPin(a, g, 1);
            pause(0.5); 
        elseif tempC < 18
            writeDigitalPin(a, y, 1);
            pause(0.5);
            writeDigitalPin(a, y, 0);
        else
            writeDigitalPin(a, r, 1);
            pause(0.25);
            writeDigitalPin(a, r, 0);
        end
    end
end
