# Road-generation-alg

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
