extensions [http-req]
globals [
  num-robots 		;; number of robots including base station
  disk-radius 	;; radius for the delta-disk connectivity graph
  disk-radius-invsqrt

  clicked1_x clicked1_y 	;; used to cache the coordinates for the first click.
  clicked2_x clicked2_y		;; used to cache the coordinates for the second click.
  pointed-mode ;; Stores name of the pointed mode if any pointed mode is currently being executed
  selected ;; "agentset" of selected robots. Any further commands will be executed by these robots. Empty by default.
  pointed-color ;; stores the color for the pointed mode behavior
  points
  info-decay-rate
  mode-flag ;;first time hit main for instructions

  tut-mode  ;;this is a tutorial mode flag, true if we are in tut mode

  basex ;;coords of the base
  basey
  click-mode  ;;mode for selecting stuff

  ;;logging stuff below->
  logstr ;;this is the userID
  logstate ;;counter that counts up set interval
]
;;these are breeds for the different types of turtles
breed [bases base]
breed [robots robot]
breed [persons person]

breed [sides side]

;; these are breeds for the links
undirected-link-breed [peoplelinks peoplelink]
undirected-link-breed [robotlinks robotlink]


;; each patch has a local variable named occupied - a boolean that is true if it is occupied
patches-own [occupied closest-robot]
;; local variables for turtles
;; mode is the variable for each turtle that decides which behavior it should have eg: go-to, rendezvous, deploy
;; (xtarget, ytarget) stores the coordinates of the target that the agent has to either move towards
;; reachable - flag that is true if the agent is connected to the base station. Only agents that are reachable can be selected.
;;countdown tells you how long until you have to go back to the base
robots-own [mode xtarget ytarget reachable vx vy countdown]
persons-own [info retreived info-str]
bases-own [reachable]



to setup [modet]
  clear-ticks
  clear-turtles
  clear-patches
  clear-drawing
  clear-all-plots
  clear-output
  random-seed 47822
  set selected no-turtles
  set logstate 0
  set basex 130
  set basey 130
  set tut-mode modet
  print-instructions "start"
  set num-robots 40			;; change this to control number of robots
  set disk-radius 40		;; change this to control the connectivity radius
  setup-patches
  setup-turtles
  set points 0
  set info-decay-rate 0.001
  set disk-radius-invsqrt (1 / sqrt disk-radius)
  set-default-shape sides "line"
  setup-flags modet
  reset-ticks
  reset-timer
end

to setup-tut
  clear-all
  set logStr user-input "What is your Mechanical Turk ID?"
  set logstate 0
  set selected no-turtles
  set basex 130
  set basey 130
  set tut-mode 0

  print-instructions "start-tut"
  set num-robots 30			;; change this to control number of robots
  set disk-radius 40		;; change this to control the connectivity radius
  setup-patches
  setup-turtles
  set points 0
  set info-decay-rate 0.001
  set disk-radius-invsqrt (1 / sqrt disk-radius)
  set-default-shape sides "line"
  setup-flags 0
  reset-timer
  reset-ticks
end


