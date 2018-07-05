function  editImgYLower(objHandel,evt, x_lower, x_upper, y_lower, y_upper, edge_axes, EdgeImgPub, Imsg)
slider_y_lower = 360-round(get(objHandel,'Value'));
slider_x_upper = round(str2double(get(x_upper,'string')));
slider_x_lower = round(str2double(get(x_lower,'string')));
slider_y_upper = round(str2double(get(y_upper,'string')));
set(y_lower, 'string', slider_y_lower)

booleanImage = rosmessage('sensor_msgs/Image');
booleanImage.Width  = slider_x_upper - slider_x_lower + 1;
booleanImage.Height = slider_y_lower - slider_y_upper + 1;
booleanImage.Encoding = 'rgb8';
tmpImg = transpose(rgb2gray(readImage(Imsg)));
% disp(size(tmpImg))
tmpImg2 = tmpImg(slider_x_lower:slider_x_upper, slider_y_upper:slider_y_lower,1);
% disp(size(tmpImg2))
tmpImg = reshape(tmpImg2,[booleanImage.Width*booleanImage.Height,1]);
% disp(size(tmpImg))
% disp(booleanImage.Width*booleanImage.Height)
booleanImage.Data(1:3:booleanImage.Width*booleanImage.Height*3) = tmpImg(:,1);
booleanImage.Data(2:3:booleanImage.Width*booleanImage.Height*3) = tmpImg(:,1);
booleanImage.Data(3:3:booleanImage.Width*booleanImage.Height*3) = tmpImg(:,1);
axes(edge_axes)
imshow(readImage(booleanImage))
send(EdgeImgPub, booleanImage)
end