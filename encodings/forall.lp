% literals of initial state
#program base.

order(X,V1,V2, 1) :- contains(X,V1), contains(X,V2), V1 < V2,
                     V <= V1 : contains(X,V), V < V2.
order(X,V2,V1,-1) :- order(X,V1,V2,1).

postcondition(A,C,X) :- postcondition(A,C,X,V).
postcondition(A,C)   :- postcondition(A,C,X).

alter(A,C,X,V) :- postcondition(A,C,X,V), not precondition(A,X,V),
                                          not precondition(C,X,V).
alter(A,C,X)   :- alter(A,C,X,V).
alter(A,X)     :- alter(A,C,X).
oneof(A,X)     :- alter(A,C,X), #count{V : postcondition(A,C,X,V)} > 1.

merge(A,X,V) :- oneof(A,X), postcondition(A,C,X,V).
agree(A,X,V) :- merge(A,X,V), postcondition(A,C,X,V) : postcondition(A,C,X).

adopt(A,X,V) :- agree(A,X,V),
                #min{V' : agree(A,X,V'), not goal(X,V')} = V.
adopt(A,X,V) :- agree(A,X,V), goal(X,V') : agree(A,X,V').
adopt(A,X)   :- adopt(A,X,V).

commit(A,C,X,V) :- postcondition(A,C,X,V), adopt(A,X,V) : adopt(A,X).
modify(A,C,X,V) :- commit(A,C,X,V), alter(A,C,X,V).

holds(X,V,0) :- initialState(X,V),
                #min{V' : initialState(X,V'), not goal(X,V')} = V.
holds(X,V,0) :- initialState(X,V), goal(X,V') : initialState(X,V').

% assert literals of goal (for t = 0,1,2,...)
#program check(t).

:- query(t), goal(X,V), not holds(X,V,t).

% specify state transitions (for t = 1,2,...)
#program step(t).

state(t).

{holds(X,V,t) : contains(X,V)} = 1 :- variable(X).

{occurs(A,t)} :- action(A).
active(A,C,t) :- postcondition(A,C), occurs(A,t),
                 holds(X,V,t-1) : precondition(C,X,V).

:- active(A,C,t), postcondition(A,C,X),
   not holds(X,V,t) : commit(A,C,X,V).
:- holds(X,V,t), not holds(X,V,t-1),
   not active(A,C,t) : modify(A,C,X,V).

:- occurs(A,t), precondition(A,X,V), not holds(X,V,t-1).

stable(X,t) :- occurs(A,t), precondition(A,X,V), not alter(A,X).
stable(X,t) :- occurs(A,t), postcondition(A,C), precondition(C,X,V),
               not alter(A,X).
:- occurs(A,t), alter(A,X), stable(X,t).

single(X,t) :- occurs(A,t), oneof(A,X).
single(X,t) :- occurs(A,t), alter(A,X), precondition(A,X,V).
single(X,t) :- occurs(A,t), alter(A,X), precondition(C,X,V), postcondition(A,C).
:- single(X,t), #count{A : occurs(A,t), postcondition(A,C,X,V)} > 1.

% check for counterexample(s)
#program check(t).

cholds(X,V,0,t) : initialState(X,V) :- variable(X).

cfalse(X,V2,D,T,t) :- order(X,V1,V2,D), cholds(X,V1,T-1,t), state(T).
cfalse(X,V2,D,T,t) :- order(X,V1,V2,D), cfalse(X,V1,D,T,t).
cfalse(X,V2,T,t)   :- cfalse(X,V2,D,T,t).

ccando(A,T,t) :- action(A), state(T), not occurs(A,T).
ccando(A,T,t) :- action(A), state(T), cholds(X,V,T-1,t) : precondition(A,X,V).
ccando(T,t)   :- state(T), ccando(A,T,t) : action(A).

cactive(A,C,T,t) :- postcondition(A,C), occurs(A,T),
                    cholds(X,V,T-1,t) : precondition(C,X,V).
cnonact(A,C,T,t) :- postcondition(A,C), state(T), not occurs(A,T).
cnonact(A,C,T,t) :- postcondition(A,C), precondition(C,X,V), cfalse(X,V,T,t).
cnonact(X,T,t)   :- variable(X), state(T), cnonact(A,C,T,t) : alter(A,C,X).

csound(X,T,t) :- contains(X,V), state(T),
                 cnonact(A,C,T,t) : postcondition(A,C,X),
                                not postcondition(A,C,X,V).
csound(T,t)   :- ccando(T,t), csound(X,T,t) : variable(X).

cholds(X,V,T,t) :- cholds(X,V,T-1,t), cnonact(X,T,t), csound(T,t).
cholds(X,V,T,t) : postcondition(A,C,X,V) :- postcondition(A,C,X),
                                            cactive(A,C,T,t), csound(T,t).

cgoal(t) :- cholds(X,V,t,t) : goal(X,V).
cgoal(t) :- not query(t).
:- not cgoal(t).

cholds(X,V,0,t)  :- contains(X,V), cgoal(t).
cholds(X,V,T,t)  :- contains(X,V), state(T), cgoal(t).
cfalse(X,V,T,t)  :- contains(X,V), state(T), cgoal(t), not order(X,V,_,_).
cactive(A,C,T,t) :- postcondition(A,C), state(T), cgoal(t).

% restrict output to applied actions
#show occurs/2.

%* example calls:
$ clingo incmode.lp forall.lp ../bomb/task.lp --stats
$ clingo incmode.lp forall.lp ../bomb/task.lp --stats --const n=8
$ clingo incmode.lp forall.lp ../bomb/task.lp --stats --const n=8 <(echo "#program check(t). :- query(t), t < 15.")

$ clingo incmode.lp forall.lp ../grid/task.lp --stats
$ clingo incmode.lp forall.lp ../grid/task.lp --stats --const n=3
$ clingo incmode.lp forall.lp ../grid/task.lp --stats --const n=3 <(echo "#program check(t). :- query(t), t < 12.")

$ clingo incmode.lp forall.lp ../maze/task.lp --stats
$ clingo incmode.lp forall.lp ../maze/task.lp --stats --const n=6
$ clingo incmode.lp forall.lp ../maze/task.lp --stats --const n=6 <(echo "#program check(t). :- query(t), t < 8.")
*%