;; Patch setup function - we get x and y coordinates (downsampled) from the generate maps file.
;; Use that file if you would like to change the map.
;; Those x and y coordinates are at a lower map resolution. So for each patch in the map generator 16 patches in this file are occupied.
to setup-patches
  ;; all patches are free
  ask patches [set occupied false
  							set pcolor white]
  ;; get downsampled coordinates from map generator
  let map-x [0]
  let map-y [0]
  (ifelse tut-mode = 0 [
    set map-x [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0                                                                                                                                   0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 -16 -17 -18 -19 -20 -21 -22 -23 -24 -25 -26 -27 -28 -29 -30 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 -41 -42 -43 -44 -45 -46 -47 -48 -49 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17  33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49]
    set map-y [0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 -16 -17 -18 -19 -20 -21 -22 -23 -24 -25 -26 -27 -28 -29 -30 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 -41 -42 -43 -44 -45 -46 -47 -48 -49  0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0                                                                                               0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0  0 0 0 0 0 0 0]
    let i -200

    while [i < 0] [
      let j -200
      while [j < 0] [
        ask patch (i) (j) [set occupied true]
        set j j + 1
      ]
      set i i + 1
    ]
  ] tut-mode = 1 [
    set map-x [49 49 49 49 49 49 49 49 48 48 48 48 48 48 48 48 47 47 47 47 47 47 47 47 47 47 47 47 47 47 47 47 46 46 46 46 46 46 46 46 46 46 46 46 46 46 46 46 46 46 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 43 43 43 43 43 43 43 43 43 43 43 43 43 43 43 43 43 43 42 42 42 42 42 42 42 41 41 41 41 41 41 41 40 40 40 40 40 40 40 40 40 40 40 40 40 39 39 39 39 39 39 39 39 38 38 38 38 38 38 38 38 38 38 38 38 38 37 37 37 37 37 37 37 37 37 37 37 37 37 37 37 37 37 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 35 35 35 35 35 35 35 35 35 35 35 35 35 35 35 35 35 35 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 24 24 24 23 23 23 22 22 22 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 19 19 19 19 19 19 19 19 19 19 19 19 18 18 18 18 18 18 18 18 18 17 17 17 17 17 17 16 16 16 16 16 16 15 15 15 15 15 15 14 14 14 14 14 14 14 13 13 13 13 13 13 13 12 12 12 12 12 12 12 11 11 11 11 11 11 11 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 7 7 7 7 7 7 7 7 7 6 6 6 6 6 6 6 6 6 6 6 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 3 3 3 3 2 2 2 2 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -8 -8 -8 -9 -9 -9 -10 -10 -10 -11 -11 -11 -12 -12 -12 -12 -12 -12 -13 -13 -13 -13 -13 -14 -14 -14 -14 -14 -14 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -28 -28 -29 -29 -29 -29 -29 -29 -29 -30 -30 -30 -30 -30 -30 -30 -30 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -33 -33 -33 -33 -33 -33 -33 -33 -33 -33 -33 -33 -33 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -49 -50]
    set map-y [26 25 24 23 5 4 3 2 26 25 24 23 5 4 3 2 34 33 32 31 30 29 28 27 26 25 24 23 5 4 3 2 34 33 32 31 30 29 28 27 26 5 4 3 2 -27 -28 -29 -30 -31 44 43 42 41 40 34 33 32 31 30 29 28 27 26 5 4 3 2 -27 -28 -29 -30 -31 -47 -48 44 43 42 41 40 34 33 32 31 30 29 28 27 26 5 4 3 2 1 -27 -28 -29 -30 -31 -47 -48 44 43 42 41 40 34 33 32 31 30 29 28 27 26 2 1 -47 -48 44 43 42 41 40 -47 -48 44 43 42 41 40 -47 -48 44 43 42 41 40 2 1 0 -1 -2 -3 -47 -48 2 1 0 -1 -2 -3 -47 -48 2 1 0 -1 -2 -3 -26 -27 -28 -29 -30 -47 -48 13 12 11 10 2 1 0 -1 -2 -3 -26 -27 -28 -29 -30 -47 -48 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -26 -27 -28 -29 -30 -47 -48 13 12 11 10 9 8 7 6 5 4 3 -26 -27 -28 -29 -30 -47 -48 13 12 11 10 9 8 7 6 5 4 3 -26 -27 -28 -29 -30 47 46 45 9 8 7 6 5 4 3 -26 -27 -28 -29 -30 -34 -35 -36 -37 -38 -39 -40 47 46 45 9 8 7 6 5 4 3 -26 -27 -28 -29 -30 -34 -35 -36 -37 -38 -39 -40 47 46 45 9 8 7 6 5 4 3 -15 -16 -17 -18 -19 -20 -26 -27 -28 -29 -30 -34 -35 -36 -37 -38 -39 -40 47 46 45 9 8 7 6 5 4 3 -15 -16 -17 -18 -19 -20 -34 -35 -36 -37 -38 -39 -40 47 46 45 9 8 7 6 5 4 3 2 1 -15 -16 -17 -18 -19 -20 -34 -35 -36 -37 -38 -39 -40 9 8 7 6 5 4 3 2 1 -15 -16 -17 -18 -19 -20 -33 -34 -35 -36 -37 -38 -39 -40 -43 -44 -45 -46 28 27 26 25 24 9 8 7 6 5 4 3 2 1 -15 -16 -17 -18 -19 -20 -43 -44 -45 -46 48 47 46 28 27 26 25 24 5 4 3 2 1 -15 -16 -17 -18 -19 -20 -43 -44 -45 -46 48 47 46 28 27 26 25 24 -15 -16 -17 -18 -19 -20 -43 -44 -45 -46 48 47 46 48 47 46 48 47 46 -21 -22 -23 -24 -35 -36 -37 -38 -39 -40 -41 -42 -43 -44 -45 49 48 47 46 37 36 35 34 33 32 31 30 29 -35 -36 -37 -38 -39 -40 -41 -42 -43 -44 -45 37 36 35 34 33 32 31 30 29 -43 -44 -45 30 29 28 27 26 25 -43 -44 -45 30 29 28 27 26 25 30 29 28 27 26 25 30 29 28 27 26 25 -8 -9 -10 -11 -12 -13 -14 -8 -9 -10 -11 -12 -13 -14 -8 -9 -10 -11 -12 -13 -14 -8 -9 -10 -11 -12 -13 -14 45 44 43 42 41 36 35 34 -8 -9 -10 -11 -12 -13 -14 -27 -28 -29 -30 -37 -38 -39 -40 45 44 43 42 41 36 35 34 -8 -9 -10 -11 -12 -13 -14 -27 -28 -29 -30 -37 -38 -39 -40 45 44 43 42 41 -8 -9 -10 -11 -12 -13 -14 -27 -28 -29 -30 -37 -38 -39 -40 45 44 43 42 41 -27 -28 -29 -30 45 44 43 42 41 4 3 -27 -28 -29 -30 45 44 43 42 41 30 29 4 3 -27 -28 -29 -30 30 29 4 3 -27 -28 -29 -30 30 29 4 3 30 29 4 3 30 29 4 3 30 29 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 30 29 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 30 29 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 30 29 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 30 29 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 32 31 30 29 28 27 26 25 24 23 -23 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 49 48 30 29 -23 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 49 48 30 29 -23 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 49 48 -23 49 48 -23 49 48 -23 49 48 -23 49 48 -13 -14 -15 -23 49 48 -13 -14 -15 14 13 12 -13 -14 -15 45 44 43 42 41 40 39 38 14 13 12 11 45 44 43 42 41 40 39 38 14 13 12 11 45 44 43 42 41 40 39 38 14 13 12 11 -14 -15 -16 -17 45 44 43 42 41 40 39 38 14 13 12 11 -14 -15 -16 -17 -25 -26 -27 -28 -29 45 44 43 42 41 40 39 38 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -18 -19 -25 -26 -27 -28 -29 45 44 43 42 41 40 39 38 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -18 -19 -25 -26 -27 -28 -29 45 44 43 42 41 40 39 38 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -18 -19 -25 -26 -27 -28 -29 45 44 43 42 41 40 39 38 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -46 -47 -48 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -46 -47 -48 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -46 -47 -48 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -46 -47 -48 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -37 -38 -46 -47 -48 -37 -38 -30 -31 -32 -33 -34 -37 -38 42 -30 -31 -32 -33 -34 -37 -38 47 46 45 44 43 42 16 15 14 -30 -31 -32 -33 -34 -37 -38 -45 -46 47 46 45 44 43 42 16 15 14 -30 -31 -32 -33 -34 -37 -38 -45 -46 47 46 45 44 43 42 16 15 14 -37 -38 -45 -46 47 46 45 44 43 42 31 16 15 14 -37 -38 -45 -46 47 46 45 44 43 42 31 30 29 28 27 26 25 24 23 22 16 15 14 -37 -38 -45 -46 47 46 45 44 43 42 31 30 29 28 27 26 25 24 23 22 16 15 14 -37 -38 -45 -46 42 31 30 29 28 27 26 25 24 23 22 16 15 14 -37 -38 -45 -46 31 30 29 28 27 26 25 24 23 22 16 15 14 -37 -38 -45 -46 30 29 28 27 26 25 24 23 22 16 15 14 -3 -4 -5 -6 -7 -8 -9 -10 -11 -13 -14 -45 -46 49 30 29 28 27 26 25 24 23 22 16 15 14 -3 -4 -5 -6 -7 -8 -9 -10 -11 -13 -14 -45 -46 49 30 29 28 27 26 25 24 23 22 16 15 14 -3 -4 -5 -6 -7 -8 -9 -10 -11 -13 -14 -45 -46 49 30 29 28 27 26 25 24 23 22 16 15 14 8 7 6 5 4 3 -3 -4 -5 -6 -7 -8 -9 -10 -11 -13 -14 -21 -22 -23 -45 -46 49 30 29 28 27 26 25 24 23 22 8 7 6 5 4 3 -3 -4 -5 -6 -7 -8 -9 -10 -11 -21 -22 -23 -45 -46 49 24 23 22 8 7 6 5 4 3 -3 -4 -5 -6 -7 -8 -9 -10 -11 -21 -22 -23 49 8 7 6 5 4 3 -3 -4 -5 -6 -7 -8 -9 -10 -11 -21 -22 -23 49 8 7 6 5 4 3 -3 -4 -5 -6 -7 -8 -9 -10 -11 -21 -22 -23 49 8 7 6 5 4 3 -3 -4 -5 -6 -7 -8 -9 -10 -11 -30 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 49 7 6 5 4 -3 -4 -30 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 49 49]
  ] [
    set map-x [49 49 49 49 48 48 48 48 47 47 47 47 46 46 46 46 46 45 45 45 45 45 44 44 44 44 43 43 43 43 43 42 42 42 42 42 41 41 41 40 40 40 39 39 38 38 38 37 37 36 36 36 35 35 35 34 34 34 34 34 33 33 33 33 33 33 33 33 33 33 33 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 31 31 31 30 30 30 29 29 29 29 28 28 28 28 23 23 23 22 22 22 21 21 21 20 20 19 19 18 18 17 16 16 15 14 14 13 12 11 11 11 11 11 11 11 11 11 10 10 10 10 10 10 10 10 10 10 10 10 10 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -8 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -9 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -11 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -12 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -13 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -14 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -21 -21 -22 -22 -23 -23 -24 -24 -24 -25 -25 -26 -27 -27 -28 -29 -30 -31 -32 -32 -33 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -35 -35 -35 -35 -35 -35 -36 -36 -36 -36 -36 -36 -36 -36 -37 -37 -37 -37 -37 -37 -38 -38 -38 -38 -38 -38 -38 -38 -39 -39 -39 -39 -39 -39 -39 -40 -40 -40 -40 -40 -40 -40 -41 -41 -41 -41 -41 -42 -42 -42 -42 -42 -43 -43 -43 -43 -43 -43 -44 -44 -44 -44 -44 -45 -45 -45 -45 -45 -45 -46 -46 -46 -46 -46 -46 -46 -47 -47 -47 -47 -47 -47 -47 -48 -48 -48 -48 -48 -48 -48 -49 -49 -49 -49 -49 -49 -49 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50 -50]
    set map-y [23 -1 -26 -49 23 -1 -26 -49 23 -1 -26 -48 23 -1 -26 -47 -48 23 -1 -26 -46 -47 23 -1 -26 -46 23 -1 -26 -45 -46 23 -25 -26 -44 -45 23 -25 -44 23 -43 -44 23 -43 23 -42 -43 23 -42 23 -41 -42 23 -40 -41 23 11 10 9 0 23 14 13 12 0 -1 -2 -3 -4 -5 -6 23 22 21 20 19 18 17 16 15 14 -7 -8 -9 -10 -11 -12 -13 -14 -15 -15 -16 -17 -18 -19 -20 -20 -21 -22 -23 -23 -24 -25 -26 -39 -40 -41 -41 -42 -43 -43 -44 -45 -45 -46 -46 -47 -47 -48 -48 -48 -49 -49 -49 -50 -50 -50 49 48 47 46 45 44 43 -48 -49 43 20 19 18 17 16 15 14 13 12 11 -47 -48 43 42 22 21 20 19 18 17 16 15 14 13 12 11 10 -45 -46 42 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 -44 -45 42 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 -42 -43 -44 42 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 -40 -41 -42 42 41 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -39 -40 41 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -39 41 40 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -39 40 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -39 40 39 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -39 38 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -39 46 45 44 43 42 41 40 39 38 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -38 38 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -38 38 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -38 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -39 -40 37 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 -41 37 20 19 18 17 16 15 14 13 -41 -42 49 48 47 46 45 44 43 42 41 40 39 38 37 -42 -42 -43 -43 -44 -44 -45 -45 -46 -47 -47 -48 -48 -48 -49 -49 -49 -49 -49 -49 -50 -50 49 48 47 46 45 44 43 42 41 40 39 38 37 10 -4 -16 -28 37 25 10 -4 -16 -28 37 25 11 10 -4 -16 -28 -29 37 25 11 -4 -16 -29 37 26 25 11 -4 -16 -29 -30 26 11 -4 -16 -17 -30 -31 26 11 -4 -5 -17 -31 -32 26 11 -5 -17 -32 26 11 -5 -17 -32 26 11 -5 -17 -32 -33 26 11 -5 -17 -33 37 26 12 -5 -17 -33 37 26 12 -5 -17 -33 -34 37 26 12 11 -5 -17 -34 37 26 11 -5 -17 -18 -34 37 26 11 -5 -18 -34 -35 37 26 11 -5 -18 -19 -20 -21 -22 -23 -24 -25 -26 -27 -28 -29 -30 -31 -32 -33 -34 -35]
  ])
  ;; upsample the coordinates - 16 for each - set them to be occupied
  (foreach map-x map-y [
    [a b] ->
    ask patch (4 * a) (4 * b) [set occupied true]
    ask patch (4 * a) (4 * b + 1) [set occupied true]
    ask patch (4 * a) (4 * b + 2) [set occupied true]
    ask patch (4 * a) (4 * b + 3) [set occupied true]
    ask patch (4 * a + 1) (4 * b) [set occupied true]
    ask patch (4 * a + 1) (4 * b + 1) [set occupied true]
    ask patch (4 * a + 1) (4 * b + 2) [set occupied true]
    ask patch (4 * a + 1) (4 * b + 3) [set occupied true]
    ask patch (4 * a + 2) (4 * b) [set occupied true]
    ask patch (4 * a + 2) (4 * b + 1) [set occupied true]
    ask patch (4 * a + 2) (4 * b + 2) [set occupied true]
    ask patch (4 * a + 2) (4 * b + 3) [set occupied true]
    ask patch (4 * a + 3) (4 * b) [set occupied true]
    ask patch (4 * a + 3) (4 * b + 1) [set occupied true]
    ask patch (4 * a + 3) (4 * b + 2) [set occupied true]
    ask patch (4 * a + 3) (4 * b + 3) [set occupied true]
  ])

  let i -199   ;;this creates a boarder around the map
  let j 0
  let arr [-200 -199 -198 -197 -196 200 199 198 197 196]
  (foreach arr [
    [a] ->
    set i -199
    while [i < 200] [
      ask patch (i) (a) [set occupied true]
      ask patch (a) (i) [set occupied true]
      set i i + 1
    ]
  ])


  ;; occupied patches have to be black :)
  ask patches
  [if occupied = true
    [
      set pcolor black
    ]
  ]
