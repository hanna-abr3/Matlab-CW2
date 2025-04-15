clear

%This is a function which blinks certain LEDs based off the temperature of
%the room. In the brackets input the variable a, the anaolog pin that the thermistor inputs to, the
%digitial pin of the green yellow and red LED's in that order.
function y = temp_monitor (a, an, g, y, r)

a = arduino(); 
analogPin = 'an'; 
greenLED = 'g';
yellowLED = 'y';
redLED = 'r';

TC = 0.01;  % Temperature coefficient
V0 = 0.5;   % 0 degree voltage

    while true
      
        volts = readVoltage(a, analogPin);
        tempC = (volts - V0) / TC;

        % Temperature recorded in the room displayed
        fprintf('Temperature: %.2f °C\n', tempC);

        % All the LEDs start with m=being turned off
        writeDigitalPin(a, greenLED, 0);
        writeDigitalPin(a, yellowLED, 0);
        writeDigitalPin(a, redLED, 0);

  
        if tempC >= 18 & tempC <= 24
            writeDigitalPin(a, greenLED, 1);
            pause(0.5); 
        elseif tempC < 18
            writeDigitalPin(a, yellowLED, 1);
            pause(0.5);
            writeDigitalPin(a, yellowLED, 0);
        else
            writeDigitalPin(a, redLED, 1);
            pause(0.25);
            writeDigitalPin(a, redLED, 0);
        end
    end
end