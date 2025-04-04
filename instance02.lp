floor(1).
floor(2).
floor(3).
init(e(1),2).     % elevator "e(1)" starts from floor 2
call(1).          % some elevator must serve floor 1
deliver(e(1),3).  % elevator "e(1)" must serve floor 3

%* CALLS:
$ clingo instance02.lp elevator.lp
*%

% Optimization : 5

%*
move(e(1),1,1).
serve(e(1),2).
move(e(1),-1,3).
move(e(1),-1,4).
serve(e(1),5).
*%

%*
move(e(1),-1,1).
serve(e(1),2).
move(e(1),1,3).
move(e(1),1,4).
serve(e(1),5).
*%