end



to setup-flags [modet]
  let xflag []
  let yflag []
  (ifelse modet = 0[
    set xflag [120 60 180 15     25   -120  -180 -60]
    set yflag [-120 -180  -25     -80 25 185   20  110]
  ] modet = 1[
    set xflag [120    60   180     15 10 -120  -180 -60 -130   0    -170 60 -30 -75 -185]
    set yflag [-120 -180  -25     -80 35 150   10   110  -40    150 -175 60 -30 10 185]
  ][
    set xflag [120    60   180     15 175 -120  -180 -60 -130   0    -170 90 -30  75 -185]
    set yflag [-120 -180  -25     -180 35 150   10   120  -40    140 -175 60 -100 -50 185]
  ])
  (foreach xflag yflag [
    [x y] -> create-persons 1 [
      set size 12
      set label-color black
      set info 50.1
      set shape "flag"
      set color lime
      setxy x y
      set label info
    ]
  ])
end

;; agents setup function.
to setup-turtles
  ;; creating the base station
  create-bases 1
  [
    setxy basex basey
    set shape "pentagon"
    set color brown
    set size 10
    ;set mode "stop"
  ]
	;; creating all the other turtles
  create-robots num-robots
 	[
		;; change these to change where the turtles are initialized.
    ;; Currently they are centered at (50, 50) and spread out to (150, 150) (randomness).
    ;;let x 25 + (random 170)
    ;;let y 25 + (random 170)
    let x 75 + (random 120)
    let y 100 + (random 95)
    ;; if the random patch is occupied, repeat.

    while [[occupied] of patch x y = true and distance (min-one-of (other turtles) [distance myself]) < 15]
    [
      ;;set x 25 + (random 170)	;; change the same here also.
      ;;set y 25 + (random 170)
      set x 75 + (random 120)
      set y 75 + (random 120)
    ]
    setxy x y
    set color orange
    set size 8
    set mode "stop"	;; they are initially in the stopped state
  ]
  update-neighbors	;; updates the links
  set selected (robots with [color = blue])	;; by default no turtles selected less confusing.
