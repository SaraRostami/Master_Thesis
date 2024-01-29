ioObj = io64;
status = io64(ioObj);
address = hex2dec('0378'); %D100
io64(ioObj, address, 20);