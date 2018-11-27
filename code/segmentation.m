function varargout = segmentation(varargin)
% SEGMENTATION MATLAB code for segmentation.fig
%      SEGMENTATION, by itself, creates a new SEGMENTATION or raises the existing
%      singleton*.
%
%      H = SEGMENTATION returns the handle to a new SEGMENTATION or the handle to
%      the existing singleton*.
%
%      SEGMENTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGMENTATION.M with the given input arguments.
%
%      SEGMENTATION('Property','Value',...) creates a new SEGMENTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segmentation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segmentation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%

% Begin initialization code 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segmentation_OpeningFcn, ...
                   'gui_OutputFcn',  @segmentation_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code


% --- Executes just before segmentation is made visible.
function segmentation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segmentation (see VARARGIN)

% Choose default command line output for segmentation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%to set axes handles not to show ticks on axes
axes(handles.axes1)
set(gca,'XtickLabel',[],'YtickLabel',[]);

%to make previous image button invisible
set(handles.previousImage,'Visible','Off');

% index of image displayed in axes
currentIndex = 1;
handles.currentIndex = currentIndex;
guidata(hObject, handles);

%to show 'next image' image on push button
[x,map]=imread('Next.png');
I2=imresize(x, [40 97]);

%h=uicontrol('cdata',I2);
set(handles.nextImage,'cdata',I2);


% UIWAIT makes segmentation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = segmentation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadImage.
function loadImage_Callback(hObject, eventdata, handles)
%% this function to load the database

% select the directory of images to load

%to set the status to laoding...
set(handles.text18, 'String', 'Loading...');

%to get the dialog to select database
currentDir = uigetdir('cwd');

%to get files in the selcted folder
files = dir2(currentDir); % read the conents of directory

numFiles = length(files); % number of files in selected folder
handles.numFiles = numFiles;

%to sort filenames
filenames = natsortfiles({files.name});

