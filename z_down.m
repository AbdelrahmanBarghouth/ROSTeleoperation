function z_down(a,b,probePositionPubZ)
pulseWidthz = 2.1;
dutyCyclez = rosmessage('std_msgs/Float32');
dutyCyclez.Data = (pulseWidthz/20)*100;
send(probePositionPubZ, dutyCyclez);
end