end

to-report get-points
  ifelse tut-mode = 0 [
    report floor points ;;"/150"
  ] [
   report word floor points "/750"
  ]
end

to-report get-timer
  ifelse tut-mode = 0 [
    report word floor timer "/120"
  ] [
    report word floor timer "/420"
  ]
end


;; this is a recursive function that starts at the base station and
;; sets every connected agent to reachable. it is used at every step to update the reachable variable
;; this is called by update-neighbours, after the neighbours have been updated.
to activate-neighbors
  if reachable  = false [
    set reachable true
    ask link-neighbors [activate-neighbors]
  ]
end

to color-turtles
  ask robots with [not member? self selected] [
     (ifelse mode = "stop" [
        set color red
        ] mode = "random" [
          set color yellow - 2
        ] mode = "repel-from" [
          set color brown
        ] mode = "heading" [
          set color violet
        ] mode = "go-to" [
          set color blue
     ])
    ifelse not reachable [
      set color scale-color color 180 0 255
    ][
      set color scale-color color 128 0 255
    ]
  ]
end

;; this function uses the delta disk graph to determine which agents are connected.
;; agent i is connected to agent j if they are within disk-radius and if they do not have
;; an obstacle in between
to update-neighbors
  ;; sets neighbours based on distance alone
  clear-links
	ask robots [
    let nearby-robots (robots in-radius disk-radius)
    let myid who
    let nearby-robots-without-myself (nearby-robots with [who != myid])
    create-robotlinks-with nearby-robots-without-myself
    create-robotlinks-with bases in-radius disk-radius
  ]
  ask bases [
    create-robotlinks-with robots in-radius (disk-radius * 1.5)
  ]

  ;; removes links that have obstacle between them. this is done by scanning along the line
  ;; connecting the two agents in steps of delta.
  let delta 0.5	;; step size
  ask robotlinks [
    let start_x [xcor] of end1		;; starting at first agent
    let start_y [ycor] of end1
    let end_x [xcor] of end2			;; upto second agent
    let end_y [ycor] of end2

    let mag sqrt (((end_x - start_x) ^ 2) + ((end_y - start_y) ^ 2)) ;; distance between agents
    if mag != 0
    [
      ;; direction towards end from start
      let dir_x ((end_x - start_x) / mag)
      let dir_y ((end_y - start_y) / mag)
      ;; step along the direction in steps of delta, check if patch occupied
      (foreach (range 0.0 mag delta) [ i ->
        if [occupied] of patch (round (start_x + (i * dir_x))) (round (start_y + (dir_y * i))) [
          ;; if patch is occupied, kill this link
          die
        ]
      ])
    ]
  ]
  ;; updating reachability
  ask robots [ set reachable false ] ;; set all of them to be not reachable
  ask bases [set reachable false]
  ask bases [activate-neighbors]		;; recurse from the base station
  color-turtles