for nfile = 1:numFiles
    info_original(nfile) = dicominfo([currentDir, '\', filenames{nfile}]);  % read dicominfo
    image_dicom(:,:,nfile) = dicomread(info_original(nfile)); % read dicom image from info
end

%to show number of images
set(handles.text19,'String',numFiles);

%% to show the first image on display and first image details accordingly
axes(handles.axes1);
imshow(image_dicom(:,:,1),[]); % show 1st image on gui

%to add first andlast names
patientName = strcat(info_original(1).PatientName.GivenName,{' '}, info_original(1).PatientName.FamilyName);
set(handles.text11,'String',patientName);
set(handles.text12,'String',info_original(1).PatientID);
set(handles.text13,'String',info_original(1).PatientBirthDate);
set(handles.text14,'String',info_original(1).StudyID);
set(handles.text15,'String',info_original(1).StudyDate);
set(handles.text16,'String',info_original(1).SliceLocation);
set(handles.text17,'String',info_original(1).InstanceNumber);

%to send dicominfo files to other callbacks
handles.info_original = info_original;
handles.image_dicom = image_dicom;
guidata(hObject, handles);
set(handles.text18, 'String', 'Loading Done!');



    



% --- Executes on button press in previousImage.
function previousImage_Callback(hObject, eventdata, handles)
%% this function to show the image and data when previousimage is pressed

%to get data from other callbacks
image_dicom = handles.image_dicom;
info_original = handles.info_original;
numFiles = handles.numFiles;
currentIndex = handles.currentIndex;

%to decrease index for previous image
currentIndex = currentIndex - 1;

% to set visisbility of 'nextimage' button 'On' if current image is not
% last image
if(currentIndex < numFiles)
    set(handles.nextImage,'Visible','On');
end

%% show the previous image and related data
axes(handles.axes1);
imshow(image_dicom(:,:,currentIndex),[]);
patientName = strcat(info_original(currentIndex).PatientName.GivenName,{' '}, info_original(currentIndex).PatientName.FamilyName);
set(handles.text11,'String',patientName);
set(handles.text12,'String',info_original(currentIndex).PatientID);
set(handles.text13,'String',info_original(currentIndex).PatientBirthDate);
set(handles.text14,'String',info_original(currentIndex).StudyID);
set(handles.text15,'String',info_original(currentIndex).StudyDate);
set(handles.text16,'String',info_original(currentIndex).SliceLocation);
set(handles.text17,'String',info_original(currentIndex).InstanceNumber);

%% % to set visisbility of 'previousimage' button 'Off' if current image is first image
if(currentIndex == 1 )
    set(handles.previousImage,'Visible','Off');
end

%% to make data avaialble for other callbacks
handles.currentIndex = currentIndex;
guidata(hObject, handles);


% --- Executes on button press in nextImage.
function nextImage_Callback(hObject, eventdata, handles)
%% this function for showing image and data when nextimage is pressed

%to get data from other callbacks
image_dicom = handles.image_dicom;
info_original = handles.info_original;
numFiles = handles.numFiles;
currentIndex = handles.currentIndex;

%to increase index for next image
currentIndex = currentIndex + 1;

%%to show next image and corresponding data
axes(handles.axes1);
imshow(image_dicom(:,:,currentIndex),[]);
patientName = strcat(info_original(currentIndex).PatientName.GivenName,{' '}, info_original(currentIndex).PatientName.FamilyName);
set(handles.text11,'String',patientName);
set(handles.text12,'String',info_original(currentIndex).PatientID);
set(handles.text13,'String',info_original(currentIndex).PatientBirthDate);
set(handles.text14,'String',info_original(currentIndex).StudyID);
set(handles.text15,'String',info_original(currentIndex).StudyDate);
set(handles.text16,'String',info_original(currentIndex).SliceLocation);
set(handles.text17,'String',info_original(currentIndex).InstanceNumber);

% to show 'prevousimage' button if current shown image is not first image
if(currentIndex > 1)
    set(handles.previousImage,'Visible','On');
    [x,map]=imread('Previous.png');
I2=imresize(x, [40 97]);

%h=uicontrol('cdata',I2);
set(handles.previousImage,'cdata',I2);
end

%to not show the 'nextimage' button if current image shown is last image
if(currentIndex == numFiles)
    set(handles.nextImage,'Visible','Off');
end

% to amke data avaialble for other callbacks
handles.currentIndex = currentIndex;
guidata(hObject, handles);




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in anonymize.
function anonymize_Callback(hObject, eventdata, handles)
%% this function is to anonymize the data of patient 

% to show the status
set(handles.text18, 'String', 'Processing...');

%this is used to change the patient data name, id and dob
info_anonymize = handles.info_original;

% obtain the lengths of character arrays of each of data
givenNameLength = length(info_anonymize(1).PatientName.GivenName);
familyNameLength = length(info_anonymize(1).PatientName.FamilyName);
patientIDLength = length(info_anonymize(1).PatientID);
birthDateLength = length(info_anonymize(1).PatientBirthDate);

% change the data for all images
for nfiles=1:length(info_anonymize)
    info_anonymize(nfiles).PatientName.GivenName = repmat('x',1,givenNameLength);
    info_anonymize(nfiles).PatientName.FamilyName = repmat('x', 1, familyNameLength);
    info_anonymize(nfiles).PatientID = repmat('x', 1, patientIDLength);
    info_anonymize(nfiles).PatientBirthDate = repmat('x', 1, birthDateLength);
end

%to make it use for other callbacks
handles.info_anonymize = info_anonymize;
guidata(hObject, handles);
set(handles.text18, 'String', 'Anonymized!');



% --- Executes on button press in saveAnonymize.
function saveAnonymize_Callback(hObject, eventdata, handles)
%% this function is to save anonymise data in dicom

%to show status
set(handles.text18, 'String', 'Processing...');

%to save anonymize DICOM files to a newfolder in this directory
mkdir('./Anonymized Images');
info_anonymized_tosave = handles.info_anonymize;
image_dicom_tosave = handles.image_dicom;

%to save the anonymised images
for nfiles = 1:length(info_anonymized_tosave)
    filename = strcat('./Anonymized Images/Image000',num2str(nfiles),'.dcm');
    dicomwrite(image_dicom_tosave(:,:,nfiles), filename, info_anonymized_tosave(nfiles));
end

%to make it use for other callbacks
guidata(hObject, handles);
set(handles.text18, 'String', 'Saved!');
    
    


% --- Executes on button press in convertToJpeg.
function convertToJpeg_Callback(hObject, eventdata, handles)
%% this function to convert DICOM to JPEG images

% to show the status
set(handles.text18, 'String', 'Loading...');

% to load images from load image call back
info_anonymized_tosave = handles.info_anonymize;
image_dicom_tojpeg = handles.image_dicom;

% create a directory for jpeg images
mkdir('./Jpeg Images');
mkdir('./Meta Data');

for nfiles = 1:length(info_anonymized_tosave)
    filename = strcat('./Jpeg Images/Image',num2str(nfiles),'.jpeg');
    metadata = strcat('./Meta Data/data',num2str(nfiles),'.mat');
    % convert dicom image to gray adn scale to 255 and convert to uint8
    image_dicom_tojpeg8(:,:,nfiles) = uint8(255 * mat2gray(image_dicom_tojpeg(:,:,nfiles)));
    % save as jpeg image
    imwrite(image_dicom_tojpeg8(:,:,nfiles), filename);
    info_anonymized_forjpeg = info_anonymized_tosave(nfiles);
    save(metadata, 'info_anonymized_forjpeg');
end

% to change status
set(handles.text18, 'String', 'Jpeg Converted!');
    


% --- Executes on button press in loadJpegImages.
function loadJpegImages_Callback(hObject, eventdata, handles)
%% this function to laod Jpeg images to convert to Dicom

% to show the status
set(handles.text18, 'String', 'Processing...');

% to open dialog to load jpeg images
currentDir = uigetdir('cwd');
files = dir([currentDir, '.\*.jpeg']); % read the conents of directory
numFiles = length(files); % to get number of files
handles.numFiles = numFiles;

% to read jpeg files
for nfile = 1:numFiles
    image_jpeg(:,:,nfile) = imread([currentDir, '\', files(nfile).name]);  % read jpeg images
end

%to use image_jpeg in other call backs
handles.image_jpeg = image_jpeg;
guidata(hObject, handles);

set(handles.text18, 'String', 'Loaded!');

% --- Executes on button press in jpegToDicom.
function jpegToDicom_Callback(hObject, eventdata, handles)
%% this function to convert JPEG o DICOM including metadata

% to show the status
set(handles.text18, 'String', 'Processing...');


info_dicom_forjpeg = handles.info_dicom_forjpeg % to get metadata
numFiles = handles.numFiles;
image_jpeg = handles.image_jpeg; % to get jpeg images

%make a directory of dicom images
mkdir('./Dicom Images');

for nfile = 1:numFiles
    filename = strcat('./Dicom Images/Image',num2str(nfile),'.dcm');
    info_dicom_forjpeg = handles.info_dicom_forjpeg(nfile);
    dicomwrite(image_jpeg(:,:,nfile), filename, info_dicom_forjpeg);
end

% to change status
set(handles.text18, 'String', 'Converted!');



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadDicomInfo.
function loadDicomInfo_Callback(hObject, eventdata, handles)
%% this function to load DICOM info for conversion of Jpeg to Dicom

% to set the status 
set(handles.text18, 'String', 'Processing...');

% to get the dialog to dicom info
currentDir = uigetdir('cwd');
files = dir([currentDir, '.\*.mat']); % read the conents of directory
numFiles = length(files); % to get number of files

% to read jpeg files
for nfile = 1:numFiles
    info_dicom_forjpeg(nfile) = load([currentDir, '\', files(nfile).name]);  % read jpeg images
end

%to use image_jpeg in other call backs
handles.info_dicom_forjpeg = info_dicom_forjpeg;
guidata(hObject, handles);

%to change status
set(handles.text18, 'String', 'Loaded!');


% --- Executes on button press in tumorPush.
function tumorPush_Callback(hObject, eventdata, handles)
%%this function is to instantiate manual segmentation for tumor part of
%%prostrate

mkdir('./Segmented Images');

%to get currentimageindex
currentIndex = handles.currentIndex;
image_dicom_tosegment = handles.image_dicom(:,:,currentIndex);

%to start the manual segmentation
message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
uiwait(msgbox(message));

axes(handles.axes1); %to set axes for segmentation
hFH = imfreehand(gca,'closed','false'); % for freehand segmentation

% Create a binary image ("mask") from the ROI object.
binaryImageTumor = hFH.createMask;

%save segmented image
imwrite(binaryImageTumor,'./Segmented Images/Tumor.jpeg');

%to make data avaialble for other callbacks
handles.binaryImageTumor = binaryImageTumor;
guidata(hObject, handles);


% --- Executes on button press in centralPush.
function centralPush_Callback(hObject, eventdata, handles)
%%this function is to instantiate manual segmentation for central part of
%%prostrate

%to get currentimageindex
currentIndex = handles.currentIndex;
image_dicom_tosegment = handles.image_dicom(:,:,currentIndex);


message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
uiwait(msgbox(message));

axes(handles.axes1);
hFH = imfreehand(gca,'closed','false'); % for freehand segmentation

% Create a binary image ("mask") from the ROI object.
binaryImageCentral = hFH.createMask;
imwrite(binaryImageCentral,'./Segmented Images/Central.jpeg'); %save

%to make data avaialble for other callbacks
handles.binaryImageCentral = binaryImageCentral;
guidata(hObject, handles);

% --- Executes on button press in temporalPush.
function temporalPush_Callback(hObject, eventdata, handles)
%%this function is to instantiate manual segmentation for temporal part of
%%prostrate

currentIndex = handles.currentIndex;
image_dicom_tosegment = handles.image_dicom(:,:,currentIndex);


message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
uiwait(msgbox(message));

axes(handles.axes1);
hFH = imfreehand(gca,'closed','false');

% Create a binary image ("mask") from the ROI object.
binaryImageTemporal = hFH.createMask; %for freehand segmentation
imwrite(binaryImageTemporal,'./Segmented Images/Temporal.jpeg'); %save

%to make data avaialble for other callbacks
handles.binaryImageTemporal = binaryImageTemporal;
guidata(hObject, handles);

% --- Executes on button press in peripheralPush.
function peripheralPush_Callback(hObject, eventdata, handles)
%%this function is to instantiate manual segmentation for peripheral part of
%%prostrate

currentIndex = handles.currentIndex;
image_dicom_tosegment = handles.image_dicom(:,:,currentIndex);


message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
uiwait(msgbox(message));

axes(handles.axes1);
hFH = imfreehand(gca,'closed','false');

% Create a binary image ("mask") from the ROI object.
binaryImagePeripheral = hFH.createMask;
imwrite(binaryImagePeripheral,'./Segmented Images/Peripheral.jpeg');

handles.binaryImagePeripheral = binaryImagePeripheral;
guidata(hObject, handles);

% --- Executes on button press in show3DPush.
function show3DPush_Callback(hObject, eventdata, handles)
%% this function is to show 3D of different slices of a part of prostrate
% where slices are loaded by pushing loadsegmented button

images = handles.Images;
%to draw surface
drawSurface(images);


% --- Executes on button press in loadSegmentedPush.
function loadSegmentedPush_Callback(hObject, eventdata, handles)
%% this function is to load segemented images of all slices to form 3dmodel

%to show status
set(handles.text18, 'String', 'Processing...');

%to open dialog to select  segmented images
currentDir = uigetdir('cwd');
files = dir2([currentDir, '.\*.jpeg']); % read the contents of directory
numFiles = length(files) % to get number of files

%to sort filenames
filenames = natsortfiles({files.name});

% to read slices
for nfile = 1:numFiles
    filename = strcat(currentDir,'\',filenames{nfile});
    Images(:,:,nfile) = imread(filename);
end


%to use image in other call backs
handles.Images = Images;
guidata(hObject, handles);

%to change status
set(handles.text18, 'String', 'Loaded!');


% --- Executes on button press in calculateArea.
function calculateArea_Callback(hObject, eventdata, handles)
%% this function is to calculate area of segemented parts of prostrate

%get data from other callbacks
binaryImageTumor = handles.binaryImageTumor;
binaryImageCentral = handles.binaryImageCentral;
binaryImageTemporal = handles.binaryImageTemporal;
binaryImagePeripheral = handles.binaryImagePeripheral;
currentIndex = handles.currentIndex;
info = handles.info_original;
%to get pixel spacing value
infoImages = info(currentIndex).PixelSpacing;

%to calculate area
imagesArea = calculateArea(binaryImageTumor, binaryImageCentral, binaryImagePeripheral, binaryImageTemporal, infoImages)

% to get output
set(handles.text32, 'String', num2str(imagesArea(1,1)));
set(handles.text36, 'String', num2str(imagesArea(1,2)));
set(handles.text38, 'String', num2str(imagesArea(1,3)));
set(handles.text40, 'String', num2str(imagesArea(1,4)));

%to make output available to other callbacks
handles.imagesArea = imagesArea;
guidata(hObject, handles);

% --- Executes on button press in calculateVolume.
function calculateVolume_Callback(hObject, eventdata, handles)
%% this function to calculate volume of segemented parts of prostarte

%get data from other callbacks
imagesArea = handles.imagesArea;
currentIndex = handles.currentIndex;
info = handles.info_original;
infoImages = info(currentIndex).SliceThickness;

%to calculate volume
volumeImages  = calculateVolume( imagesArea, infoImages );

% to get output
set(handles.text35, 'String', num2str(volumeImages(1,1)));
set(handles.text37, 'String', num2str(volumeImages(1,2)));
set(handles.text39, 'String', num2str(volumeImages(1,3)));
set(handles.text41, 'String', num2str(volumeImages(1,4)));
