globals 
[
  num-robots 		;; number of robots including base station
  disk-radius 	;; radius for the delta-disk connectivity graph 
  ;; The user needs to click on the screen only in two cases - to select a bunch of robots, 
  ;; or to provide direction for the come or similar behaviors (which I refer to as pointed modes). 
  ;; In the first case select-on flag is true, and in the second case, pointed-mode-on flag is true. 
  ;; We listen for mouse clicks only when either of these flags are true. 
  select-on 			 ;; turns true when user clicks "select"
  pointed-mode-on  ;; turns true when user clicks "come" or "heading" or other modes that need a heading input
  ;; I use flags to check how many times the user has clicked on the arena. These flags are reset every time 
  ;; select or a pointed mode is clicked. 
  clicked1_x clicked1_y 	;; used to cache the coordinates for the first click. 
  clicked-once ;;		flag - true if one point has been selected by clicking on the arena
  clicked-twice  ;; flag - true if the second point has been selected by clicking on the arena. Clicked once should already be true for this to happen. 
  clicked2_x clicked2_y		;; used to cache the coordinates for the second click. 
  pointed-mode ;; Stores name of the pointed mode if any pointed mode is currently being executed
  selected ;; "agentset" of selected robots. Any further commands will be executed by these robots. Empty by default. 
  pointed-color ;; stores the color for the pointed mode behavior
]

;; each patch has a local variable named occupied - a boolean that is true if it is occupied
patches-own [occupied] 
;; local variables for turtles 
;; mode is the variable for each turtle that decides which behavior it should have eg: come, rendezvous, deploy
;; (xtarget, ytarget) stores the coordinates of the target that the agent has to either move towards 
;; reachable - flag that is true if the agent is connected to the base station. Only agents that are reachable can be selected. 
turtles-own [mode xtarget ytarget reachable]


