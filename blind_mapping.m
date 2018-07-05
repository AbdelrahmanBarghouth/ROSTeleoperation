function blind_mapping(a,b, probePositionPubXY, probePositionPubZ, accuracy, FSRsub)
x_y_position = rosmessage('std_msgs/Float32MultiArray');
x_y_position.Data = [0,0];
send(probePositionPubXY, x_y_position);
dutyCyclez = rosmessage('std_msgs/Float32');
pulseWidthz = 1.3;
dutyCyclez.Data = (pulseWidthz/20)*100;
send(probePositionPubZ, dutyCyclez);
x_new = 0;
y_new = 0;
dir = 1;
map_3d = zeros(31,41);
[X,Y] = meshgrid(1:41,1:31);
while (x_y_position.Data(1) < 2.9 || x_y_position.Data(2) < 4)
    contact = 0;
    abdo = ["position", x_y_position.Data(1), x_y_position.Data(2)];
    disp(abdo)
    while (contact == 0)
        % pulseWidthz = 2.1; % 2nd approach
        pulseWidthz = pulseWidthz + 0.1;
        dutyCyclez.Data = (pulseWidthz/20)*100;
        send(probePositionPubZ, dutyCyclez);
        pause(0.1)
        FSR_average = 0;
        for i =1:10
            pause(0.02)
            FSR_average = FSR_average + FSRsub.LatestMessage.Data;
            % disp(FSR_average)
        end
        if (FSR_average/10 > 1.4)
            contact = 1;
            map_3d(x_new*10+1:x_new*10+10*accuracy,y_new*10+1:y_new*10+10*accuracy) = 2.1 - pulseWidthz;
            % 2nd approach
            %             if (FSR_average/10 > 2.5)
            %                 map_3d(x_new*10+1:x_new*10+10*accuracy,y_new*10+1:y_new*10+10*accuracy)= 0.3;
            %                 h = ["height is: ", 0.3];
            %                 disp(h)
            %             else
            %                 map_3d(x_new*10+1:x_new*10+10*accuracy,y_new*10+1:y_new*10+10*accuracy)= 0.2;
            %                 hhh = ["height is: ", 0.2];
            %                 disp(h)
            %             end
            pulseWidthz = 1.3;
            dutyCyclez.Data = (pulseWidthz/20)*100;
            send(probePositionPubZ, dutyCyclez);
            figure(2)
            surf(X,Y,map_3d)
            pause(0.1)
        end
        pause(0.2)
    end
    if(dir == 1)
        x_new = x_y_position.Data(1) + accuracy;
    end
    if (dir == 0)
        x_new = x_y_position.Data(1) - accuracy;
    end
    x_y_position.Data=[x_new, y_new];
    send(probePositionPubXY, x_y_position);
    if (x_y_position.Data(1) <= 0.1)
        dir = 1;
        y_new = x_y_position.Data(2) + accuracy;
    end
    if (x_new >= 2.9)
        dir = 0;
        y_new = x_y_position.Data(2) + accuracy;
    end
    pause(0.1)
end
end