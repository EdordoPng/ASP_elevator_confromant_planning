floor(1).
floor(2).
floor(3).
floor(4).
floor(5).
init(e(1),1).     % elevator "e(1)" starts from floor 1
init(e(2),2).     % elevator "e(2)" starts from floor 2
call(3).          % some elevator must serve floor 3
call(4).          % some elevator must serve floor 4
call(5).          % some elevator must serve floor 5
deliver(e(2),3).  % elevator "e(2)" must serve floor 3

%* CALLS:
$ clingo instance04.lp elevator.lp
*%

% Optimization : 5

%*
move(e(1),1,1).
move(e(2),1,1).
move(e(1),1,2).
serve(e(2),2).
move(e(1),1,3).
move(e(2),1,3).
move(e(1),1,4).
serve(e(2),4).
serve(e(1),5).
*%

%*
move(e(1),1,1).
move(e(2),1,1).
move(e(1),1,2).
serve(e(2),2).
move(e(1),1,3).
move(e(2),1,3).
serve(e(1),4).
move(e(2),1,4).
serve(e(2),5).
*%

%*
move(e(1),1,1).
move(e(2),1,1).
move(e(1),1,2).
move(e(2),1,2).
move(e(1),1,3).
serve(e(2),3).
move(e(1),1,4).
move(e(2),-1,4).
serve(e(1),5).
serve(e(2),5).
*%
