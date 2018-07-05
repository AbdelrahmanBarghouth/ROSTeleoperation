function area_mapping(a,b, probePositionPubXY, probePositionPubZ, FSRsub, croppedImage, x_lower, x_upper, y_lower, y_upper)
slider_x_upper = round(str2double(get(x_upper,'string')));
slider_x_lower = round(str2double(get(x_lower,'string')));
slider_y_lower = round(str2double(get(y_lower,'string')));
slider_y_upper = round(str2double(get(y_upper,'string')));
width = slider_x_upper - slider_x_lower;
height = slider_x_lower - slider_y_upper;
processed_image = readImage(croppedImage);
cropped_image = processed_image(slider_x_lower:slider_x_upper,slider_y_upper:slider_y_lower);
x_y_position = rosmessage('std_msgs/Float32MultiArray');
dutyCyclez = rosmessage('std_msgs/Float32');
pulseWidthz = 1.3;
dutyCyclez.Data = (pulseWidthz/20)*100;
send(probePositionPubZ, dutyCyclez);
map_3d = zeros(31,41);
[X,Y] = meshgrid(1:41,1:31);
for i = 1:width
    for j = 1:height
        if(cropped_image(i,j) > 200)
            x_y_position.Data = [round((j/width)*3,1),round((i/height)*4,1)];
            send(probePositionPubXY, x_y_position);
            
            contact = 0;
            abdo = ["position", x_y_position.Data(1), x_y_position.Data(2)];
            disp(abdo)
            if (map_3d(x_y_position.Data(1)*10+1,x_y_position.Data(2)*10+1) == 0)
                while (contact == 0)
                    pulseWidthz = pulseWidthz + 0.1;
                    dutyCyclez.Data = (pulseWidthz/20)*100;
                    send(probePositionPubZ, dutyCyclez);
                    pause(0.1)
                    FSR_average = 0;
                    for k =1:10
                        pause(0.02)
                        FSR_average = FSR_average + FSRsub.LatestMessage.Data;
                        % disp(FSR_average)
                    end
                    if (FSR_average/10 > 1.4)
                        contact = 1;
                        map_3d(x_y_position.Data(1)*10+1,x_y_position.Data(2)*10+1) = 2.1 - pulseWidthz;
                        pulseWidthz = 1.3;
                        dutyCyclez.Data = (pulseWidthz/20)*100;
                        send(probePositionPubZ, dutyCyclez);
                        figure(2)
                        surf(X,Y,map_3d)
                        pause(0.1)
                    end
                    pause(0.2)
                end
            end
        end
    end
end
for i=2:30
    for j=2:40
        if (map_3d(i,j) == 0)
            %look around
            sum = map_3d(i-1,j-1) + map_3d(i-1,j) + map_3d(i-1,j+1) + map_3d(i,j-1) + map_3d(i,j+1) + map_3d(i+1,j-1) + map_3d(i+1,j) + map_3d(i+1,j+1);
            map_3d(i,j) = sum/8;
            figure(2)
            surf(X,Y,map_3d)
        end
    end
end
end