end

;; all the set-mode-<> functions. These functions are called when the buttons for the corresponding
;; modes are clicked. Some modes are "pointed" - they need a heading input (clicking on arena).

;; If it is a pointed-mode Clear the select-on, clicked-once and clicked-twice flags, set the pointed-mode flag to true.
;; Mode starts executing when the clicking is completed. Which is later. pointed-mode and pointed-color is used to cache until then.
to set-mode-heading
  ifelse count selected = 0[
  print-instructions "failed-button"
  ][
  set pointed-mode "heading"
  set pointed-color violet
  print-instructions "select-heading"
  ]
  deselect
end

to set-mode-go-to
  ifelse count selected = 0[
  print-instructions "failed-button"
  ][
  print-instructions "select-go-to"
  set pointed-mode "go-to"
  set pointed-color blue
  ]
  deselect
end

to set-mode-repel-from
  ifelse count selected = 0[
  print-instructions "failed-button"
  ][
  print-instructions "select-repel-from"
  set pointed-mode "repel-from"
  set pointed-color pink
  ]
  deselect
end

;; If it is not a pointed mode, start executing the behavior for the selected agents.
;; Also set their color.
to set-mode-stop
  let temp ""
  ask selected [
     set temp (word temp precision xcor 2 "_" precision ycor 2 "_ _ _" mode "_" "stop")
    set mode "stop"
    set color orange
  ]
  log-action temp
  deselect
  set selected no-turtles
  print-instructions "select-robots-one"
end

to set-mode-random
  let temp ""
  ask selected [
    set temp (word temp precision xcor 2 "_" precision ycor 2 "_ _ _" mode "_" "random")
    set mode "random"
    set color turquoise
    set countdown 600
  ]
  log-action temp
  deselect
  set selected no-turtles
  print-instructions "select-robots-one"
end


;; the sliding behavior on obstacles
;; since the obstacles are rectangular, when an agent hits an obstacle it has 4 options -
;; move left, right, up, down. Choosing one depends on the wall direction and the heading.
;; if horizontal and heading right, go right, else left
;; if vertical and heading down, go down, else go up.
;; takes as argument the patch in front of the agent
to slide-on-obstacle [infront]
  let x ([pxcor] of infront)
  let y ([pycor] of infront)

  let head_x 0
  let head_y 0
  ifelse (heading <= 90 or heading >= 270) [
    set head_y 1
  ][ set head_y -1 ]
  ifelse (heading <= 180) [
    set head_x 1
  ][ set head_x -1 ]

  (ifelse ((patch x (y + 1)) != nobody and [occupied] of (patch x (y + 1)) = true) and
    ((patch x (y - 1)) != nobody and [occupied] of (patch x (y - 1)) = true) and
    ((patch (x - head_x) y) != nobody and [occupied] of (patch (x - head_x) y) = false)[
      ifelse [occupied] of (patch xcor (ycor + head_y)) = false [
      	set ycor (ycor + head_y)
      ][; set heading random 360
      ]
    ]((patch (x + 1) y) != nobody and [occupied] of (patch (x + 1) y) = true) and
    ((patch (x - 1) y) != nobody and [occupied] of (patch (x - 1) y) = true) and
    ((patch x (y - head_y)) != nobody and [occupied] of (patch x (y - head_y)) = false)[
      ifelse [occupied] of (patch (xcor + head_x) ycor) = false [
      	set xcor (xcor + head_x)
      ][ ;set heading random 360
      ]
    ]((patch (x + head_x) y) != nobody and [occupied] of (patch (x + head_x) y) = true) and
    ((patch x (y + head_y)) != nobody and [occupied] of (patch x (y + head_y)) = true) [
      ifelse [occupied] of (patch (xcor + head_x) ycor) = false [
      	set xcor (xcor + head_x)
      ][ ;set heading random 360
      ]
    ][ forward 1  ]
  )
end

;; Move forward collision avoidance
;; This queries the links and then adjusts the heading like a sort of potential field from other nearby robots
to random-collison-avoid
  ;show heading
  let x-sum 0
  let y-sum 0
  let x-cor-turt xcor
  let y-cor-turt ycor
  let link-count count my-out-robotlinks
  let x-final 0
  let y-final 0
  ifelse link-count = 0[  ;;if no other agents then move forward
    forward 1
  ] [
    ask my-out-robotlinks [  ;;else try to weight and avoid them
      let x-head-link x-cor-turt - [xcor] of other-end
      let y-head-link y-cor-turt - [ycor] of other-end
      set x-sum x-sum + ((x-head-link) / (link-length)) - disk-radius-invsqrt  ;;linklength instead of sqrt
      set y-sum y-sum + ((y-head-link) / (link-length)) - disk-radius-invsqrt
    ]
    set x-sum x-sum / link-count
    set y-sum y-sum / link-count

    let x-head-turt cos heading
    let y-head-turt sin heading
    let alpha-force 0.93 ;;0.985

    set x-final (alpha-force * cos heading) + ((1 - alpha-force) * x-sum)
    set y-final (alpha-force * sin heading) + ((1 - alpha-force) * y-sum)

    set heading atan y-final x-final
    forward sqrt (x-final * x-final + y-final * y-final)
  ]
end

