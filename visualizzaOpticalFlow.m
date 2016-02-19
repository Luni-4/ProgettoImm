function visualizzaOpticalFlow

%% Funzione per testing
%Set up objects.

videoReader = vision.VideoFileReader('videos/cars1.avi','ImageColorSpace','Intensity','VideoOutputDataType','uint8');
converter = vision.ImageDataTypeConverter;
opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1);
opticalFlow.Method = 'Lucas-Kanade';
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
shapeInserter = vision.ShapeInserter('Shape','Lines','BorderColor','Custom', 'CustomBorderColor', 255);
videoPlayer = vision.VideoPlayer('Name','Motion Vector');

%% Convert the image to single precision, then compute optical flow for the video.
% Generate coordinate points and draw lines to indicate flow. Display results.

while ~isDone(videoReader)
    frame = step(videoReader);
    im = step(converter, frame);
    of = step(opticalFlow, im);
    lines = videooptflowlines(of, 20);
    if ~isempty(lines)
        out =  step(shapeInserter, im, lines);
        step(videoPlayer, out);
    end
    pause(2);
end

%
%% Close the video reader and player

% release(videoPlayer);
% release(videoReader);


end