floor(1).
floor(2).
floor(3).
init(e(1),2).     % elevator "e(1)" starts from floor 2
call(1).          % some elevator must serve floor 1

%* CALLS:
$ clingo instance01.lp elevator.lp
*%

% Optimization : 2

%*
move(e(1),-1,1).
serve(e(1),2).
*%
