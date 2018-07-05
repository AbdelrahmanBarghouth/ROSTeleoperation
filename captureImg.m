function captureImg(a,b,Imsg, edge_axes, EdgeImgPub)
booleanImage = rosmessage('sensor_msgs/Image');
booleanImage.Encoding = 'rgb8';
booleanImage.Width  = Imsg.Width;
booleanImage.Height = Imsg.Height;
grayImg = rgb2gray(readImage(Imsg));
edgeImg = edge(grayImg,'Canny');
tmpImg = reshape(transpose(edgeImg)*255,[Imsg.Width*Imsg.Height,1]);
% disp(size(edgeImg))
% disp(size(tmpImg))
% disp(Imsg.Width*Imsg.Height)
booleanImage.Data(1:3:Imsg.Width*Imsg.Height*3) = tmpImg(:,1);
booleanImage.Data(2:3:Imsg.Width*Imsg.Height*3) = tmpImg(:,1);
booleanImage.Data(3:3:Imsg.Width*Imsg.Height*3) = tmpImg(:,1);
axes(edge_axes)
imshow(readImage(booleanImage))
%imshow(edgeImg)
send(EdgeImgPub, booleanImage)
end