to setup
  clear-all
  set num-robots 30			;; change this to control number of robots
  set disk-radius 35		;; change this to control the connectivity radius
  setup-patches
  setup-turtles
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
  let map-x [49 49 49 49 49 49 49 49 48 48 48 48 48 48 48 48 47 47 47 47 47 47 47 47 47 47 47 47 47 47 47 47 46 46 46 46 46 46 46 46 46 46 46 46 46 46 46 46 46 46 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 45 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 44 43 43 43 43 43 43 43 43 43 43 43 43 43 43 43 43 43 43 42 42 42 42 42 42 42 41 41 41 41 41 41 41 40 40 40 40 40 40 40 40 40 40 40 40 40 39 39 39 39 39 39 39 39 38 38 38 38 38 38 38 38 38 38 38 38 38 37 37 37 37 37 37 37 37 37 37 37 37 37 37 37 37 37 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 35 35 35 35 35 35 35 35 35 35 35 35 35 35 35 35 35 35 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 33 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 32 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 29 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 28 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 26 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 24 24 24 23 23 23 22 22 22 21 21 21 21 21 21 21 21 21 21 21 21 21 21 21 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 19 19 19 19 19 19 19 19 19 19 19 19 18 18 18 18 18 18 18 18 18 17 17 17 17 17 17 16 16 16 16 16 16 15 15 15 15 15 15 14 14 14 14 14 14 14 13 13 13 13 13 13 13 12 12 12 12 12 12 12 11 11 11 11 11 11 11 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 7 7 7 7 7 7 7 7 7 6 6 6 6 6 6 6 6 6 6 6 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 3 3 3 3 2 2 2 2 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -2 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -3 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -4 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -6 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -7 -8 -8 -8 -9 -9 -9 -10 -10 -10 -11 -11 -11 -12 -12 -12 -12 -12 -12 -13 -13 -13 -13 -13 -14 -14 -14 -14 -14 -14 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -16 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -17 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -18 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -19 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -20 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -21 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -22 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -23 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -24 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -25 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -26 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -27 -28 -28 -29 -29 -29 -29 -29 -29 -29 -30 -30 -30 -30 -30 -30 -30 -30 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -31 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -32 -33 -33 -33 -33 -33 -33 -33 -33 -33 -33 -33 -33 -33 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -34 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -35 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -36 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -37 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -38 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -39 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -40 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -41 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -42 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -43 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -44 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -45 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -46 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -47 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -48 -49 -50]
  let map-y [26 25 24 23 5 4 3 2 26 25 24 23 5 4 3 2 34 33 32 31 30 29 28 27 26 25 24 23 5 4 3 2 34 33 32 31 30 29 28 27 26 5 4 3 2 -27 -28 -29 -30 -31 44 43 42 41 40 34 33 32 31 30 29 28 27 26 5 4 3 2 -27 -28 -29 -30 -31 -47 -48 44 43 42 41 40 34 33 32 31 30 29 28 27 26 5 4 3 2 1 -27 -28 -29 -30 -31 -47 -48 44 43 42 41 40 34 33 32 31 30 29 28 27 26 2 1 -47 -48 44 43 42 41 40 -47 -48 44 43 42 41 40 -47 -48 44 43 42 41 40 2 1 0 -1 -2 -3 -47 -48 2 1 0 -1 -2 -3 -47 -48 2 1 0 -1 -2 -3 -26 -27 -28 -29 -30 -47 -48 13 12 11 10 2 1 0 -1 -2 -3 -26 -27 -28 -29 -30 -47 -48 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -26 -27 -28 -29 -30 -47 -48 13 12 11 10 9 8 7 6 5 4 3 -26 -27 -28 -29 -30 -47 -48 13 12 11 10 9 8 7 6 5 4 3 -26 -27 -28 -29 -30 47 46 45 9 8 7 6 5 4 3 -26 -27 -28 -29 -30 -34 -35 -36 -37 -38 -39 -40 47 46 45 9 8 7 6 5 4 3 -26 -27 -28 -29 -30 -34 -35 -36 -37 -38 -39 -40 47 46 45 9 8 7 6 5 4 3 -15 -16 -17 -18 -19 -20 -26 -27 -28 -29 -30 -34 -35 -36 -37 -38 -39 -40 47 46 45 9 8 7 6 5 4 3 -15 -16 -17 -18 -19 -20 -34 -35 -36 -37 -38 -39 -40 47 46 45 9 8 7 6 5 4 3 2 1 -15 -16 -17 -18 -19 -20 -34 -35 -36 -37 -38 -39 -40 9 8 7 6 5 4 3 2 1 -15 -16 -17 -18 -19 -20 -33 -34 -35 -36 -37 -38 -39 -40 -43 -44 -45 -46 28 27 26 25 24 9 8 7 6 5 4 3 2 1 -15 -16 -17 -18 -19 -20 -43 -44 -45 -46 48 47 46 28 27 26 25 24 5 4 3 2 1 -15 -16 -17 -18 -19 -20 -43 -44 -45 -46 48 47 46 28 27 26 25 24 -15 -16 -17 -18 -19 -20 -43 -44 -45 -46 48 47 46 48 47 46 48 47 46 -21 -22 -23 -24 -35 -36 -37 -38 -39 -40 -41 -42 -43 -44 -45 49 48 47 46 37 36 35 34 33 32 31 30 29 -35 -36 -37 -38 -39 -40 -41 -42 -43 -44 -45 37 36 35 34 33 32 31 30 29 -43 -44 -45 30 29 28 27 26 25 -43 -44 -45 30 29 28 27 26 25 30 29 28 27 26 25 30 29 28 27 26 25 -8 -9 -10 -11 -12 -13 -14 -8 -9 -10 -11 -12 -13 -14 -8 -9 -10 -11 -12 -13 -14 -8 -9 -10 -11 -12 -13 -14 45 44 43 42 41 36 35 34 -8 -9 -10 -11 -12 -13 -14 -27 -28 -29 -30 -37 -38 -39 -40 45 44 43 42 41 36 35 34 -8 -9 -10 -11 -12 -13 -14 -27 -28 -29 -30 -37 -38 -39 -40 45 44 43 42 41 -8 -9 -10 -11 -12 -13 -14 -27 -28 -29 -30 -37 -38 -39 -40 45 44 43 42 41 -27 -28 -29 -30 45 44 43 42 41 4 3 -27 -28 -29 -30 45 44 43 42 41 30 29 4 3 -27 -28 -29 -30 30 29 4 3 -27 -28 -29 -30 30 29 4 3 30 29 4 3 30 29 4 3 30 29 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 30 29 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 30 29 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 30 29 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 30 29 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 32 31 30 29 28 27 26 25 24 23 -23 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 49 48 30 29 -23 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 49 48 30 29 -23 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 49 48 -23 49 48 -23 49 48 -23 49 48 -23 49 48 -13 -14 -15 -23 49 48 -13 -14 -15 14 13 12 -13 -14 -15 45 44 43 42 41 40 39 38 14 13 12 11 45 44 43 42 41 40 39 38 14 13 12 11 45 44 43 42 41 40 39 38 14 13 12 11 -14 -15 -16 -17 45 44 43 42 41 40 39 38 14 13 12 11 -14 -15 -16 -17 -25 -26 -27 -28 -29 45 44 43 42 41 40 39 38 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -18 -19 -25 -26 -27 -28 -29 45 44 43 42 41 40 39 38 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -18 -19 -25 -26 -27 -28 -29 45 44 43 42 41 40 39 38 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -18 -19 -25 -26 -27 -28 -29 45 44 43 42 41 40 39 38 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -46 -47 -48 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -46 -47 -48 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -46 -47 -48 13 12 11 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -46 -47 -48 -4 -5 -6 -7 -8 -9 -10 -11 -14 -15 -16 -17 -37 -38 -46 -47 -48 -37 -38 -30 -31 -32 -33 -34 -37 -38 42 -30 -31 -32 -33 -34 -37 -38 47 46 45 44 43 42 16 15 14 -30 -31 -32 -33 -34 -37 -38 -45 -46 47 46 45 44 43 42 16 15 14 -30 -31 -32 -33 -34 -37 -38 -45 -46 47 46 45 44 43 42 16 15 14 -37 -38 -45 -46 47 46 45 44 43 42 31 16 15 14 -37 -38 -45 -46 47 46 45 44 43 42 31 30 29 28 27 26 25 24 23 22 16 15 14 -37 -38 -45 -46 47 46 45 44 43 42 31 30 29 28 27 26 25 24 23 22 16 15 14 -37 -38 -45 -46 42 31 30 29 28 27 26 25 24 23 22 16 15 14 -37 -38 -45 -46 31 30 29 28 27 26 25 24 23 22 16 15 14 -37 -38 -45 -46 30 29 28 27 26 25 24 23 22 16 15 14 -3 -4 -5 -6 -7 -8 -9 -10 -11 -13 -14 -45 -46 49 30 29 28 27 26 25 24 23 22 16 15 14 -3 -4 -5 -6 -7 -8 -9 -10 -11 -13 -14 -45 -46 49 30 29 28 27 26 25 24 23 22 16 15 14 -3 -4 -5 -6 -7 -8 -9 -10 -11 -13 -14 -45 -46 49 30 29 28 27 26 25 24 23 22 16 15 14 8 7 6 5 4 3 -3 -4 -5 -6 -7 -8 -9 -10 -11 -13 -14 -21 -22 -23 -45 -46 49 30 29 28 27 26 25 24 23 22 8 7 6 5 4 3 -3 -4 -5 -6 -7 -8 -9 -10 -11 -21 -22 -23 -45 -46 49 24 23 22 8 7 6 5 4 3 -3 -4 -5 -6 -7 -8 -9 -10 -11 -21 -22 -23 49 8 7 6 5 4 3 -3 -4 -5 -6 -7 -8 -9 -10 -11 -21 -22 -23 49 8 7 6 5 4 3 -3 -4 -5 -6 -7 -8 -9 -10 -11 -21 -22 -23 49 8 7 6 5 4 3 -3 -4 -5 -6 -7 -8 -9 -10 -11 -30 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 49 7 6 5 4 -3 -4 -30 -31 -32 -33 -34 -35 -36 -37 -38 -39 -40 49 49]
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
  ;; occupied patches have to be black :) 
  ask patches 
  [if occupied = true 
    [
      set pcolor black
    ]
  ]