to collison-avoid [neg]
  ;show heading
  let x-sum 0
  let y-sum 0
  let x-cor-turt xcor
  let y-cor-turt ycor
  let link-count count my-out-robotlinks
  let x-final 0
  let y-final 0

  let xvec xtarget - x-cor-turt
  let yvec ytarget - y-cor-turt
  let magdesiredvec sqrt ((xvec * xvec) + (yvec * yvec))
  set xvec xvec / magdesiredvec
  set yvec yvec / magdesiredvec

  let minlinklength 1000

  ifelse link-count = 0[  ;;if no other agents then move forward
    set x-final xvec
    set y-final yvec
  ] [
    ask my-out-robotlinks [  ;;else try to weight and avoid them
      let x-head-link x-cor-turt - [xcor] of other-end
      let y-head-link y-cor-turt - [ycor] of other-end
      set x-sum x-sum + ((x-head-link) / (sqrt link-length)) - disk-radius-invsqrt  ;;linklength instead of sqrt
      set y-sum y-sum + ((y-head-link) / (sqrt link-length)) - disk-radius-invsqrt
      if link-length < minlinklength [
        set minlinklength link-length
      ]

    ]
    set x-sum x-sum / link-count
    set y-sum y-sum / link-count

    let alpha-force 0.94   ;;0.6 if no sqrt on link-length
    set x-final (alpha-force * xvec) + ((1 - alpha-force) * x-sum)
    set y-final (alpha-force * yvec) + ((1 - alpha-force) * y-sum)

  ]
    if neg [
    set x-final (- x-final)
    set y-final (- y-final)
  ]
  ;;show minlinklength
  ifelse (distancexy xtarget ytarget < (link-count + 0.1) * 2.5 and minlinklength < link-count * 2 ) or distancexy xtarget ytarget < 2 [
    forward 0
    set mode "stop-back"
  ][
    set heading atan x-final y-final
    forward sqrt (x-final * x-final + y-final * y-final)
  ]
end


;; the main actuation function
;; what the agent does depends on which behavior it is in
;; so this is basically a ladder of if-else for behaviors
to act
  ask robots [
    let infront (patch-ahead 1)

    (ifelse infront = nobody [
      ;; end of the world scenario
        set heading random 360
     ] mode = "stop-back" [
      ifelse reachable [
        forward 0
        set mode "stop"
      ] [
        forward -1
      ]
    ]mode = "random" [
        set countdown countdown - 1
      (ifelse countdown < 0 or not reachable [ ;;after a time go-to back to the enter
            set mode "stop-back"
        ][
            ;; keep moving straight, if you hit an obstacle turn randomly
        	  ifelse ([occupied] of infront) = false [
               random-collison-avoid ;;forward 1
            ][ set heading random 360 ]
        ]
      )
	   ] mode = "go-to" [
       ;; move to the target   	
      (ifelse not reachable [
      	set mode "stop-back"
      ]([occupied] of infront) = false [
          	collison-avoid false;;forward 1
     	][
      facexy xtarget ytarget
      	slide-on-obstacle infront
	    ])
     ] mode = "repel-from" [
       ;; move away from target
        facexy (xcor + (xcor - xtarget)) (ycor + (ycor - ytarget))
        (ifelse ([occupied] of infront) = false and reachable [
          collison-avoid true
         ] ([occupied] of infront) = true and reachable[
          slide-on-obstacle infront
	       ] [
          set mode "stop-back"
        ]
        )
      ] mode = "heading" [
       ;; move to the target
        facexy (xcor + xtarget) (ycor + ytarget)
        (ifelse ([occupied] of infront) = false and reachable [
          forward 1
         ][
          set mode "stop-back"
	       ])
       ])
   ]
end

;;This finds robots near the people and then updates the decay which updates the points
to update-points
	ask persons [
    create-peoplelinks-with robots in-radius disk-radius
    let close-robots robots in-radius disk-radius
    if info <= 0 [die]
    (ifelse timer < 12 and timer > 4[
      set retreived 0
      show-turtle
    ] (count close-robots) = 0 [
      hide-turtle
      set retreived 0
    ][
	    ;;set info (info - ((count close-robots) * 0.02))
      set retreived 0.04 ;;(count close-robots) * 0.02
      set info (info - 0.04)
      if info <= 0 [die]
      show-turtle
    ])
    set info precision info 2
    (ifelse info > 50 [
      set info-str (word 5)

    ] [
      set info-str (word info)
    ])
       ;;manually add decimal stuff so it doesn't stutter around
    (ifelse ((info - precision info 0) = 0) [
      set info-str (word info-str ".00")
    ] (info - precision info 1) = 0 [
      set info-str (word info-str "0")
    ])
    set label info-str
  ]
  set points (points + sum [retreived] of persons)
end



;; this is the forever main loop that runs once the task starts (user clicks "go").
;; we just listen for clicks and change modes here
;; and then we call update-neighbours and act functions
to main

  if mode-flag = 0 [  ;;We are running this for the first time, tutorial baby!
    print-instructions "select-robots-one"
    setup-tut
    set mode-flag 1
  ]
  if mode-flag = 2 [;;regular mode baby!
    setup 1
    set mode-flag 3
  ]
  if mode-flag = 4 [;;regular mode baby!
    setup 2
    set mode-flag 5
  ]


  ;; listen for mouse click, either for mode setting or for selecting agents
  (ifelse pointed-mode != "false" and mouse-down? [ ;;pointed mode is when we're waiting for the third click
    ;show "in pointed mode"
    let sourcex 0
    let sourcey 0
    let num-selected count selected
    if pointed-mode = "heading" and num-selected > 0 [
      set sourcex (sum [xcor] of selected) / num-selected
      set sourcey (sum [ycor] of selected) / num-selected
    ]
    ;show selected
    let temp ""
    ask selected [
      set temp (word temp precision xcor 2 "_" precision ycor 2 "_" precision mouse-xcor 2 "_" precision mouse-ycor 2 "_" mode "_" pointed-mode "_")
      set mode pointed-mode
      set color pointed-color
      set xtarget (mouse-xcor - sourcex)
      set ytarget (mouse-ycor - sourcey)
    ]
    log-action temp
    print-instructions "select-robots-one"
    set pointed-mode "false"
    set selected no-turtles
  ] click-mode = "holding" and mouse-down?  [
    select clicked1_x clicked1_y mouse-xcor mouse-ycor
    set clicked2_x mouse-xcor
    set clicked2_y mouse-ycor
  ] (click-mode = "holding" or click-mode = "selected") and not mouse-down? [
    select clicked1_x clicked1_y clicked2_x clicked2_y
      if click-mode = "holding"[
        print-instructions "choose-action"
        set click-mode "selected"
      ]
   ] mouse-down?[
    set clicked1_x mouse-xcor
    set clicked1_y mouse-ycor
    set clicked2_x mouse-xcor
    set clicked2_y mouse-ycor
    set click-mode "holding"
  ])


  act
  update-neighbors
  ;;set selected (selected with [reachable = true])

  ;;make-persons ;; this used to call update points and spawned flags, no more!
  update-points
  tick

  if tut-mode = 0 and timer > 120 [
    log-state true
    print-instructions "end-tut"
    user-message ("Tutorial Complete!  Now begin the first main map!")
    set mode-flag 2
    ;;stop
  ]
  if tut-mode = 1 and timer > 420 [
    log-state true
    print-instructions "main-one"
    user-message ("Map 1 Complete!  Now begin the last map!")
    set mode-flag 4
  ]

  if tut-mode = 2 and timer > 420  [  ;;or longer than 15 minutes points > 2500.1
    log-state true
    print-instructions "end-main"
    user-message (word "Experiment Complete!  Your exit code is " precision timer 2 " " precision points 4)
    stop
  ]

  ;;logging stuff, this is called every time but only runs periodically
  log-state false
