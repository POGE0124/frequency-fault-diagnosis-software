function varargout = DNN_tools_V10(varargin)
% DNN_TOOLS_V10 MATLAB code for DNN_tools_V10.fig
%      DNN_TOOLS_V10, by itself, creates a new DNN_TOOLS_V10 or raises the existing
%      singleton*.
%
%      H = DNN_TOOLS_V10 returns the handle to a new DNN_TOOLS_V10 or the handle to
%      the existing singleton*.
%
%      DNN_TOOLS_V10('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DNN_TOOLS_V10.M with the given input arguments.
%
%      DNN_TOOLS_V10('Property','Value',...) creates a new DNN_TOOLS_V10 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DNN_tools_V10_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DNN_tools_V10_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DNN_tools_V10

% Last Modified by GUIDE v2.5 21-Apr-2017 21:18:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DNN_tools_V10_OpeningFcn, ...
                   'gui_OutputFcn',  @DNN_tools_V10_OutputFcn, ...
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


% --- Executes just before DNN_tools_V10 is made visible.
function DNN_tools_V10_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DNN_tools_V10 (see VARARGIN)
% Choose default command line output for DNN_tools_V10
set(gcf,'menubar','figure'),
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DNN_tools_V10 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DNN_tools_V10_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