end


;; agents setup function. 
to setup-turtles
  ;; creating the base station
  create-turtles 1
  [
    setxy 130 130
    set shape "pentagon"
    set color brown
    set size 10
    set mode "stop"
  ]
	;; creating all the other turtles
  create-turtles num-robots
 	[
		;; change these to change where the turtles are initialized. 
    ;; Currently they are centered at (100, 100) and spread out by (100, 100) (randomness). 
    let x 100 + (random 100)		    
    let y 100 + (random 100)
    ;; if the random patch is occupied, repeat. 
    while [[occupied] of patch x y = true]
    [
      set x 100 + (random 100)	;; change the same here also. 
      set y 100 + (random 100)
    ]
    setxy x y
    set color grey
    set size 8
    set mode "stop"	;; they are initially in the stopped state
  ]
  update-neighbors	;; updates the links
  set selected (turtles with [who != 0 and reachable = true])	;; by default all turtles that are reachable are selected
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


;; this function uses the delta disk graph to determine which agents are connected. 
;; agent i is connected to agent j if they are within disk-radius and if they do not have 
;; an obstacle in between
to update-neighbors
  ;; sets neighbours based on distance alone
  clear-links
    foreach (range (num-robots + 1)) [agent1 ->
      foreach (range (num-robots + 1)) [ agent2 ->
        if (agent1 != agent2)  and (([distance turtle agent1] of turtle agent2) <= disk-radius) [
          ask turtle agent1 [create-link-with turtle agent2]
        ]
      ]
    ]
  ;; removes links that have obstacle between them. this is done by scanning along the line 
  ;; connecting the two agents in steps of delta. 
  let delta 0.5	;; step size
  ask links [
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
  ask turtles [ set reachable false ] ;; set all of them to be not reachable
  ask turtle 0 [activate-neighbors]		;; recurse from the base station
end

;; all the set-mode-<> functions. These functions are called when the buttons for the corresponding 
;; modes are clicked. Some modes are "pointed" - they need a heading input (clicking on arena). 

;; If it is a pointed-mode Clear the select-on, clicked-once and clicked-twice flags, set the pointed-mode flag to true. 
;; Mode starts executing when the clicking is completed. Which is later. pointed-mode and pointed-color is used to cache until then. 
to set-mode-heading
  set pointed-mode "heading"
  set pointed-color violet
  set pointed-mode-on true
  set select-on false
  set clicked-once false
  set clicked-twice false
end

to set-mode-come
  set pointed-mode "come"
  set pointed-color blue
  set pointed-mode-on true
  set select-on false
  set clicked-once false
  set clicked-twice false
end

to set-mode-leave
  set pointed-mode "leave"
  set pointed-color pink
  set pointed-mode-on true
  set select-on false
  set clicked-once false
  set clicked-twice false
end

;; deploy behavior has not been implemented yet #TODO
to set-mode-deploy
  ask selected [
    set mode "deploy"
    set color green
  ]
end

;; If it is not a pointed mode, start executing the behavior for the selected agents. 
;; Also set their color. 
to set-mode-stop
  ask selected [
    set mode "stop"
    set color grey
  ]
end

to set-mode-rendezvous
  ask selected [
    set mode "rendezvous"
    set color yellow
  ]
end

to set-mode-random
  ask selected [
    set mode "random"
    set color turquoise
  ]
end

;; runs when user clicks select
to set-select-on
  set select-on true
  set pointed-mode-on false
  set clicked-once false
  set clicked-twice false
end

;; runs when user clicks clear - clears the current selection
;; by default - all reachable agents are selected
to clear-selection
  set selected (turtles with [who != 0 and reachable = true])
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
      ][ set heading random 360 ]
    ]((patch (x + 1) y) != nobody and [occupied] of (patch (x + 1) y) = true) and 
    ((patch (x - 1) y) != nobody and [occupied] of (patch (x - 1) y) = true) and 
    ((patch x (y - head_y)) != nobody and [occupied] of (patch x (y - head_y)) = false)[
      ifelse [occupied] of (patch (xcor + head_x) ycor) = false [
      	set xcor (xcor + head_x)
      ][ set heading random 360 ]
    ]((patch (x + head_x) y) != nobody and [occupied] of (patch (x + head_x) y) = true) and 
    ((patch x (y + head_y)) != nobody and [occupied] of (patch x (y + head_y)) = true) [
      ifelse [occupied] of (patch (xcor + head_x) ycor) = false [
      	set xcor (xcor + head_x)
      ][ set heading random 360 ]
    ][ forward 1 ]
  )
