# test file for high-level APIs
# those tests are transported from Andrew Delong and Anton Osokin's Matlab wrapper. All credit goes to them.

sc = [0 1 2 3 3 3 3 3 3;
      1 0 1 2 3 3 3 3 3;
      2 1 0 1 2 3 3 3 3;
      3 2 1 0 1 2 3 3 3;
      3 3 2 1 0 1 2 3 3;
      3 3 3 2 1 0 1 2 3;
      3 3 3 3 2 1 0 1 2;
      3 3 3 3 3 2 1 0 1;
      3 3 3 3 3 3 2 1 0]

# gco_create
@test_throws Cxx.CxxException gco_create(1, 1)
@test_throws Cxx.CxxException gco_create(0, 2)

# gco_setlabeling & gco_getlabeling
h = gco_create(4, 3)
@test gco_energy(h)[1] == 0
l = [2, 1, 3, 2]
gco_setlabeling(h, l)
@test_throws AssertionError gco_setlabeling(h, [l,1;])
@test gco_getlabeling(h) == l
@test gco_getlabeling(h, 3) == l[3]
@test gco_getlabeling(h, [2,3]) == l[2:3]
@test_throws AssertionError gco_getlabeling(h, [0,1])
@test_throws AssertionError gco_getlabeling(h, [1,5])

gco_setlabeling(h, 4-l)
@test gco_getlabeling(h) == 4-l

# no cost
h = gco_create(4,3)
@test gco_energy(h)[1] == 0
@test gco_expansion(h) == 0
@test gco_energy(h)[1] == 0
gco_setlabeling(h, 4-gco_getlabeling(h))
@test gco_energy(h)[1] == 0
@test gco_expansion(h) == 0

# datacost
h = gco_create(4, 9)
dc = [1 2 5 8 4 2 3 7 9;
      3 1 2 5 4 5 5 5 5;
      5 5 5 5 4 5 2 1 3;
      9 7 3 2 4 8 5 2 1]'

gco_setdatacost(h, dc)
gco_setlabeling(h, [3, 3, 3, 3])
gco_getlabeling(h)
@test gco_energy(h)[1] == sum(dc[3,:])
gco_setlabeling(h, [1, 2, 3, 4])
@test gco_energy(h)[1] == dc[1,1] + dc[2,2] + dc[3,3] + dc[4,4]
gco_setlabeling(h, [5, 5, 5, 5])
gco_αexpansion(h, 8)
@test gco_getlabeling(h) == [5, 5, 8, 8]
gco_αexpansion(h, 3)
@test gco_getlabeling(h) == [5, 3, 8, 8]
gco_expansion(h)
@test gco_getlabeling(h) == [1, 2, 8, 9]
@test gco_energy(h)[1] == dc[1,1] + dc[2,2] + dc[8,3] + dc[9,4]

# data + smooth
h = gco_create(4,9)
dc = [1 2 5 8 4 2 3 7 9;
      3 1 2 5 4 5 5 5 5;
      5 5 5 5 4 5 2 1 3;
      9 7 3 2 4 8 5 2 1]'
gco_setdatacost(h, dc)
gco_setsmoothcost(h, sc)
gco_setneighbors(h, [0 2 0 0;
                     0 0 1 0;
                     0 0 0 2;
                     0 0 0 0])
gco_setlabeling(h, [3, 3, 3, 3])
@test gco_energy(h)[1] == sum(dc[3,:])
gco_setlabeling(h, [1, 2, 4, 5])
@test gco_energy(h)[1] == dc[1,1] + dc[2,2] + dc[4,3] + dc[5,4] + 6
gco_setlabeling(h, [5, 5, 5, 5])
gco_expansion(h)
@test gco_getlabeling(h) == [2, 2, 8, 8]

# data + label
h = gco_create(4,9);
dc = [1 2 5 8 4 2 3 7 9;
      3 1 3 5 4 3 5 5 5;
      5 5 5 5 4 5 1 1 3;
      9 7 3 2 4 8 5 2 1]'
lc = [9, 9, 1, 1, 1, 2, 1, 9, 9]
gco_setdatacost(h, dc)
gco_setlabelcost(h, lc)
gco_setlabeling(h, [3, 3, 3, 3])
@test gco_energy(h)[1] == sum(dc[3,:]) + lc[3]
gco_setlabeling(h, [1, 2, 4, 5])
@test gco_energy(h)[1] == dc[1,1] + dc[2,2] + dc[4,3] + dc[5,4] + sum(lc[[1 2 4 5]])
gco_setlabeling(h, [5, 5, 5, 5])
gco_expansion(h)
gco_getlabeling(h) == [7, 3, 7, 3]

# test setLabelSubsetCost
h = gco_create(4,9)
gco_setdatacost(h, dc)
gco_setlabelcost(h, lc)
gco_setlabelcost(h, 3, [1, 3, 4, 5, 6])
gco_setlabelcost(h, 4, [4, 8, 9])
gco_setlabeling(h, [3, 3, 3, 3])
@test gco_energy(h)[1] == sum(dc[3,:]) + lc[3] + 3
gco_setlabeling(h, [5, 5, 8, 9])
@test gco_energy(h)[1] == dc[5,1] + dc[5,2] + dc[8,3] + dc[9,4] + sum(lc[[5 8 9]]) + 3 + 4
gco_setlabeling(h, [5, 5, 5, 5])
gco_expansion(h)
gco_getlabeling(h) == [7, 7, 7, 7]
gco_setlabelcost(h, 3, [2])
gco_expansion(h)
gco_getlabeling(h) == [2, 2, 7, 7]

