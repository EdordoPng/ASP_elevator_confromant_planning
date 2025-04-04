floor(1).
floor(2).
floor(3).
floor(4).
floor(5).
floor(6).
floor(7).
floor(8).
init(e(1),3).     % elevator "e(1)" starts from floor 3
init(e(2),3).     % elevator "e(2)" starts from floor 3
init(e(3),8).     % elevator "e(3)" starts from floor 8
call(1).          % some elevator must serve floor 1
call(2).          % some elevator must serve floor 2
call(4).          % some elevator must serve floor 4
call(5).          % some elevator must serve floor 5
call(6).          % some elevator must serve floor 6
deliver(e(1),5).  % elevator "e(1)" must serve floor 5
deliver(e(2),3).  % elevator "e(2)" must serve floor 3

%* CALLS:
$ clingo instance05.lp elevator.lp
*%

% Optimization : 5

%*
move(e(1),1,1).
serve(e(2),1).
move(e(3),-1,1).
move(e(1),1,2).
move(e(2),-1,2).
move(e(3),-1,2).
serve(e(1),3).
serve(e(2),3).
move(e(3),-1,3).
move(e(1),1,4).
move(e(2),-1,4).
move(e(3),-1,4).
serve(e(1),5).
serve(e(2),5).
serve(e(3),5).
*%

%*
move(e(1),1,1).
serve(e(2),1).
move(e(3),-1,1).
move(e(1),1,2).
move(e(2),-1,2).
move(e(3),-1,2).
serve(e(1),3).
serve(e(2),3).
move(e(3),-1,3).
move(e(1),-1,4).
move(e(2),-1,4).
move(e(3),1,4).
serve(e(1),5).
serve(e(2),5).
serve(e(3),5).
*%

%*
move(e(1),1,1).
serve(e(2),1).
move(e(3),-1,1).
move(e(1),1,2).
move(e(2),-1,2).
move(e(3),-1,2).
serve(e(1),3).
serve(e(2),3).
serve(e(3),3).
move(e(1),-1,4).
move(e(2),-1,4).
serve(e(1),5).
serve(e(2),5).
*%

%*
move(e(1),1,1).
serve(e(2),1).
move(e(3),-1,1).
move(e(1),1,2).
move(e(2),-1,2).
move(e(3),-1,2).
serve(e(1),3).
serve(e(2),3).
serve(e(3),3).
move(e(1),-1,4).
move(e(2),-1,4).
move(e(3),-1,4).
serve(e(1),5).
serve(e(2),5).
*%

%*
move(e(1),1,1).
serve(e(2),1).
move(e(3),-1,1).
serve(e(1),2).
move(e(2),-1,2).
move(e(3),-1,2).
move(e(1),1,3).
serve(e(2),3).
move(e(3),-1,3).
serve(e(1),4).
move(e(2),-1,4).
move(e(3),1,4).
serve(e(2),5).
serve(e(3),5).
*%

%*
move(e(1),1,1).
serve(e(2),1).
move(e(3),-1,1).
serve(e(1),2).
move(e(2),-1,2).
move(e(3),-1,2).
move(e(1),1,3).
serve(e(2),3).
serve(e(3),3).
serve(e(1),4).
move(e(2),-1,4).
serve(e(2),5).
*%

%*
move(e(1),1,1).
serve(e(2),1).
move(e(3),-1,1).
serve(e(1),2).
move(e(2),-1,2).
move(e(3),-1,2).
move(e(1),1,3).
serve(e(2),3).
serve(e(3),3).
serve(e(1),4).
move(e(2),-1,4).
move(e(3),-1,4).
serve(e(2),5).
*%
