floor(1).
floor(2).
floor(3).
floor(4).
floor(5).

% Initialization floor for elevator would be non deterministic 

init(e(1),1).     % elevator "e(1)" 
init(e(2),2).     % elevator "e(2)" 

call(1).          % some elevator must serve floor 1
call(2).          % some elevator must serve floor 2
call(5).          % some elevator must serve floor 5

deliver(e(1),4).  % elevator "e(1)" must serve floor 4
deliver(e(2),1).  % elevator "e(2)" must serve floor 5