end

;;this used to be used to spawn the flags, not used since we not predetermine those
to make-persons
  ifelse tut-mode = 0 [   ;;tutorial map
    if ((random 175) = 1) [
      create-persons 1 [
        set size 12
        set label-color black
        set info 50 ;;((random 50) + 50)
        set shape "flag"
        set color lime
        let x -200 + (random 401)
        let y -200 + (random 401)
        while [[occupied] of patch x y = true or ( x > 0 and y > 0)] [
          	set x -200 + (random 401)	;; change and try again
          	set y -200 + (random 401)
        ]
        setxy x y
        set label info
      ]
    ]
  ] [
    if ((random 100) = 1) [   ;;regular map
      create-persons 1 [
        set size 12
        set label-color black
        set info 50 ;;((random 50) + 50)
        	    set shape "flag"
        	  set color lime
        let x -200 + (random 401)
        	    let y -200 + (random 401)
        while [[occupied] of patch x y = true]
        	[
          	set x -200 + (random 401)	;; change and try again
          	set y -200 + (random 401)
        	]
        setxy x y
        set label (word info ".0")
      ]
    ]
  ]
  update-points  ;;update persons too
end



to startup
  ifelse tut-mode = 0[
    print-instructions "intro-tut"
  ] [
    print-instructions "intro"
  ]
end

;;This is the instructions for the game
to print-instructions [choice]
 if choice = "intro"[
    clear-output
    output-print "Welcome to the experiment."
    output-print "Click on Go to setup"
    output-print "the robot map on the right."
    output-print ""
    output-print "The next screen will refresh"
    output-print "you on the instructions."
  ]
   if choice = "intro-tut"[
    clear-output
    output-print "Welcome to the experiment."
    output-print "Click on Setup Tutorial to"
    output-print "setup the map on the right."
    output-print ""
    output-print "The next screen will refresh"
    output-print "you on the instructions."
    output-print "After this short tutorial"
    output-print "you will be allowed to start"
    output-print "the main challenge"
  ]
  if choice = "start" [
    clear-output
    output-print "To your right is the map."
    output-print "The orange pentagon is your base."
    output-print ""
    output-print "To control your red robots, "
    output-print "they must be communicating"
    output-print "to the base."
    output-print ""
    output-print "To select robots, click and drag"
    output-print "one corner to another corner"
    output-print "of your imaginary box."
    output-print "When successfully selected, they"
    output-print "will turn lime green."
    output-print ""
    output-print "Once selected, click an action"
    output-print "button. If needed, you will be"
    output-print "asked to click a target location."
    output-print ""
    output-print "Activity will end after 7 minutes"
    output-print "Try to find at least 10 flags!"
  ]
    if choice = "start-tut" [
    clear-output
    output-print "To your right is the map."
    output-print "The orange pentagon is your base."
    output-print ""
    output-print "To control your red robots, "
    output-print "they must be communicating"
    output-print "to the base."
    output-print ""
    output-print "To select robots, click and drag"
    output-print "one corner to another corner"
    output-print "of your imaginary box."
    output-print ""
    output-print "Once selected, click an action"
    output-print "button. If needed, you will be"
    output-print "asked to click a target location."
    output-print ""
    output-print "Start moving robots whenever you"
    output-print "are ready after peeking the flags."
    output-print ""
    output-print "Tutorial will end after 2 minutes"
    output-print "and try to find at least 3 flags, "
    output-print "in all quadrons other than where"
    output-print "the robots and base start in."
  ]
  if choice = "end-tut" [
    clear-output
    output-print "Congrats on finishing the"
    output-print "tutorial."
    output-print ""
    output-print "The next screen will refresh"
    output-print "you on the instructions."
    output-print "for the first of two"
    output-print "main challenges."
  ]
  if choice = "main-one" [
     clear-output
    output-print "Congrats on finishing the"
    output-print "first map."
    output-print ""
    output-print "The next screen will refresh"
    output-print "you on the instructions."
    output-print "for the last of two"
    output-print "main challenges."

  ]
  if choice = "select-robots-one" [
    clear-output
    output-print "Select new robots to control."
    output-print ""
    output-print "Click and drag one corner"
    output-print "to another corner"
    output-print "of your imaginary box."
    output-print ""
    output-print "Remember, these robots must be"
    output-print "communicating with the base"
    output-print "to be controlled"
    output-print ""
    output-print "You are collecting points"
    output-print "by keeping robots close to"
    output-print "the flags."
  ]
  if choice = "select-heading"[
    clear-output
    output-print "Click on a target heading for"
    output-print "the selected robots to follow."
    output-print ""
    output-print "Remember in heading"
    output-print "robots will face at the"
    output-print "same angle and move in"
    output-print "the same direction."
  ]
    if choice = "select-go-to"[
    clear-output
    output-print "Click on a target location"
    output-print "that selected robots should go to."
    output-print ""
    output-print "Remember in come robots will move"
    output-print "towards the target you will select."
  ]
  if choice = "select-repel-from"[
    clear-output
    output-print "Click on a target location"
    output-print "that the selected robots "
    output-print "should Repel From."
    output-print ""
    output-print "Remember in Repel From robots"
    output-print "will move away from the"
    output-print "target you will select."
  ]
  if choice = "choose-action"[
    clear-output
    output-print "Choose an action button"
    output-print "(or shortcut key) for your"
    output-print "selected lime green robots. "
    output-print "If required, you will next be"
    output-print "asked to select a target location."
    output-print ""
    print-modes
  ]
  if choice = "failed-button"[
    clear-output
    output-print "You need to select robots first!"
    output-print "Make sure they are connected to"
    output-print "the base.Try again selecting robots"
    output-print ""
    print-modes
  ]
  if choice = "end-main"[
    clear-output
    output-print "Study Complete!"
    output-print "Return to Mechanical Turk"
    output-print ""
    output-print "Your Exit Code is:"
    output-print (word precision timer 2 " " precision points 4)
  ]
