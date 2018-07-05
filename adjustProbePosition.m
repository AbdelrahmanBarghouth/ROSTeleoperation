function adjustProbePosition(Xpub, Ypub, msg)
pulseWidthx = 2.6 - 0.25*msg.Data(1);
dutyCyclex = rosmessage('std_msgs/Float32');
dutyCyclex.Data = (pulseWidthx/20)*100;
send(Xpub, dutyCyclex);

pulseWidthy = 0.55 + 0.25*msg.Data(2);
dutyCycley = rosmessage('std_msgs/Float32');
dutyCycley.Data = (pulseWidthy/20)*100;
send(Ypub, dutyCycley);
end