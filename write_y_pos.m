function  write_y_pos(objHandel,evt, x_pos, y_pos, servo_axes, probePositionPub)
slider_y_value = get(objHandel,'Value');
slider_x_value = get(x_pos,'string');
set(y_pos, 'string', slider_y_value)
axes(servo_axes)
plot(str2double(slider_x_value), slider_y_value,'x')
xlim([0 3])
ylim([0 4])

x_y_position = rosmessage('std_msgs/Float32MultiArray');
x_y_position.Data=[str2double(slider_x_value),slider_y_value];
send(probePositionPub, x_y_position);
end