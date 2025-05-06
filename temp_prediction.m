% Hanna Abraham
% egyha7@nottingham.ac.uk

function temp_prediciton(a)
% a = arduino object
% an = analogue pin for the thermistor
% g = digital pin for the green LED
% y = digital pin for the yellow LED
% r = digital pin for the red LED

r = 'D3';
g = 'D4';
y = 'D2';
an = 'A0';

configurePin(a,r,'DigitalOutput');
configurePin(a,g,'DigitalOutput');
configurePin(a,y,'DigitalOutput');
configurePin(a,an,'AnalogInput');

%Temperature & rate change temperature parameters 
min_comfort_temp = 18
max_comfort_temp = 24
Maxchangepermin = 4 %4degreesC per minute 
rateTheshold = Maxchangepermin / 60

%arrays created to store past temp values & time intervals between
Temp_log = [];
time_log = [];

fprintf ('Monitoring temperature of the room..\n');

while true
    current_time = datetime ('now');
    voltageReading = readVoltage(a,an);
    Current_temp = (voltage - 0.5) *100;

    Temp_log = [Temp_log, Current_temp];
    time_log = [time_log, Current_temp];

    if length(Temp_log) >10
        Temp_log = Temp_log(end-9:end);
        time_log = time_log(end-9:end);
    end

    if length (Temp_log) > 2
        Temp_diff = Temp_log(end) - Temp_log(1);
        time_diff = second/time_log(end) - time_log(1);
        rate = Temp_diff / time_diff;
    else
        temp_rate = 0
    end

    predicted_temp = Current_temp + temp_rate * 300


fprintf('Current Temp: %.2f °C | Rate: %.2f °C/s | Predicted in 5 min: %.2f °C\n', Current_temp, temp_rate, predicted_temp);

    if abs(temp_rate) < rateTheshold
        writeDigitalPin(a, g, 1); 
        writeDigitalPin(a, y, 0);
        writeDigitalPin(a, r, 0);
    elseif rate >= ratechange_temp
        writeDigitalPin(a, g, 0); 
        writeDigitalPin(a, y, 0);
        writeDigitalPin(a, r, 1);      
    elseif rate <= ratechange_temp
        writeDigitalPin(a, g, 0); 
        writeDigitalPin(a, y, 1);
        writeDigitalPin(a, r, 0); 
    end
    pause (2);
end
end