end

;; the main actuation function
;; what the agent does depends on which behavior it is in
;; so this is basically a ladder of if-else for behaviors
to act
  ask turtles [
    let infront (patch-ahead 1)
    (ifelse infront = nobody [
      ;; end of the world scenario
        set heading random 360
     ]mode = "random" [
       ;; keep moving straight, if you hit an obstacle turn randomly
	      ifelse ([occupied] of infront) = false [
        forward 1
       ][ set heading random 360 ]
	   ]mode = "rendezvous" and count link-neighbors != 0 [
       ;; classic consensus
        let sumx (sum [xcor] of link-neighbors) / count link-neighbors
        let sumy (sum [ycor] of link-neighbors) / count link-neighbors
        facexy sumx sumy
        (ifelse ([occupied] of infront) = false [
          forward 1
         ][
          slide-on-obstacle infront
	       ])
     ] mode = "come" [
       ;; move to the target
        facexy xtarget ytarget
        (ifelse ([occupied] of infront) = false [
          forward 1
         ][
          slide-on-obstacle infront
	       ])
     ] mode = "leave" [
       ;; move away from target
        facexy (xcor + (xcor - xtarget)) (ycor + (ycor - ytarget))
        (ifelse ([occupied] of infront) = false [
          forward 1
         ][
          slide-on-obstacle infront
	       ])
    ])
  ]
