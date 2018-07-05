function initial_pos(a,b, probePositionPubXY, probePositionPubZ)
x_y_position = rosmessage('std_msgs/Float32MultiArray');
x_y_position.Data=[0,0];
send(probePositionPubXY, x_y_position);

pulseWidthz = 1.5;
dutyCyclez = rosmessage('std_msgs/Float32');
dutyCyclez.Data = (pulseWidthz/20)*100;
send(probePositionPubZ, dutyCyclez);
end