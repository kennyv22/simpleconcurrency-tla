-------------------------- MODULE Microwave  --------------------------

EXTENDS TLC, Integers, FiniteSets

CONSTANTS 
    OFF, ON, CLOSED, OPEN

VARIABLES 
    door,
    running,
    timeRemaining

vars == << door, running, timeRemaining >>

TypeOK == door \in { CLOSED, OPEN } /\ running \in { OFF, ON } /\ timeRemaining \in Nat

DoorSafety == TRUE

\* DoorSafety == [](door = OPEN => running = OFF)

HeatLiveness == TRUE

\* HeatLiveness == running = ON ~> running = OFF

MaxTime == 60

Init ==
    /\ door = CLOSED
    /\ running = OFF
    /\ timeRemaining = 0

IncTime ==
    /\ running = OFF
    /\ timeRemaining' = timeRemaining + 1
    /\ timeRemaining' <= MaxTime
    /\ UNCHANGED << door, running >>

Start ==
    /\ timeRemaining > 0
    /\ running' = ON
    /\ UNCHANGED << door, timeRemaining >>

Cancel ==
    \/  /\ running = OFF
        /\ timeRemaining' = 0
        /\ UNCHANGED << door, running >>
    \/  /\ running = ON
        /\ running' = OFF
        /\ UNCHANGED << door, timeRemaining >>

Tick ==
    /\ running = ON
    /\ timeRemaining' = timeRemaining - 1
    /\ timeRemaining >= 0
    /\ IF timeRemaining' = 0 THEN running' = OFF ELSE UNCHANGED << running >>
    /\ UNCHANGED << door >>

OpenDoor ==
    /\ door' = OPEN
    /\ UNCHANGED << running, timeRemaining >>

CloseDoor ==
    /\ door' = CLOSED
    /\ UNCHANGED << running, timeRemaining >>

Fairness == WF_timeRemaining(Tick)

Next ==
    \/ IncTime
    \/ Start
    \/ Cancel
    \/ OpenDoor
    \/ CloseDoor
    \/ Tick

Spec == Init /\ [][Next]_vars \* /\ WF_vars(Tick)

====

(* other possible events
      action := "10min"
      action := "1min"
      action := "10sec"
      action := "1sec"
      action := "power"
      action := "timer"
*)
