# ASP_elevator_confromant_planning

This repository demonstrates how to solve a **conformant planning problem** using **Answer Set Programming (ASP)** in the context of elevator control systems, leveraging the **Clingo** solver.

---

## 🧩 Problem Overview

This ASP encoding models the **conformant planning logic for multiple elevators**. Unlike classical planning, **conformant planning** deals with **incomplete knowledge of the initial state** and requires finding plans that **always work**, regardless of this uncertainty.

### 🏙️ Objective

- Manage multiple elevators that:
  - Respond to **floor calls** (from passengers on specific floors)
  - Fulfill **delivery requests** (where a specific elevator must reach a target floor)
- Elevators **start at unknown initial positions**
- The goal is to produce a plan that guarantees **all requests are served**, regardless of the unknowns

---

## 🔍 Planning Features

- **Elevators can move or serve** (pick up or drop off) at each step
- Requests are:
  - `call(F)` → a call at floor `F`
  - `deliver(E,F)` → a delivery for elevator `E` to floor `F`
- Each elevator may start on **any floor** unless otherwise specified
- Planning must be **safe and valid for every possible initial configuration**
- Actions are subject to **preconditions** and **conditional effects**

---

## ✅ Completed Tasks

This repository builds up the final model step by step through several tasks:



### 🧱 Task 1 – Initial States

Define the **initial states** such that:
- All elevators can **start from any floor**
- Requests (`call`, `deliver`) can be either active (`1`) or inactive (`0`)

📌 This abstracts the initial uncertainty, allowing the conformant planner to consider **all possible elevator starting positions**.



### 🎯 Task 2 – Goal Definition

The goal is satisfied when:
- **All call and delivery requests** are **no longer active**, i.e., they’ve been served.

```asp
goal(call(F), 0).
goal(deliver(E,F), 0).
```


### 🚀 Task 3 – Elevator Movement Logic
Define the move(E,D) action:

Elevators can move up (D = 1) or down (D = -1) only if the next floor exists

Elevators stay on the same floor otherwise

📌 Movement is subject to:

The elevator being on the current floor (precondition)

The target floor being valid (postcondition)



### 🤝 Task 4 – Serving Logic
Define the serve(E) action with three cases:

✅ Always Serve a Call
If there's a call on the current floor, it must be served

✅ Must Serve a Delivery
If no call exists on the current floor, the delivery must be served

⚖️ May Serve a Delivery (Nondeterministic)
If both a call and delivery exist, delivery may or may not be served

📌 Uses conditional effects and preconditions based on floor status



### 🧠 Task 5 – Directional Control
Add control logic to prevent elevators from turning back after already reversing direction.

If an elevator has already moved up and then down, it can no longer go up again.


## 📁 Repository Structure
File / Folder	Description
elevator_conformant_planning.lp	                      Main logic for conformant elevator planning
instance01.lp – instance08.lp	                        Example problem instances for testing
../encodings/incmode.lp	                              Incremental solving control (Clingo)
../encodings/sequential.lp	                          Time-step based planning model
../encodings/forall.lp	                              Universal goal enforcement (all goals must be achieved)
../encodings/exists.lp	                              Existential goal enforcement (some goal alternatives)

## 🧪 How to Run
Make sure you have Clingo installed.
Run the planner with different instance files using: https://github.com/potassco/clingo.git

```bash
clingo ../encodings/incmode.lp ../encodings/sequential.lp elevator_conformant_planning.lp instance06.lp --stats
clingo ../encodings/incmode.lp ../encodings/sequential.lp elevator_conformant_planning.lp instance07.lp --stats
clingo ../encodings/incmode.lp ../encodings/sequential.lp elevator_conformant_planning.lp instance08.lp --stats
```

You can also test other planning semantics using:

```bash
clingo ../encodings/incmode.lp ../encodings/forall.lp elevator_conformant_planning.lp instance08.lp --stats
clingo ../encodings/incmode.lp ../encodings/exists.lp elevator_conformant_planning.lp instance04.
```


## 📊 Conformant Planning vs Classical Planning

Feature	                            Conformant Planning              	Classical Planning
Initial State Known?	              ❌ No (uncertainty)	              ✅ Yes
Guarantees for All Scenarios?	      ✅ Yes	                          ❌ Only works for known state
Plan Robustness	                    ✅ Very high	                    ⚠️ Fragile to state changes
Use Case	                          Real-world uncertainty	          Simulations, static systems


## 🧠 Key Learnings

ASP enables complex planning and reasoning under uncertainty.

Conditional effects and non-determinism are core tools in conformant planning.

Adding control knowledge helps optimize and restrict the solution space.

---

## Related Project
If you're interested in the previous version (classical planning without uncertainty), check it out here: https://github.com/EdordoPng/ASP_elevator/tree/main
