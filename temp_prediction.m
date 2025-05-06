% Hanna Abraham
% egyha7@nottingham.ac.uk

function temp_monitor(a, an, g, y, r)
% a = arduino object
% an = analogue pin for the thermistor
% g = digital pin for the green LED
% y = digital pin for the yellow LED
% r = digital pin for the red LED

% The function continuously reads temperature from a thermistor,
% calculates the rate of temperature change, and predicts the
% temperature in 5 minutes. It uses LEDs to indicate stability
% (green), rapid increase (red), or rapid decrease (yellow).

%configure the LEds and the analogue input pin
configurePin(a,r,'DigitalOutput');
configurePin(a,g,'DigitalOutput');
configurePin(a,y,'DigitalOutput');
configurePin(a,an,'AnalogInput');

%Temperature & rate change temperature parameters 
min_comfort_temp = 18
max_comfort_temp = 24
Maxchangepermin = 4 %4degreesC per minute 
rateThreshold = Maxchangepermin / 60

%arrays created to store past temp values & time intervals between
Temp_log = [];
time_log = [];

fprintf ('Monitoring temperature of the room..\n');

while true
    %getting the current time and read the voltage from the thermistor
    current_time = datetime ('now');
    voltageReading = readVoltage(a,an);

    %converting voltage to temperature
    Current_temp = (voltageReading - 0.5) *100;

    %storing the latest temperature and time
    Temp_log = [Temp_log, Current_temp];
    time_log = [time_log, current_time];

   %code to keep only the last 10 samples
    if length(Temp_log) >10
        Temp_log = Temp_log(end-9:end);
        time_log = time_log(end-9:end);
    end

    %to calculate the rate of change of the temperature
    if length (Temp_log) > 2
        Temp_diff = Temp_log(end) - Temp_log(1);
        time_diff = seconds(time_log(end) - time_log(1));
        temp_rate = Temp_diff / time_diff;
    else
        temp_rate = 0
    end
    %code to predict the temperature in 5 mins
    predicted_temp = Current_temp + temp_rate * 300


fprintf('Current Temp: %.2f °C | Rate: %.2f °C/s | Predicted in 5 min: %.2f °C\n', Current_temp, temp_rate, predicted_temp);

%LED to show if the rate of change is stable (green) or increasing to rapidly (red) / too
%slowly (yellow)
    if abs(temp_rate) < rateThreshold
        writeDigitalPin(a, g, 1); 
        writeDigitalPin(a, y, 0);
        writeDigitalPin(a, r, 0);
    elseif temp_rate >= rateThreshold
        writeDigitalPin(a, g, 0); 
        writeDigitalPin(a, y, 0);
        writeDigitalPin(a, r, 1);      
    elseif temp_rate <= rateThreshold
        writeDigitalPin(a, g, 0); 
        writeDigitalPin(a, y, 1);
        writeDigitalPin(a, r, 0); 
    end
    pause (2);
end
end
