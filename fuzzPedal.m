% Fuzz Pedal created by Oscar Cairoli and Paul Pacis
function varargout = fuzzPedal(varargin)
% FUZZPEDAL MATLAB code for fuzzPedal.fig
%      FUZZPEDAL, by itself, creates a new FUZZPEDAL or raises the existing
%      singleton*.
%
%      H = FUZZPEDAL returns the handle to a new FUZZPEDAL or the handle to
%      the existing singleton*.
%
%      FUZZPEDAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FUZZPEDAL.M with the given input arguments.
%
%      FUZZPEDAL('Property','Value',...) creates a new FUZZPEDAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fuzzPedal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fuzzPedal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fuzzPedal

% Last Modified by GUIDE v2.5 05-Mar-2012 00:50:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fuzzPedal_OpeningFcn, ...
                   'gui_OutputFcn',  @fuzzPedal_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before fuzzPedal is made visible.
function fuzzPedal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fuzzPedal (see VARARGIN)

% Choose default command line output for fuzzPedal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fuzzPedal wait for user response (see UIRESUME)
% uiwait(handles.figure1);

delayPic = imread('DELAY.jpg','jpg');
set(handles.buttonDelayPedal,'CData',delayPic);

flangePic = imread('FLANGE.jpg','jpg');
set(handles.buttonFlangePedal,'CData',flangePic);

overdrivePic = imread('OVERDRIVE.jpg','jpg');
set(handles.buttonFuzzPedal,'CData',overdrivePic);

% --- Outputs from this function are returned to the command line.
function varargout = fuzzPedal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonFuzzPedal.
function buttonFuzzPedal_Callback(hObject, eventdata, handles)
% hObject    handle to buttonFuzzPedal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global overdriveValue


Fs = 8000;                    % Sampling frequency in Hz

T = 1;                        % length of one interval signal in sec
t = 0:1/Fs:T-1/Fs;            % time vector
nfft = 2^nextpow2(Fs);        % n-point discrete Fourier transform
numUniq = ceil((nfft+1)/2);   % half point
f = (0:numUniq-1)'*Fs/nfft;   % frequency vector (one sided)

% prepare plots
figure
graf(1) = subplot(211);
hLine(1) = line('XData',t, 'YData',nan(size(t)), 'Color','b', 'Parent',graf(1));
xlabel('Time (s)'), ylabel('Amplitude')
graf(2) = subplot(212);
hLine(2) = line('XData',f, 'YData',nan(size(f)), 'Color','b', 'Parent',graf(2));
xlabel('Frequency (Hz)'), ylabel('Magnitude (dB)')
set(graf, 'Box','on', 'XGrid','on', 'YGrid','on')

myLiveGuitar = audiorecorder;
myGuitar = audiorecorder;

str = sprintf('Start recording...');
set (handles.textDisplay,'String',str);

recordblocking(myGuitar, 10);

for i=1:10
    
    recordblocking(myLiveGuitar, T);
  
   % get data and compute fast Fourier transform
   sig = getaudiodata(myLiveGuitar);
   fftMag = 20*log10( abs(fft(sig,nfft)) );

   % update plots
   set(hLine(1), 'YData',sig);
   set(hLine(2), 'YData',fftMag(1:numUniq));
   title(graf(1), num2str(i,'Interval = %d'));
   drawnow;                  
end

str = sprintf('End of recording. Playing back ...');
set (handles.textDisplay,'String',str);

audioData = getaudiodata(myGuitar);
distorted = distortion(audioData,8000,1,overdriveValue);
sound(distorted,8000);

figure
plot(distorted);
title('Over Drive');
ylabel('Distorted Amplitude');
xlabel('Time');

% --- Executes on slider movement.
function sliderOverdrive_Callback(hObject, eventdata, handles)
% hObject    handle to sliderOverdrive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global overdriveValue

value = get(handles.sliderOverdrive,'Value');
value = value + 30;
overdriveValue = value;

% --- Executes during object creation, after setting all properties.
function sliderOverdrive_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderOverdrive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on button press in buttonFlangePedal.
function buttonFlangePedal_Callback(hObject, eventdata, handles)
% hObject    handle to buttonFlangePedal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flangeValue


Fs = 8000;                    % sampling frequency in Hz

T = 1;                        % length of one interval signal in sec
t = 0:1/Fs:T-1/Fs;            % time vector
nfft = 2^nextpow2(Fs);        % n-point discrete Fourier transform
numUniq = ceil((nfft+1)/2);   % half point
f = (0:numUniq-1)'*Fs/nfft;   % frequency vector (one sided)