# data + smooth + label
h = gco_create(4, 9)
dc = [1 2 5 8 4 2 3 7 9;
      3 1 3 5 4 2 5 5 5;
      5 5 5 5 5 5 1 1 3;
      9 7 3 2 4 8 5 2 1]'
lc = [1, 9, 1, 1, 1, 1, 1, 9, 9]
gco_setsmoothcost(h, sc)
gco_setneighbors(h,[0 2 0 0;
                    0 0 1 0;
                    0 0 0 2;
                    0 0 0 0])
gco_setdatacost(h, dc)
gco_setlabelcost(h, lc)
gco_setlabeling(h, [3, 3, 3, 3])
@test gco_energy(h)[1] == sum(dc[3,:]) + lc[3]
gco_setlabeling(h, [1, 2, 4, 5])
@test gco_energy(h)[1] == dc[1,1] + dc[2,2] + dc[4,3] + dc[5,4] + sum(lc[[1 2 4 5]]) + 6
gco_setlabeling(h, [5, 5, 5, 5])
gco_expansion(h)
@test gco_getlabeling(h) == [6, 6, 7, 7]

# re-test with setLabelSubsetCost
h = gco_create(4,9)
gco_setsmoothcost(h, sc)
gco_setneighbors(h,[0 2 0 0;
                    0 0 1 0;
                    0 0 0 2;
                    0 0 0 0])
gco_setdatacost(h, dc)
gco_setlabelcost(h, lc)
gco_setlabelcost(h, 3, [1, 3, 4, 5, 6])
gco_setlabelcost(h, 4, [5, 8, 9])
gco_setlabeling(h, [3, 3, 3, 3])
@test gco_energy(h)[1] == sum(dc[3,:]) + lc[3] + 3
gco_setlabeling(h, [5, 5, 8, 9])
@test gco_energy(h)[1] == dc[5,1] + dc[5,2] + dc[8,3] + dc[9,4] + sum(lc[[5 8 9]]) + 3 + 4 + 5
gco_setlabeling(h, [1, 2, 4, 5])
@test gco_energy(h)[1] == dc[1,1] + dc[2,2] + dc[4,3] + dc[5,4] + sum(lc[[1 2 4 5]]) + 3 + 4 + 6
gco_setlabeling(h, [5, 5, 5, 5])
gco_expansion(h)
@test gco_getlabeling(h) == [7, 7, 7, 7]
gco_setlabelcost(h, 0, [7])
gco_setlabeling(h, [3, 3, 3, 3])
gco_expansion(h)
@test gco_getlabeling(h) == [7, 7, 7, 7]
@test gco_energy(h)[3] == 0
gco_setlabelcost(h, 4, [7])
gco_setlabelcost(h, 1, [1, 3, 4, 5, 6])
gco_expansion(h)
@test gco_getlabeling(h) == [6, 6, 4, 4]
@test gco_energy(h)[4] == 3
gco_setsmoothcost(h, sc*3)
gco_setlabeling(h, [5, 5, 7, 9])
@test gco_energy(h)[1] == dc[5,1] + dc[5,2] + dc[7,3] + dc[9,4] + sum(lc[[5 9]]) + 1 + 4 + 4 + 6*3

#
h = gco_create(4, 9)
dc = [1 1 1 1 1 1 1 1 1;
      1 1 1 1 1 1 1 1 1;
      1 1 1 1 1 1 1 1 1;
      1 1 1 1 1 1 1 1 1]'
gco_setdatacost(h, dc)
sc_nonmetric = sc.*sc
gco_setsmoothcost(h, sc_nonmetric)
gco_setneighbors(h,[0 2 0 0;
                    0 0 1 0;
                    0 0 0 2;
                    0 0 0 0])
gco_setlabeling(h, [5, 5, 7, 4])
@test_throws Cxx.CxxException gco_αexpansion(h, 5)

# test swap
h = gco_create(4, 9)
dc = [1 2 5 8 4 2 3 7 9;
      3 1 1 5 4 5 5 5 5;
      5 5 5 5 4 5 1 1 3;
      9 7 3 2 4 8 5 2 1]'
gco_setdatacost(h, dc)
gco_setlabeling(h, [5, 5, 5, 5])
gco_swap(h)
@test gco_getlabeling(h) == [1, 2, 7, 9]

h = gco_create(4, 9)
gco_setdatacost(h, dc)
gco_setsmoothcost(h, sc)
gco_setneighbors(h,[0 2 0 0;
                    0 0 1 0;
                    0 0 0 2;
                    0 0 0 0])
gco_setlabeling(h, [5, 5, 5, 5])
gco_swap(h)
@test gco_getlabeling(h) == [2, 2, 8, 8]
