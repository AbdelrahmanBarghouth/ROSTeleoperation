function  write_pos(objHandel, evt, x_pos, y_pos, servo_axes, probePositionPub)
slider_x_value = get(objHandel,'Value');
slider_y_value = get(y_pos,'string');
set(x_pos, 'string', slider_x_value)
axes(servo_axes)
plot(slider_x_value, str2double(slider_y_value),'x')
xlim([0 3])
ylim([0 4])

x_y_position = rosmessage('std_msgs/Float32MultiArray');
x_y_position.Data=[slider_x_value,str2double(slider_y_value)];
send(probePositionPub, x_y_position);
end