end


to update-mode
  (ifelse select-on and clicked-twice [
    set selected turtles with 
    [(who != 0) and (xcor > clicked1_x) and (xcor < clicked2_x) and (ycor < clicked1_y) and (ycor > clicked2_y) and reachable]
    ask selected [set color red]
    set clicked-once false
    set clicked-twice false
    set select-on false
   ] pointed-mode-on and clicked-once[
      ask selected [
        set mode pointed-mode
        set color pointed-color
        set xtarget clicked1_x
        set ytarget clicked1_y
      ]
      set pointed-mode-on false
      set clicked-once false
  ])
end

;; this is the forever main loop that runs once the task starts (user clicks "go"). 
;; we just listen for clicks and change modes here
;; and then we call update-neighbours and act functions
to main
  ;; listen for mouse click, either for mode setting or for selecting agents
  if (select-on or pointed-mode-on) and mouse-down? [
    ;; if this is the first click 
    ifelse clicked-once = false [
      set clicked-once true
      set clicked1_x mouse-xcor
      set clicked1_y mouse-ycor
      update-mode
      show "clicked once"
      show clicked1_x
      show clicked1_y
    ][
      ;; if this is the second click - used for selection only
      if clicked-twice = false [
        ifelse mouse-xcor != clicked1_x or mouse-ycor != clicked1_y [
          set clicked-twice true
          set clicked2_x mouse-xcor
          set clicked2_y mouse-ycor
          update-mode
          show "clicked twice"
          show clicked2_x
          show clicked2_y
        ][
          show "clicked same thing again"
        ]
      ]
    ]
  ]
  act
  update-neighbors
  set selected (selected with [reachable = true])
  tick
end

@#$#@#$#@
GRAPHICS-WINDOW
309
17
1111
819
-1
-1
2
1
6
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
30

BUTTON
50
30
130
70
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
150
30
229
70
go
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
50
570
125
610
random
set-mode-random
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
160
570
250
610
rendezvous
set-mode-rendezvous
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
170
480
230
520
stop
set-mode-stop
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
120
400
190
440
leave
set-mode-leave
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
210
400
280
440
come
set-mode-come
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
60
480
130
520
deploy
set-mode-deploy
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
20
400
95
440
heading
set-mode-heading
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
60
190
135
230
Select
set-select-on
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
150
190
220
230
Clear
clear-selection
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1
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
NetLogo 6.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0
-0.2 0 0 1
0 1 1 0
0.2 0 0 1
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@

@#$#@#$#@
