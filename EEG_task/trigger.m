close all 
clc 
c=4; 
[handle, errmsg] = IOPort('OpenSerialPort', 'COM6','BaudRate=57600'); 
tic;
IOPort('Write', handle, char(c));
toc
IOPort('Close', handle);