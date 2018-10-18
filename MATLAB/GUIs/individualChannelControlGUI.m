function varargout = individualChannelControlGUI(varargin)
% INDIVIDUALCHANNELCONTROLGUI MATLAB code for individualChannelControlGUI.fig
%      INDIVIDUALCHANNELCONTROLGUI, by itself, creates a new INDIVIDUALCHANNELCONTROLGUI or raises the existing
%      singleton*.
%
%      H = INDIVIDUALCHANNELCONTROLGUI returns the handle to a new INDIVIDUALCHANNELCONTROLGUI or the handle to
%      the existing singleton*.
%
%      INDIVIDUALCHANNELCONTROLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INDIVIDUALCHANNELCONTROLGUI.M with the given input arguments.
%
%      INDIVIDUALCHANNELCONTROLGUI('Property','Value',...) creates a new INDIVIDUALCHANNELCONTROLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before individualChannelControlGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to individualChannelControlGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help individualChannelControlGUI

% Last Modified by GUIDE v2.5 16-Oct-2018 14:06:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @individualChannelControlGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @individualChannelControlGUI_OutputFcn, ...
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


% --- Executes just before individualChannelControlGUI is made visible.
function individualChannelControlGUI_OpeningFcn(hObject,~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to individualChannelControlGUI (see VARARGIN)
% Choose default command line output for individualChannelControlGUI
handles.output = hObject;
daqParam = getappdata(0,'daqParam');
%set flow state check boxes and flow rate edits according to their values
for i = 1:4
    str = strcat('checkbox',num2str(i)); %valve number
    handles.(str).Value = daqParam.NIDAQ.SolStates(i); %set value from solstates
    str = strcat('flowEdit',num2str(i));
    handles.(str).String = num2str(daqParam.Pump.FlowRates(i));
end
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = individualChannelControlGUI_OutputFcn(~,~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


function flowEdit_Callback(hObject, eventdata, handles)
% hObject    handle to flowEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
daqParam = getappdata(0,'daqParam');
%set channel from which edit with the string from the edit
daqParam.Pump.setFlowRate(str2double(hObject.Tag(end)),...
    str2double(hObject.String));

% --- Executes on button press in pushbutton.
function flowbutton_Callback(hObject,~,handles)
% hObject    handle to pushbutton (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
daqParam = getappdata(0,'daqParam');
%if pump flow rate is set greater than 0
if daqParam.Pump.FlowRates(str2num(hObject.String)) > 0
    %get states, change this one to opposite
    solstates = daqParam.NIDAQ.SolStates;
    solstates(str2num(hObject.String)) = ~solstates(str2num(hObject.String));
    %send to SolenoidValve to change
    daqParam.NIDAQ.setValveStates(solstates);
    %update checkbox
    str = strcat('checkbox',hObject.String); %valve number
    handles.(str).Value = ~handles.(str).Value;    
    %control pump
    if solstates(str2num(hObject.String))
         %if you just turned it on
        daqParam.Pump.startFlow(str2num(hObject.String));
    else
         %if you just turned it off
        daqParam.Pump.stopFlow(str2num(hObject.String));
    end
end

% --- Executes on button press in startAllButton.
function startAllButton_Callback(~,~,handles)
daqParam = getappdata(0,'daqParam');
daqParam.Pump.startFlowOpenValves();
%set flow state check boxes according to their values
for i = 1:4
    str = strcat('checkbox',num2str(i)); %valve number
    handles.(str).Value = daqParam.NIDAQ.SolStates(i); %set value from solstates
end

% --- Executes on button press in stopAllButton.
function stopAllButton_Callback(~,~,handles)
daqParam = getappdata(0,'daqParam');
daqParam.Pump.stopFlowCloseValves();
%set flow state check box according to their values
for i = 1:4
    str = strcat('checkbox',num2str(i)); %valve number
    handles.(str).Value = false; %set value from solstates
end

% --- Executes on button press in closeButton
function closeButton_Callback(~,~,~)
setappdata(0,'individualChannelControl',[]); %delete handle to figure
close %close window
