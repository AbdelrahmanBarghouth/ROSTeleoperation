function camera_show(Imsg, camera_axes)
% Taking Image message and display it in its specific axes
axes(camera_axes)
imshow(readImage(Imsg))
end