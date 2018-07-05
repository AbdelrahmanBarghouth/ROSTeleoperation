function z_up(a,b,probePositionPubZ)
pulseWidthz = 1;
dutyCyclez = rosmessage('std_msgs/Float32');
dutyCyclez.Data = (pulseWidthz/20)*100;
send(probePositionPubZ, dutyCyclez);
end