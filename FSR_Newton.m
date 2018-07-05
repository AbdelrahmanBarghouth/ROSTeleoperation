function FSR_Newton(PUB, msg, fsr_editor)
%%
Vout = msg.Data;
Vref = 3.3 * 1000; % 3.3 volt to millivolt
Vin = (Vref * Vout) / 1024;
% From the fsr datasheet Vout = (Vcc * R) / (R + FSR)
Vcc = Vref;
R = 30000; % 30K ohm
FSR = (Vcc - Vin) * (R / Vin);
% Using force-resistance graph, the force in grams is roughly inverse of
% resistance, then converting the grams to Newtons by multiplying with
% gravity.
force = rosmessage('std_msgs/Float32');
force_grams = 8/(FSR/1000000);
force.Data = (force_grams/1000) * 9.8;
set(fsr_editor, 'string', force.Data)
%disp(force.Data)
send(PUB, force);
end