%#prepare plots
figure
graf(1) = subplot(211);
hLine(1) = line('XData',t, 'YData',nan(size(t)), 'Color','b', 'Parent',graf(1));
xlabel('Time (s)'), ylabel('Amplitude')
graf(2) = subplot(212);
hLine(2) = line('XData',f, 'YData',nan(size(f)), 'Color','b', 'Parent',graf(2));
xlabel('Frequency (Hz)'), ylabel('Magnitude (dB)')
set(graf, 'Box','on', 'XGrid','on', 'YGrid','on')

myLiveGuitar = audiorecorder;
myGuitar = audiorecorder;

str = sprintf('Start recording...');
set (handles.textDisplay,'String',str);

recordblocking(myGuitar, 10);

for i=1:10
    
    recordblocking(myLiveGuitar, T);
    
   % get data and compute fast Fourier transform
   sig = getaudiodata(myLiveGuitar);
   fftMag = 20*log10( abs(fft(sig,nfft)) );

   % update plots
   set(hLine(1), 'YData',sig);
   set(hLine(2), 'YData',fftMag(1:numUniq));
   title(graf(1), num2str(i,'Interval = %d'));
   drawnow;                   
end

str = sprintf('End of recording. Playing back ...');
set (handles.textDisplay,'String',str);

audioData = getaudiodata(myGuitar);
flanged = flange(audioData,8000,flangeValue)
sound(flanged,8000);

figure
plot(flanged);
title('Flange');
ylabel('Flange Amplitude');
xlabel('Time');

% --- Executes on button press in buttonDelayPedal.
function buttonDelayPedal_Callback(hObject, eventdata, handles)
% hObject    handle to buttonDelayPedal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global delayValue


Fs = 8000;                    % sampling frequency in Hz

T = 1;                        % length of one interval signal in sec
t = 0:1/Fs:T-1/Fs;            % time vector
nfft = 2^nextpow2(Fs);        % n-point discrete Fourier transform
numUniq = ceil((nfft+1)/2);   % half point
f = (0:numUniq-1)'*Fs/nfft;   % frequency vector (one sided)

% prepare plots
figure
graf(1) = subplot(211);
hLine(1) = line('XData',t, 'YData',nan(size(t)), 'Color','b', 'Parent',graf(1));
xlabel('Time (s)'), ylabel('Amplitude')
graf(2) = subplot(212);
hLine(2) = line('XData',f, 'YData',nan(size(f)), 'Color','b', 'Parent',graf(2));
xlabel('Frequency (Hz)'), ylabel('Magnitude (dB)')
set(graf, 'Box','on', 'XGrid','on', 'YGrid','on')

myLiveGuitar = audiorecorder;
myGuitar = audiorecorder;

str = sprintf('Start recording...');
set (handles.textDisplay,'String',str);

recordblocking(myGuitar, 10);

for i=1:10
    
    recordblocking(myLiveGuitar, T);
    
   % get data and compute fast Fourier transform
   sig = getaudiodata(myLiveGuitar);
   fftMag = 20*log10( abs(fft(sig,nfft)) );

   % update plots
   set(hLine(1), 'YData',sig);
   set(hLine(2), 'YData',fftMag(1:numUniq));
   title(graf(1), num2str(i,'Interval = %d'));
   drawnow;                   
end

str = sprintf('End of recording. Playing back ...');
set (handles.textDisplay,'String',str);

audioData = getaudiodata(myGuitar);
delayed = delay(audioData,8000,1,delayValue)
sound(delayed,8000);

figure
plot(delayed);
title('Delayed');
ylabel('Delayed Amplitude');
xlabel('Time');

% --- Executes on slider movement.
function sliderFlange_Callback(hObject, eventdata, handles)
% hObject    handle to sliderFlange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global flangeValue

value = get(handles.sliderFlange,'Value');
value = value + 50;
flangeValue = value;

% --- Executes during object creation, after setting all properties.
function sliderFlange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderFlange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderDelay_Callback(hObject, eventdata, handles)
% hObject    handle to sliderDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global delayValue

value = get(handles.sliderDelay,'Value');
value = value + 100;
delayValue = value;

% --- Executes during object creation, after setting all properties.
function sliderDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function axes8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes8
axes(hObject)
imshow('CoolBackground.jpg');