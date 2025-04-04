floor(1).
floor(2).
floor(3).
floor(4).
floor(5).
init(e(1),4).     % elevator "e(1)" starts from floor 4
call(2).          % some elevator must serve floor 2
deliver(e(1),5).  % elevator "e(1)" must serve floor 5

%* CALLS:
$ clingo instance03.lp elevator.lp
*%

% Optimization : 6

%*
move(e(1),1,1).
serve(e(1),2).
move(e(1),-1,3).
move(e(1),-1,4).
move(e(1),-1,5).
serve(e(1),6).
*%