end
to print-modes  ;;this prints mode directions for a bunch of these
    output-print "Set Heading: (H)"
    output-print "  Robots will face the same angle"
    output-print "  and move in the same direction."
    output-print ""
    output-print "Go to: (G)"
    output-print "  Robots will move towards"
    output-print "  the target you will select"
    output-print ""
    output-print "Repel From: (F)"
    output-print "  Robots will move away"
    output-print "  from the target location"
    output-print ""
    output-print "Random: (R) "
    output-print "  Robots will move randomly"
    output-print ""
    output-print "Stop: (S) Robots will stop"
end

;;;;;;;;this is selection stuff
to deselect
  ask sides [ die ]
  set click-mode 0
end

to select [x1 y1 x2 y2] ; x1 y1 is initial corner and x2 y2 is current corner
  ask sides [ die ]
  make-side x1 y1 x2 y1
  make-side x1 y1 x1 y2
  make-side x1 y2 x2 y2
  make-side x2 y1 x2 y2
  set selected robots with [selected? xcor ycor and reachable]
  ask selected [ set color lime ]
end

to make-side [x1 y1 x2 y2]
  ; for each side, one thin line shape is created at the mid point of each segment
  ; of the bounding box and scaled to the proper length
  create-sides 1 [
    set color lime
    setxy (x1 + x2) / 2
          (y1 + y2) / 2
    facexy x1 y1
    set size 2 * distancexy x1 y1
  ]
end




; helper procedure that determines whether a point is
; inside the selection rectangle
to-report selected? [x y]
  let y-max max [ycor] of sides  ; largest ycor is where the top is
  let y-min min [ycor] of sides  ; smallest ycor is where the bottom is
  let x-max max [xcor] of sides  ; largest xcor is where the right side is
  let x-min min [xcor] of sides  ; smallest xcor is where the left side is
  ; report whether the input coordinates are within the rectangle
  report x >= x-min and x <= x-max and
         y >= y-min and y <= y-max
end

;;;;;;;;;;;logging stuff below

to log-action [action-list]
  ;;show "Logging:"
  let finallogstr (word logStr "_" precision timer 2 ";" "action" ";" tut-mode ";" precision points 4 ";"  precision timer 2";" action-list)
  ;;show finallogstr
  let response-triplet (http-req:post "http://34.227.18.144/robotdomain-data" finallogstr "text/plain")
  ifelse (first response-triplet) = 200 [
    ;show "logs successfully sent";
  ] [
   ;show "log transmission failed"
  ]
end


to log-state [force]
  if logstate *  < points or force [
    ;;show "Logging:"
    let finallogstr (word logStr "_" precision timer 2 ";" "state" ";" tut-mode ";" precision points 4 ";"  precision timer 2 ";" log-robotperson-list)
    ;;show finallogstr
    let response-triplet (http-req:post "http://34.227.18.144/robotdomain-data" finallogStr "text/plain")
    ifelse (first response-triplet) = 200 [
      ;;show "logs successfully sent"
      set logstate logstate + 1
    ]
    [
     ;;show "log transmission failed"
     if force [
        log-state true
      ]
    ]
  ]
end

to-report log-robotperson-list
  let temp ""
  ask robots [
    set temp (word temp precision xcor 3 "_" precision ycor 3 "_" mode "_")
  ]
  set temp word temp ";"
  ask persons [
    set temp (word temp precision xcor 3 "_" precision ycor 3 "_" info-str)
  ]
  report temp
end
@#$#@#$#@
GRAPHICS-WINDOW
329
23
1139
834
-1
-1
2.0
1
10
1
1
1
0
0
0
1
-200
200
-200
200
0
0
1
ticks
30.0

BUTTON
97
123
229
187
Go
main
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
190
652
279
703
Random
set-mode-random
NIL
1
T
OBSERVER
NIL
R
NIL
NIL
1

BUTTON
116
729
201
779
Stop
set-mode-stop
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
46
653
140
703
Repel From
set-mode-repel-from
NIL
1
T
OBSERVER
NIL
F
NIL
NIL
1

BUTTON
192
575
280
622
Go To
set-mode-go-to
NIL
1
T
OBSERVER
NIL
G
NIL
NIL
1

BUTTON
44
579
142
626
Set Heading
set-mode-heading
NIL
1
T
OBSERVER
NIL
H
NIL
NIL
1

MONITOR
193
39
302
108
Points
get-points
2
1
17

OUTPUT
10
220
320
564
12

TEXTBOX
40
193
190
215
Instructions:
18
0.0
1

TEXTBOX
1156
183
1424
234
NIL
14
34.0
1

TEXTBOX
1152
32
1302
53
Robot Modes:
17
0.0
1

TEXTBOX
1158
267
1409
305
NIL
15
15.0
1

TEXTBOX
1152
74
1452
321
Set Heading:  Robots will face at the\n           (H)    same angle and move in\n                    the same direction.\n\nGo To:        Robots will move towards\n           (G)  the target you will select\n\nRepel From:  Robots will move away\n           (F)   from the target location.\n\nRandom: (R)  Robots will move randomly\n\nStop:    (S)   Robots will stop
15
0.0
1

MONITOR
28
41
139
110
Timer
get-timer
17
1
17

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
