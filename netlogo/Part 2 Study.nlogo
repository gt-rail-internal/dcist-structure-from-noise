;; TODO/Issues
;; Netlogo uses synchronous mode in HTTPS post, which probably causes the network error at the end, nothing runs after the error.
;; Write code to generate the lattice graph
;; Display "Click here" on view before game starts : problem - cannot remove it after click.
;; Host simple-https-server to receive responses, do away with webhook.site?
;; Setup AMT
;; Refer to paper to check if all requirements are met
extensions [http-req]
globals [logStr loc state iter lit expstate querystate clicked blinkrounds starterAr xz waitcounter]

to setup

  if state = 0[
    clear-all
    set state 1
    setup-patches
    ;; timelog is a string that contains the user name and time as CSV
    ;;ask patches [set plabel-color black]
    set logStr user-input "What is your Mechanical Turk ID?"
    set logStr word logStr ","
    reset-ticks
  ]
  if state = 1 [
    start-experiment-one
  ]
  if state = 2 [
    start-experiment-two
  ]
  if state = 3 [
    start-experiment-three
  ]
  if state = 4 [
    start-experiment-four
  ]
  if state = 5 [
    start-experiment-five
  ]
  if state = 6 [
    start-experiment-six
  ]
  if state = 7 [
    start-experiment-seven
  ]
  if state = 8 [
    start-experiment-eight
  ]
    if state = 9 [
    start-experiment-nine
  ]
    if state = 10 [
    start-experiment-ten
  ]
  if state = 11[

    print-instructions 100
  ]
  if state = 12[
  ]
  tick
end

to setup-patches
  ask patches [set pcolor white]
end

to setup-turtles
  foreach loc [ [x] ->
  create-turtles 1 [setxy (item 0 x)  (item 1 x)]
  ask turtles [set size 0.6]
  ask turtles [set shape "dani-border"]
  ask turtles [set color red]
    ;ask turtles [set color green]
  ]
  ;; keymap maps each node in the graph to one or two keys
end

to setup-turtles-shapes [heters]
  let a 0
  foreach loc [ [x] ->
  ;;show item a heters
  create-turtles 1 [setxy (item 0 x)  (item 1 x)]

  if item a heters = 0[
      ask turtle a [set size 0.6]
      ask turtle a [set shape "dani-border"]
  ]
  if item a heters = 1[
      ask turtle a [set size 0.7]
      ask turtle a [set shape "dani-triangle"]
  ]
  ask turtle a [set color red]
  set a a + 1
    ;ask turtles [set color green]
  ]
  ;; keymap maps each node in the graph to one or two keys
end

