
% Authors : Diana Edoardo

% auxiliary predicates

direction(1;-1).

elevator(E) :- init(E,F).

% state variables and values

contains(E,F) :- elevator(E), floor(F).

contains(call(F),0) :- floor(F).
contains(call(F),1) :- floor(F), call(F).

contains(deliver(E,F),0) :- elevator(E), floor(F).
contains(deliver(E,F),1) :- elevator(E), floor(F), deliver(E,F).

variable(X) :- contains(X,V).

% initial state(s)

initialState(call(F),V) :- contains(call(F),V),
                       not contains(call(F),V+1).

initialState(deliver(E,F),V) :- contains(deliver(E,F),V),
                            not contains(deliver(E,F),V+1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Task 1
%* TASK:

- Complete the initial state(s) definition such that each elevator may start
  from any of the floors.
*%

% We have that for each pair of elevator and floor atoms that are true we get the head of this rule, the inital state  
initialState(E,F) :- elevator(E), floor(F).


% goal state(s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Task 2
%* TASK:

- Define the predicate goal/2 such that all call and delivery requests must
  have been served by the elevators.
*%
% goal state(s)

% We need to express that the call and deliver requests must be satisfied  
goal(call(F), 0) :- contains(call(F), 1).

goal(deliver(E,F), 0) :- contains(deliver(E,F), 1).

% actions

action(move(E,D)) :- elevator(E), direction(D).
action(serve(E))  :- elevator(E).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Task 3
%* TASK:

- Define the preconditions and conditional effects of the move(E,D) action
  such that an elevator E moves by one floor in direction D if a next floor
  in direction D exists, or elevator E stays at its current floor otherwise.
*%

% We want to prohibit that the elevator goes in floors that not exsists 

% We have no explicit precondition for the move action.

% If we perform the move action in a direction from a floor that exists and the next floor also exist, we can apply 
% the postcondition to the action.

% If an elevator want to move from a precise floor, we need to request that the elevator must be really there.
% The conditional effect "elevator_floor(E,F)", if applied, set the elevator to be in the wanted floor.
postcondition(move(E,D), elevator_floor(E,F), E, F+D) :- action(move(E,D)), floor(F), floor(F+D).

% The effect needs that the elevator must be in that floor
precondition(elevator_floor(E,F), E, F) :- elevator(E), floor(F).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Task 4
%* TASK:

- Define the preconditions and conditional effects of the serve(E) action
  such that an elevator E
  * always serves a call request at its current floor (if any),
  * is guaranteed to serve a delivery request at its current floor (if any)
    in case there is no yet unserved call request at the same floor, and
  * may non-deterministically serve a delivery request or not in case both
    a delivery and call request are yet unserved at the current floor.
*%

% ------ always serves a call request at its current floor (if any)

% We have no real precondition to apply the serve action, but there would be diffrent situations if we have a call
% or a deliver request.

% In the context of the call request the postcondition of the action would be that the call request isn't active anymore.
% So the call at that floor is has been satisfied.
% Also in this case we need to use a condition for the effect. 

% We identify this condition again as elevator_floor(E,F) 
postcondition(serve(E), elevator_floor_to_serve_call(E,F), call(F), 0) :- action(serve(E)), call(F).
% Conditional effect request that the alevator E is at the floor F
precondition(elevator_floor_to_serve_call(E,F), E, F) :- elevator(E), floor(F).

% ------ is guaranteed to serve a delivery request at its current floor (if any)
% ------ in case there is no yet unserved call request at the same floor

% Following the commonsense, an elevator that is going to a target floor will stop if a call request is active for 
% a floor that the elevator will visit during his transit to reach the target floor.

% So we decided to prioritize the call request respect the deliver one.
% This means that we will satisfy the deliver request only if there is not a call request active for that floor.
% If a deliver request is active at a floor for a specific elevator, the post condition of the action will be 
% that the deliver request is now satisfied.
% Like said before, there is not a precondition to the serve action, instead we need to make conditional the effect.
% To make this possible we set the condition, we identify it as if_no_active_call
postcondition(serve(E), if_no_active_call(E,F), deliver(E,F), 0) :- action(serve(E)), deliver(E,F).

% We firstly request that the elevator must be in that floor
precondition(if_no_active_call(E,F), E, F) :- elevator(E), floor(F).
% Then we can request that at that floor for that elevator there is not an active call request.
precondition(if_no_active_call(E, F), call(F), 0) :- elevator(E), floor(F).


% ------ may non-deterministically serve a delivery request or not in case both
% ------ a delivery and call request are yet unserved at the current floor

% We make it clear that is not requested a precondition to the serve action
% About the postcondiftion instead, we said that we want a non deterministic consequence to the action.
% We specify that the deliver request for that floor and elevator, could be both satisfied or not.
% Using (0;1) is the focal point to apply non determinism.
% Even in this case we need to specify some conditions for the effect, it's again conditioned.
postcondition(serve(E), if_active_call(E,F), deliver(E,F), (0;1)) :- action(serve(E)), deliver(E,F), call(F).

% The elevator E that needs firstly to be at that floor.
precondition(if_active_call(E,F), E, F) :- elevator(E), floor(F).
% Secondly at that floor it needs to be active a call request.
precondition(if_active_call(E,F), call(F), 1) :- elevator(E), floor(F). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Task Bonus

%* TASK:

- Specify domain-specific control knowledge (in a "#program step(t)." block)
  to reject conformant plans such that some elevator turns more than once.
  That is, move(E,D) actions should not occur anymore when move(E,D) followed
  by move(E,-D) have occurred already.
*%

#program step(t).

% #########################################################################

% I had sequential plans in mind, where the moves in different directions may have serve actions in-between 
% and we don't know whether an elevator E moves in a direction D at the previous time t-1 and in the opposite
% direction -D at time t. 
% Rather, it could be that the move in direction D is at time t-2, then a serve at time t-1, and the move in the opposite direction -D at time t. 

% In general, it shouldn't matter how big the time difference between moves in the different directions D and -D is, 
% but the turn should be detected in any case.

% This issue isn't yet addressed by the rules written below, but the following rules may be a starting point for completion:

moved(E, D, t) :- occurs(move(E, D), t-1).
moved(E, D, t) :- moved(E, D, t-1).

turned(E, D, t) :- occurs(move(E, -D), t-1), moved(E, D, t-1).
turned(E, D, t) :- turned(E, D, t-1).

% The idea is that :  
%       moved(E, D, t) signals that an elevator E moved in direction D at any time before t, and similarly 
%       turned(E, D, t) signals that a turn was made by the elevator E moving in the opposite direction -D before t. 

% This information may be used to forbid moving in the direction D again after turning away from D.
:- turned(E, D, t), occurs(move(E, D), t).


% ----------------------------------------  End of code ---------------------------------------- 


%* NOTE:

- The init/2 facts and classical plans reported in the instance files stem
  from the multi-shot ASP version of the elevator planning task. In the new
  context of conformant planning, we take the initial floors of the elevators
  as unknown, and (shortest) conformant plans are longer than classical plans.
*%


% Note : Inside the folder there are input scripts: 

%     instance01
%     instance02
%     instance03 
%     instance04
%     instance05
%     instance06 
%     instance07
%     instance08 

% They were created to better test the sequential encoding in a resonable amount of time. 

% Use this line to call the script :

% clingo ../encodings/incmode.lp ../encodings/sequential.lp elevator_conformant_planning.lp instance06.lp --stats
% clingo ../encodings/incmode.lp ../encodings/sequential.lp elevator_conformant_planning.lp instance07.lp --stats
% clingo ../encodings/incmode.lp ../encodings/sequential.lp elevator_conformant_planning.lp instance08.lp --stats

%* EXAMPLE CALLS:

$ clingo ../encodings/incmode.lp ../encodings/sequential.lp elevator_conformant_planning.lp instance07.lp --stats

$ clingo ../encodings/incmode.lp ../encodings/forall.lp elevator_conformant_planning.lp instance08.lp --stats

$ clingo ../encodings/incmode.lp ../encodings/exists.lp elevator_conformant_planning.lp instance04.lp --stats
*%


