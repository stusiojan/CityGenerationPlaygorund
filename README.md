# CityGenerationPlaygorund

## 🔨 Project structure

```
├── README.md          <- The top-level README for developers using this project.
│
├── Reports            <- Project reports
│
├── Terrain            <- Terrain extraction module
│   │
│   ├── convert_asc.py <- Code for converting and rendering terrain.
│   ├── config.py      <- Module variables
│   ├── makefile       <- Makefile with convenience commands.
│   ├── data           <- ASCII terrain models.
│   └── models
│       └── model.py   <- Data structures for terrain data
│
└── Road-generation-alg/Road-gen-alg        <- macOS app
    │
    ├── Road-gen-alg
    │   ├── Models                          <- Graph representation of roads with abstractions.
    │   ├── RoadGeneration                  <- Road generation algorithm logic
    │   ├── Views                           <- Rendering logic
    │   └── Road_gen_algApp.swift           <- Apps entry point
    │
    ├── Road-gen-alg.xcodeproj              <- Xcode project file
    │
    ├── Road-gen-algTests                   <- tests
    │
    └── Road-gen-algUITests                 <- UI tests
```


# 🌍 Terrain module

This module is responsible for terrain data extraction from `.asc` file.

## Setup and run

1. Go to `Terrain` dir
2. Prepare conda environment: `make create_conda_env` & `make activate_conda_env`
3. Run `make render` to render terrain

# 🧮 Road generation algorithm module

L - systems are considered "go to" when it comes to procedural road generation.

In this [paper](https://cgl.ethz.ch/Downloads/Publications/Papers/2001/p_Par01.pdf) authors defined `extended L-systems` which should perform even better with such task.

I've stumbled across an [article](http://nothings.org/gamedev/l_systems.html), which critics this approach for being too convoluted and propose more consise algorithm.

```
initialize priority queue Q with a single entry:
     r(0,ra,qa)

initialize segment list S to empty

until Q is empty
    pop smallest r(t,ra,qa) from Q
        compute (nqa, state) = localConstraints(qa)
        if (state == SUCCEED) {
            add segment(ra) to S
            addZeroToThreeRoadsUsingGlobalGoals(Q, t+1, qa,ra)
```

In this project I'll try to implement both algorithms to decide, which is better for what task.

## Setup and run

This is macOS native app. To run app you will need:
- Xcode 16+
- Swift 6+
- MacOS 15+

Simply run on macOs target

![](/Reports/Figures/app_window.jpg)

![](/Reports/Figures/generated_roads.jpg)
*NOTE: This is a demo product with random generation rules, so the resulting road network is random too*