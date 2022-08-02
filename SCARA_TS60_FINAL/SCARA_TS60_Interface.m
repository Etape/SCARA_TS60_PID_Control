function varargout = SCARA_TS60_Interface(varargin)
% SCARA_TS60_Interface MATLAB code for SCARA_TS60_Interface.fig
%      SCARA_TS60_Interface, by itself, creates a new SCARA_TS60_Interface or raises the existing
%      singleton*.
%
%      H = SCARA_TS60_Interface returns the handle to a new SCARA_TS60_Interface or the handle to
%      the existing singleton*.
%
%      SCARA_TS60_Interface('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCARA_TS60_Interface.M with the given input arguments.
%
%      SCARA_TS60_Interface('Property','Value',...) creates a new SCARA_TS60_Interface or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SCARA_TS60_Interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SCARA_TS60_Interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SCARA_TS60_Interface

% Last Modified by GUIDE v2.5 01-May-2021 10:27:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SCARA_TS60_Interface_OpeningFcn, ...
                   'gui_OutputFcn',  @SCARA_TS60_Interface_OutputFcn, ...
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

% --- Executes just before SCARA_TS60_Interface is made visible.
function SCARA_TS60_Interface_OpeningFcn(hObject, eventdata, handles, varargin)

  
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SCARA_TS60_Interface (see VARARGIN)

% Choose default command line output for SCARA_TS60_Interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = SCARA_TS60_Interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function q0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function qf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in button.
function button_Callback(hObject, eventdata, handles)

    global q0 qf C1 C2 C3 C4 t q1 q2 q3 q1c q2c q3c
    global dt tmax
    clc
    set(handles.log,'String','Traitement ....');
    Q0=str2num(get(handles.q0,'String'));
    Qf=str2num(get(handles.qf,'String'));
    Tmax=str2num(get(handles.Tmax,'String'));
    Dt=str2num(get(handles.dt,'String'));
    
    if isempty(Qf) || isempty(Q0)|| isempty(Tmax) || isempty(Dt)
        set(handles.log,'String','Remplir correctement les champs');
    else
        
        set(handles.log,'String','En cours de traitement ....');
        sf=size(Qf);
        s0=size(Q0);
        if sf(1)~=1 || sf(2)~=3 || s0(1)~=1 || s0(2)~=3 
           set(handles.log,'String','Vecteurs mal initialisés pour SCARA 3DDL'+sf(1)+';'+sf(2)+';'+s0(1)+';'+s0(2));
        else
        q0=Q0;
        qf=Qf;
        tmax=Tmax;
        dt=Dt;
        k1=get(handles.MDD,'Value');
        k2=get(handles.PD,'Value');
        k3=get(handles.Glissant,'Value');
        k4=get(handles.Fuzzy,'Value');
        k5=get(handles.Hybride,'Value');
             
        if k1==1.0 
            C1=0;
            set(handles.log,'String','MDD en cours de traitement ....');
        
        elseif k2==1.0
        set(handles.log,'String','Commande PD en cours de traitement ....');
            C2=0;
            C1=1;
        elseif k3==1.0
            set(handles.log,'String','Mode Glissant en cours de traitement ....');
            C2=1;
            C1=1;
            C3=0;
        elseif k4==1.0
            set(handles.log,'String','Commande Floue en cours de traitement ....');
            C2=1;
            C1=1;
            C3=1;
            C4=0;
        elseif k5==1.0
            set(handles.log,'String','Commande Hybride en cours de traitement ....');
            C2=1;
            C1=1;
            C3=1;
            C4=1;
        end
     end
        sim('SCARA_TS60');
        axes(handles.fig_q1);
        plot(t,q1c,'r');
        hold on
        plot(t,q1,'b');
        hold off
        xlabel('t(s)');
        ylabel('q1c et q1');
        legend('q1c','q1');
        
        axes(handles.fig_q2);
        plot(t,q2c,'r');
        hold on
        plot(t,q2,'b');
        hold off
        xlabel('t(s)');
        ylabel('q2c et q2');
        legend('q2c','q2');
        
        axes(handles.fig_q3);
        plot(t,q3c,'r');
        hold on
        plot(t,q3,'b');
        hold off
        xlabel('t(s)');
        ylabel('q3c et q3');
        legend('q3c','q3');
        
        set(handles.log,'String','Terminé');
    end
        


% --- Executes during object creation, after setting all properties.
function button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function Tmax_Callback(hObject, eventdata, handles)
% hObject    handle to Tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tmax as text
%        str2double(get(hObject,'String')) returns contents of Tmax as a double


% --- Executes during object creation, after setting all properties.
function Tmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dt_Callback(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dt as text
%        str2double(get(hObject,'String')) returns contents of dt as a double

function Fuzzy_Callback(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dt as text
%        str2double(get(hObject,'String')) returns contents of dt as a double


% --- Executes during object creation, after setting all properties.
function MDD_Callback(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function PD_Callback(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dt as text
%        str2double(get(hObject,'String')) returns contents of dt as a double

function Glissant_Callback(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dt as text
%        str2double(get(hObject,'String')) returns contents of dt as a double

function Hybride_Callback(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dt as text
%        str2double(get(hObject,'String')) returns contents of dt as a double

function dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dt as text
%        str2double(get(hObject,'String')) returns contents of dt as a double

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set_param('SCARA_TS60','SimulationCommand','STOP');