to start-experiment-one
  if expstate = 0[
  set loc [[-3 2.75] [-3 1.9] [-1.7 2.75] [-1.5 2] [-0.3 2.2] [0.9 2] [1.2 1.3] [1.9 2.7] [2.6 2.5] [2.5 1.2] [2.3 0.2] [2.1 -0.5]  [2.6 -1.2]  [2.2 -2.2] [1.1 -1.8] [0.8 -2.7] [0.2 -2.2] [-0.5 -1.8] [-0.5 -2.8] [-0.7 -1.1] [-1.4 -2.2] [-2.2 -2.5] [ -2.3 -1.8] [-2.5 -1.2] [-2.5 -0.5] [-2.7 0.4]]
  setup-turtles
  set blinkrounds 0
  set starterAr [0 10 20] ;;these are the items to start with
  set expstate 100
  set iter 0
  set lit n-values count turtles [0]
  print-instructions 0
  set waitcounter 0
  ]
  if expstate = 100 [
    every 0.5 [
      set waitcounter waitcounter + 1
      if waitcounter = 10 [
        set expstate 1
      ]
    ]
  ]
  if expstate = 1[
    blink item blinkrounds starterAr
  ]
  if expstate = 2[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 3[
    blink item blinkrounds starterAr
  ]
  if expstate = 4[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 5[
    blink item blinkrounds starterAr
  ]
  if expstate = 6[
    set querystate 0
    set expstate expstate + 1
    print-instructions 1
    ask turtles [set color red]
  ]
  if expstate = 7[
    queryUser
        if querystate = 1[
     blink clicked
    ]
  ]
  if expstate = 8[
    ifelse clicked = 10 [
      set expstate 12
      set logStr word logStr word -1 ","
      set logStr word logStr word -1 ","
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 2
    ;;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 9[
    queryUser
        if querystate = 1[
     blink clicked
    ]
  ]
  if expstate = 10[
    ifelse clicked = 10 [
      set expstate 12
      set logStr word logStr word -1 ","
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 3
    ;;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 11[
    queryUser
        if querystate = 1[
     blink clicked
    ]
  ]
  if expstate = 12[
    user-message ("Round One Complete")
    show logstr
    clear-turtles
    set state state + 1
    set expstate 0
  ]
end

to start-experiment-two  ;;top left square                                       ;;start Curve part                                                       ;;start bottom square                                                  ;;shootoff to third
  if expstate = 0[
   set loc [[-3 2.85] [-2.4 2.75] [-1.8 2.95] [-1.2 2.8] [-2.8 2.2] [-2.2 2.2] [-1.6 2.2] [-0.8 1] [-0.2 0.25] [0.2 -0.5] [-0.2 -1.25] [-0.8 -2] [-1.6 -2.2] [-2.2 -2.2] [-2.8 -2.2] [-2.8 -2.7] [-2.2 -2.8] [-1.6 -2.8] [-1 -2.7] [0.3 -2.2] [0.9 -2.0] [1.4 -1.8] [2.1 -1.9] [2.7 -1.8] [3.2 -2.0] [3.1 -2.6] [2.6 -2.6] [2.0 -2.4]]
  setup-turtles
  set blinkrounds 0
  set starterAr [0 13 25] ;;these are the items to start with
  ;wait 1.5
   set expstate 1
   set iter 0
    set lit n-values count turtles [0]
    print-instructions 0
  ]
  if expstate = 1[
    blink item blinkrounds starterAr
  ]
  if expstate = 2[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 3[
    blink item blinkrounds starterAr
  ]
  if expstate = 4[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 5[
    blink item blinkrounds starterAr
  ]
  if expstate = 6[
    set querystate 0
    set expstate expstate + 1
    print-instructions 1
    ;user-message ("Click on three items you feel will propogate the fastest")
    ask turtles [set color red]
  ]
  if expstate = 7[
    queryUser
        if querystate = 1[
     blink clicked
    ]
  ]
  if expstate = 8[
    ifelse clicked = 8 or clicked = 9[
      set logStr word logStr word -1 ","
      set logStr word logStr word -1 ","
      set expstate 12
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 2
    ;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 9[
    queryUser
        if querystate = 1[
     blink clicked
    ]
  ]
  if expstate = 10[
    ifelse clicked = 8 or clicked = 9[
      set logStr word logStr word -1 ","
      set expstate 12
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 3
    ;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 11[
    queryUser
        if querystate = 1[
     blink clicked
    ]
  ]
  if expstate = 12[
    user-message ("Round Two Complete")
    show logstr
    clear-turtles
    set state state + 1
    set expstate 0
  ]
end



to start-experiment-three
  if expstate = 0[
    set loc [[-2 0] [-1 0] [0 0] [1 0] [2 0] [0 2] [0 1] [0 -1] [0 -2]]
  setup-turtles
  set blinkrounds 0
  set starterAr [0  20] ;;these are the items to start with
  ;wait 1.5
   set expstate 1
   set iter 0
    set lit n-values count turtles [0]
    print-instructions 0
  ]
  if expstate = 1[
    blink 0;;;item blinkrounds starterAr
  ]
  if expstate = 2[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 3[
    blink 2;;;item blinkrounds starterAr
  ]
  if expstate = 4[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 5[
    blink 5;;;item blinkrounds starterAr
  ]
  if expstate = 6[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 7[
    set querystate 0
    set expstate expstate + 1
    print-instructions 10
    ask turtles [set color red]
  ]
  if expstate = 8[
    queryUser
    if querystate = 1[
     blink clicked
    ]
  ]
  if expstate = 9[
    user-message ("Round Three Complete")
    show logstr
    clear-turtles
    set state state + 1
    set expstate 0
  ]
end

to start-experiment-four
  let adj
  [[0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0]
  [1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 1 1 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 1 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 0 1 0 0 0]
  [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 1 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 1 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0]]

  if expstate = 0[
    print-instructions 0
    set loc [[-3 2.75] [-3 1.9] [-1.7 2.75] [-1.5 2] [-0.3 2.2] [0.9 2] [1.2 1.3] [1.9 2.7] [2.6 2.5] [2.5 1.2] [2.3 0.2] [2.1 -0.5]  [2.6 -1.2]  [2.2 -2.2] [1.1 -1.8] [0.8 -2.7] [0.2 -2.2] [-0.5 -1.8] [-0.5 -2.8] [-0.7 -1.1] [-1.4 -2.2] [-2.2 -2.5] [ -2.3 -1.8] [-2.5 -1.2] [-2.5 -0.5] [-2.7 0.4]]
    setup-turtles-shapes [1 0 0 0 0 0 0 0 1 1 0 0 0 0 1 0 0 1 0 0 1 0 0 0 0 0]
    set blinkrounds 0
    set starterAr [0  20] ;;these are the items to start with
    set expstate 1
    set iter 0
    set lit n-values count turtles [0]
  ]
  if expstate = 1[
    blink-neighbors 0 adj
  ]
  if expstate = 2[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 3[
    blink-neighbors 10 adj
  ]
  if expstate = 4[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 5[
    blink-neighbors 20 adj
  ]
  if expstate = 6[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 7[
    set querystate 0
    set expstate expstate + 1
    print-instructions 1
    ;user-message ("Click on three items you feel will propogate the fastest")
    ask turtles [set color red]
  ]
  if expstate = 8[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
    if expstate = 9[
    ifelse clicked = 0 or clicked = 20[
      set expstate 13
      set logStr word logStr word -1 ","
      set logStr word logStr word -1 ","
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 2
    ;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 10[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
    if expstate = 11[
    ifelse clicked = 0 or clicked = 20[
      set expstate 13
      set logStr word logStr word -1 ","
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 3
    ;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 12[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
  if expstate = 13[
    user-message ("Round Four Complete")
    show logstr
    clear-turtles
    set state state + 1
    set expstate 0
  ]
end

to start-experiment-five
  let adj
  [[0 1 0 0 0 0 0 0 0 0 0 0 0]
   [1 0 1 0 0 0 0 0 0 0 0 0 0]
   [0 1 0 1 0 0 0 0 0 0 0 0 0]
   [0 0 1 0 1 0 0 0 0 0 0 0 0]
   [0 0 0 1 0 1 0 0 0 0 0 0 0]
   [0 0 0 0 1 0 1 0 0 0 0 0 0]
   [0 0 0 0 0 1 0 1 0 0 0 0 0]
   [0 0 0 0 0 0 1 0 1 0 0 0 0]
   [0 0 0 0 0 0 0 1 0 1 0 0 0]
   [0 0 0 0 0 0 0 0 1 0 1 0 0]
   [0 0 0 0 0 0 0 0 0 1 0 1 0]
   [0 0 0 0 0 0 0 0 0 0 1 0 1]
   [0 0 0 0 0 0 0 0 0 0 0 1 0]]

  if expstate = 0[
    print-instructions 0
    set loc [[-3 0] [-2 0] [-1 0] [0 0] [1 0] [2 0] [3 0] [0 3] [0 2] [0 1] [0 -1] [0 -2] [0 -3]]
    setup-turtles
    set expstate 1
    set iter 0
    set lit n-values count turtles [0]
  ]
  if expstate = 1[
    blink-neighbors 0 adj
  ]
  if expstate = 2[
    ask turtles [set color red]
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 3[
    blink-neighbors 4 adj
  ]
  if expstate = 4[
    ask turtles [set color red]
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 5[
    blink-neighbors 7 adj
  ]
  if expstate = 6[
    ask turtles [set color red]
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 7[
    set querystate 0
    set expstate expstate + 1
    print-instructions 1
    ask turtles [set color red]
  ]
  if expstate = 8[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
    if expstate = 9[
    ifelse clicked = 6 or clicked = 7[
      set expstate 13
      set logStr word logStr word -1 ","
      set logStr word logStr word -1 ","
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 2
    ask turtles [set color red]
    ]
  ]
  if expstate = 10[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
    if expstate = 11[
    ifelse clicked = 6 or clicked = 7[
      set expstate 13
      set logStr word logStr word -1 ","
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 3
    ;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 12[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
  if expstate = 13[
    user-message ("Round Five Complete")
    show logstr
    clear-turtles
    set state state + 1
    set expstate 0
  ]
end





to start-experiment-six
  let adj
  [[0 1 0 0 0 0 0 0 0 0 0 0 0]
   [1 0 1 0 0 0 0 0 0 0 0 0 0]
   [0 1 0 1 0 0 0 0 0 0 0 0 0]
   [0 0 1 0 1 0 0 0 0 0 0 0 0]
   [0 0 0 1 0 1 0 0 0 0 0 0 0]
   [0 0 0 0 1 0 1 0 0 0 0 0 0]
   [0 0 0 0 0 1 0 1 0 0 0 0 0]
   [0 0 0 0 0 0 1 0 1 0 0 0 0]
   [0 0 0 0 0 0 0 1 0 1 0 0 0]
   [0 0 0 0 0 0 0 0 1 0 1 0 0]
   [0 0 0 0 0 0 0 0 0 1 0 1 0]
   [0 0 0 0 0 0 0 0 0 0 1 0 1]
   [0 0 0 0 0 0 0 0 0 0 0 1 0]]

  if expstate = 0[
    print-instructions 0
    set loc [[-3 0] [-2 1.25] [-1 2] [0 0] [1 -1] [2 0] [3 -2.5] [0.5 3] [0.75 2] [0 1.25] [-1 -1] [1.7 -2] [-0.4 -3]]
    setup-turtles
    set expstate 1
    set iter 0
    set lit n-values count turtles [0]
  ]
  if expstate = 1[
    blink-neighbors 0 adj
  ]
  if expstate = 2[
    ask turtles [set color red]
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 3[
    blink-neighbors 4 adj
  ]
  if expstate = 4[
    ask turtles [set color red]
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 5[
    blink-neighbors 7 adj
  ]
  if expstate = 6[
    ask turtles [set color red]
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 7[
    set querystate 0
    set expstate expstate + 1
    print-instructions 1
    ask turtles [set color red]
  ]
  if expstate = 8[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
  if expstate = 9[
    ifelse clicked = 6 [  ;;if in the previous they clicked on the right one then lets go to the end.
      set expstate 13
      set logStr word logStr word -1 ","
      set logStr word logStr word -1 ","
    ] [
      set querystate 0
      set expstate expstate + 1
      print-instructions 2
      ask turtles [set color red]
    ]
  ]
  if expstate = 10[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
  if expstate = 11[
    ifelse clicked = 6 [
      set expstate 13
      set logStr word logStr word -1 ","
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 3
    ;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 12[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
  if expstate = 13[
    user-message ("Round Six Complete")
    show logstr
    clear-turtles
    set state state + 1
    set expstate 0
  ]
end

to start-experiment-seven
  let adj
 [[0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 1]
  [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0]]

  if expstate = 0[
    print-instructions 0
    set loc [[-3 3] [-2 3] [-1 3] [0 3] [1 3] [2 3] [3 3]
      [-3 2] [-2 2] [-1 2] [0 2] [1 2] [2 2] [3 2]
      [-3 1] [-2 1] [-1 1] [0 1] [1 1] [2 1] [3 1]
      [-3 0] [-2 0] [-1 0] [0 0] [1 0] [2 0] [3 0]
      [-3 -1] [-2 -1] [-1 -1] [0 -1] [1 -1] [2 -1] [3 -1]
      [-3 -2] [-2 -2] [-1 -2] [0 -2] [1 -2] [2 -2] [3 -2]
      [-3 -3] [-2 -3] [-1 -3] [0 -3] [1 -3] [2 -3] [3 -3]
    ]
    setup-turtles
    set blinkrounds 0
    set starterAr [9  20] ;;these are the items to start with
    set expstate 1
    set iter 0
    set lit n-values count turtles [0]
  ]
  if expstate = 1[
    blink-neighbors 0 adj
  ]
  if expstate = 2[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 3[
    blink-neighbors 10 adj
  ]
  if expstate = 4[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 5[
    blink-neighbors 20 adj
  ]
  if expstate = 6[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 7[
    set querystate 0
    set expstate expstate + 1
    print-instructions 1
    ;user-message ("Click on three items you feel will propogate the fastest")
    ask turtles [set color red]
  ]
  if expstate = 8[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
    if expstate = 9[
    ifelse clicked = 26[
      set expstate 13
      set logStr word logStr word -1 ","
      set logStr word logStr word -1 ","
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 2
    ;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 10[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
    if expstate = 11[
    ifelse clicked = 26[
      set expstate 13
      set logStr word logStr word -1 ","
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 3
    ;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 12[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
  if expstate = 13[
    user-message ("Round Seven Complete")
    show logstr
    clear-turtles
    set state state + 1
    set expstate 0
  ]
end


to start-experiment-eight
  if expstate = 0[
    set loc [[-3 2] [-2.4 2.1] [-1.8 1.9] [-1.2 1.8] [-2.8 1.4] [-2.2 1.3] [-1.6 1.1] ;;top cluster
      [-0.25 2.0]  [0.5 2.3] [1.2 2.4]  [2 2.5] [2.5 2.0] [2.4 1.4] [2.3 0.8] [2.2 0.2] [2.0 -0.4] [2.1  -0.9] [2.0 -1.6]  ;; right path
      [1.8 -2.3] [2.6 -2.4] [2.6 -2.9] [2 -2.8] [1.3 -2.9] ;;bottom cluster
      [1.1 -2.4] [0.6 -1.9] [0 -1.4] [-0.2 -0.7] [-0.6 0] [-1 0.5]]
  setup-turtles
  set blinkrounds 0
  set starterAr [0 13 25] ;;these are the items to start with
  ;wait 1.5
   set expstate 1
   set iter 0
    set lit n-values count turtles [0]
    print-instructions 0
  ]
  if expstate = 1[
    blink item blinkrounds starterAr
  ]
  if expstate = 2[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 3[
    blink item blinkrounds starterAr
  ]
  if expstate = 4[
    ask turtles [set color red]
    set blinkrounds blinkrounds + 1
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 5[
    blink item blinkrounds starterAr
  ]
  if expstate = 6[
    set querystate 0
    set expstate expstate + 1
    print-instructions 1
    ;user-message ("Click on three items you feel will propogate the fastest")
    ask turtles [set color red]
  ]
  if expstate = 7[
    queryUser
        if querystate = 1[
     blink clicked
    ]
  ]
  if expstate = 8[
    ifelse clicked = 24[
      set logStr word logStr word -1 ","
      set logStr word logStr word -1 ","
      set expstate 12
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 2
    ;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 9[
    queryUser
        if querystate = 1[
     blink clicked
    ]
  ]
  if expstate = 10[
    ifelse clicked = 24[
      set logStr word logStr word -1 ","
      set expstate 12
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 3
    ;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 11[
    queryUser
        if querystate = 1[
     blink clicked
    ]
  ]
  if expstate = 12[
    user-message ("Round Eight Complete")
    show logstr
    clear-turtles
    set state state + 1
    set expstate 0
  ]
end

to start-experiment-nine
let adj
  [[0 1 0 0 0 0 0 0 0 0 0 0 0]
   [1 0 1 0 0 0 0 0 0 0 0 0 0]
   [0 1 0 1 0 0 0 0 0 0 0 0 0]
   [0 0 1 0 1 0 0 0 0 0 0 0 0]
   [0 0 0 1 0 1 0 0 0 0 0 0 0]
   [0 0 0 0 1 0 1 0 0 0 0 0 0]
   [0 0 0 0 0 1 0 1 0 0 0 0 0]
   [0 0 0 0 0 0 1 0 1 0 0 0 0]
   [0 0 0 0 0 0 0 1 0 1 0 0 0]
   [0 0 0 0 0 0 0 0 1 0 1 0 0]
   [0 0 0 0 0 0 0 0 0 1 0 1 0]
   [0 0 0 0 0 0 0 0 0 0 1 0 1]
   [0 0 0 0 0 0 0 0 0 0 0 1 0]]

  if expstate = 0[
    print-instructions 0
    set loc [[-3 0] [-2 1.25] [-1 -1]   [0 0] [1 -1] [2 0] [-0.4 -3] [0.5 3] [0.75 2] [0 1.25] [-1 2] [1.7 -2] [3 -2.5] ]
    setup-turtles
    set expstate 1
    set iter 0
    set lit n-values count turtles [0]
  ]
  if expstate = 1[
    blink-neighbors 0 adj
  ]
  if expstate = 2[
    ask turtles [set color red]
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 3[
    blink-neighbors 4 adj
  ]
  if expstate = 4[
    ask turtles [set color red]
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 5[
    blink-neighbors 7 adj
  ]
  if expstate = 6[
    ask turtles [set color red]
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 7[
    set querystate 0
    set expstate expstate + 1
    print-instructions 1
    ask turtles [set color red]
  ]
  if expstate = 8[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
  if expstate = 9[
    ifelse clicked = 6 [  ;;if in the previous they clicked on the right one then lets go to the end.
      set expstate 13
      set logStr word logStr word -1 ","
      set logStr word logStr word -1 ","
    ] [
      set querystate 0
      set expstate expstate + 1
      print-instructions 2
      ask turtles [set color red]
    ]
  ]
  if expstate = 10[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
  if expstate = 11[
    ifelse clicked = 6 [
      set expstate 13
      set logStr word logStr word -1 ","
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 3
    ;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 12[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
  if expstate = 13[
    user-message ("Round Nine Complete")
    show logstr
    clear-turtles
    set state state + 1
    set expstate 0
  ]
end


to start-experiment-ten
let adj
  [[0 1 0 0 0 0 0 0 0 0 0 0 0 0]
   [1 0 1 0 0 0 0 0 0 0 0 0 0 0]
   [0 1 0 1 0 0 0 0 0 0 0 0 0 0]
   [0 0 1 0 1 0 0 0 0 0 0 0 0 0]
   [0 0 0 1 0 1 0 0 0 0 0 0 0 0]
   [0 0 0 0 1 0 1 0 0 0 0 0 0 0]
   [0 0 0 0 0 1 0 1 0 0 0 0 0 0]
   [0 0 0 0 0 0 1 0 1 0 0 0 0 0]
   [0 0 0 0 0 0 0 1 0 1 0 0 0 0]
   [0 0 0 0 0 0 0 0 1 0 1 0 0 0]
   [0 0 0 0 0 0 0 0 0 1 0 1 0 0]
   [0 0 0 0 0 0 0 0 0 0 1 0 1 0]
   [0 0 0 0 0 0 0 0 0 0 0 1 0 1]
   [0 0 0 0 0 0 0 0 0 0 0 0 1 0]]

  if expstate = 0[
    print-instructions 0
    set loc [[-2 1] [-3 1] [1 1] [-1 1] [0 -1]  [2 -1] [3 1]
    [-3 -1] [-2 -1] [-1 -1] [0 1] [1 -1] [2 1]  [3 -1]]
    setup-turtles
    set expstate 1
    set iter 0
    set lit n-values count turtles [0]
  ]
  if expstate = 1[
    blink-neighbors 0 adj
  ]
  if expstate = 2[
    ask turtles [set color red]
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 3[
    blink-neighbors 4 adj
  ]
  if expstate = 4[
    ask turtles [set color red]
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 5[
    blink-neighbors 7 adj
  ]
  if expstate = 6[
    ask turtles [set color red]
    set expstate expstate + 1
    set iter 0
  ]
  if expstate = 7[
    set querystate 0
    set expstate expstate + 1
    print-instructions 1
    ask turtles [set color red]
  ]
  if expstate = 8[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
  if expstate = 9[
    ifelse clicked = 6 or clicked = 7[  ;;if in the previous they clicked on the right one then lets go to the end.
      set expstate 13
      set logStr word logStr word -1 ","
      set logStr word logStr word -1 ","
    ] [
      set querystate 0
      set expstate expstate + 1
      print-instructions 2
      ask turtles [set color red]
    ]
  ]
  if expstate = 10[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
  if expstate = 11[
    ifelse clicked = 6 or clicked = 7[
      set expstate 13
      set logStr word logStr word -1 ","
    ] [
    set querystate 0
    set expstate expstate + 1
    print-instructions 3
    ;user-message ("Click on another item")
    ask turtles [set color red]
    ]
  ]
  if expstate = 12[
    queryUser
    if querystate = 1[
     blink-neighbors clicked adj
    ]
  ]
  if expstate = 13[
    finish
    user-message (word "Experiment Complete!  Return to Mechanical Turk with your code:" LogStr)
    show logstr
    clear-turtles
    set state state + 1
    set expstate 0
  ]
end




to blink-neighbors [starter network]
    every 0.4[
    if iter < 30 and iter > 0 [ ;; rounds of propogation
      let litnew lit
      let i 0
      while [i < count turtles] [
        if item i lit = 1 [ ;;if this item is recently lit then lets see what else we can light
          let j 0
          while [j < count turtles][ ;;check all other nodes
            if 1 = item j item i network [ ;;check what its nearby using adjacency matrix
              set litnew replace-item j litnew 1
            ]
            set j j + 1
          ]
          set litnew replace-item i litnew 2
        ]
        set i i + 1
      ]
      set lit litnew
      set i 0
      while [i < count turtles] [ ;;not scalable
        if 1 = item i lit [
          ask turtle i
          [set color green]
        ]
        set i i + 1
      ]
      set iter iter + 1

      let t 0  ;;check if we are all done if so then go to the next phase
      foreach lit [turt ->
        if turt = 0 [
          set t 1
        ]
      ]
      ;;show lit
      ;;show iter
      if t =  1[
        set iter 28
      ];;check if we are all done if so then go to the next one
    ]
    if iter = 30[
      set expstate expstate + 1
    ]
    if iter = 0[ ;if first round setup the starter.  this is after to allow the iter state to work
      set lit n-values count turtles [0]
      set lit replace-item starter lit 1
      ask turtle starter [set color green]
      set iter 1
    ]
  ]
end


to blink [starter]  ;;this is regular blink


    every 0.4[
    if iter < 30 and iter > 0 [ ;; rounds of propogation
      let litnew lit
      let i 0
      while [i < count turtles] [
        if item i lit = 1 [ ;;if this item is recently lit then lets see what else we can light
          let j 0
          while [j < count turtles][ ;;check all other nodes
            ;;if 1 = item j item i network [ ;;check what its nearby using adjacency matrix
            let tx item 0 item j loc - item 0 item i loc
            let ty item 1 item j loc - item 1 item i loc
            if sqrt ((tx * tx) + (ty * ty)) < 1.5 [ ;;calculate l2 norm and decide on next to light
              set litnew replace-item j litnew 1
            ]
            set j j + 1
          ]
          set litnew replace-item i litnew 2
        ]
        set i i + 1
      ]
      set lit litnew
      set i 0
      while [i < count turtles] [ ;;not scalable
        if 1 = item i lit [
          ask turtle i
          [set color green]
        ]
        set i i + 1
      ]
      set iter iter + 1

      let t 0  ;;check if we are all done if so then go to the next phase
      foreach lit [turt ->
        if turt = 0 [
          set t 1
        ]
      ]
      ;;show lit
      ;;show iter
      if t =  0 and iter != 30[
        set iter 29
      ];;check if we are all done if so then go to the next one
    ]
    if iter = 30[
      set expstate expstate + 1
    ]
    if iter = 0[ ;if first round setup the starter.  this is after to allow the iter state to work
      set lit n-values count turtles [0]
      set lit replace-item starter lit 1
      ask turtle starter [set color green]
      set iter 1
    ]
  ]
end

to queryUser []
  if querystate = 0 [
    set clicked -1
    let turt 0
    if clicked = -1[
      if mouse-down? [
        ask turtles with [distancexy mouse-xcor mouse-ycor < 0.35] [
          set clicked who
          set querystate 1
          set logStr word logStr word clicked ","
          show logStr
          set iter 0
        ]
      ]
    ]
  ]
end

to print-instructions [choice]
 if choice = 0[
    clear-output
    output-print "Study the way color changes "
    output-print "across the group of blocks."
  ]
  if choice = 1 [
    clear-output
    output-print "Start a new color change by"
    output-print "clicking a block. Try to"
    output-print "pick a block that will make the"
    output-print "color change happen in the"
    output-print "FEWEST time steps possible."
  ]
  if choice = 2 [
    clear-output
    output-print "Close!  Let's try again"
    output-print "on the same graph. Start"
    output-print "a new color change by clicking"
    output-print "a block. Try to pick a different"
    output-print "block that will make the color "
    output-print "change happen in the FEWEST time"
    output-print "steps possible."
  ]
  if choice = 3[
    clear-output
    output-print "Almost, one last time!  Let's try"
    output-print "again on the same graph. Start"
    output-print "a new color change by clicking"
    output-print "a block. Try to pick a different"
    output-print "block that will make the color "
    output-print "change happen in the FEWEST time"
    output-print "steps possible."
  ]
  if choice = 10[
    clear-output
    output-print "Start a new color change by"
    output-print "clicking a block. Try to"
    output-print "pick a block that will make the"
    output-print "color change happen in the"
    output-print "FEWEST time steps possible."
  ]
  if choice = 100[
    clear-output
    output-print "Study Complete!"
    output-print "Return to Mechanical Turk"
    output-print ""
    output-print "Your Exit Code is:"
    output-print LogStr
  ]


end

to finish
  show "Logging:"
  show logStr
  let response-triplet (http-req:post "http://54.89.180.124/posttest-data" logStr "text/plain")
  ifelse (first response-triplet) = 200 [
    show "logs successfully sent"
    set state state + 1
  ]
  [
   show "log transmission failed"
    finish
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
325
30
858
564
-1
-1
75.0
1
50
1
1
1
0
1
1
1
-3
3
-3
3
0
0
1
ticks
30.0

BUTTON
81
110
219
207
START
setup
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

OUTPUT
19
302
297
481
14

TEXTBOX
35
269
185
291
Instructions:
18
0.0
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

border
false
0
Rectangle -7500403 true true 0 -30 315 315
Rectangle -1 true false 45 45 255 255

border2
false
0
Rectangle -7500403 true true 0 -30 315 315
Rectangle -1 true false 30 30 270 270
Rectangle -16777216 false false 30 30 270 270

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

dani-border
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -1 true false 60 60 240 240

dani-space-border
false
0
Rectangle -7500403 true true 30 60 270 300
Rectangle -1 true false 60 90 240 270

dani-triangle
false
0
Rectangle -1 true false 60 60 240 240
Rectangle -1 true false 30 30 270 270
Polygon -7500403 true true 30 270 150 30 270 270 30 270
Polygon -1 true false 60 255 150 75 240 255 60 255

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
