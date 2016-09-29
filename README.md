# GCoptimization

[![Build Status](https://travis-ci.org/Gnimuc/GCoptimization.jl.svg?branch=master)](https://travis-ci.org/Gnimuc/GCoptimization.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/hmcjk5sr3j01xk6r?svg=true)](https://ci.appveyor.com/project/Gnimuc/gcoptimization-jl)
[![codecov](https://codecov.io/gh/Gnimuc/GCoptimization.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Gnimuc/GCoptimization.jl)

Julia wrappers for gco-v3.0 multi-label optimization library. This package provides both low-level and high-level interfaces. The low-level interface is one-to-one with the C++ interface of the gco-v3.0 library, and the high-level interface provides the ability to work with julia's abstract arrays(e.g. Vector, Matrix).

## Installation

Firstly, make sure package [Cxx.jl](https://github.com/Keno/Cxx.jl) works on your machine. Then build the package with these two lines as below:

```julia
Pkg.clone("https://github.com/Gnimuc/GCoptimization.jl.git")
Pkg.build("GCoptimization")
```
(I'll register it as a standard julia package as long as the code climate of Cxx.jl becomes more stable.)

## Usage
Note that, sites and labels are 0-based indices in low level interface, and non-Cint values will be automatically converted to Cint. More examples [here](https://github.com/Gnimuc/GCoptimization.jl/tree/master/examples).

### The high level interface

```julia
using GCoptimization

pixelNum = 4
labelNum = 3

# create a handle of a general graph object
gco = gco_create(pixelNum, labelNum)

# set data cost via matrix
#          pixel1 pixel2 pixel3 pixel4
# label 1    0      9      2      0
# label 2    3      0      3      3
# label 3    5      9      0      5
gco_setdatacost(gco, [
    0 9 2 0;         
    3 0 3 3;
    5 9 0 5])

# set smooth cost via matrix
#          label1 label2 label3
# label 1    0      1      2
# label 2    1      0      1
# label 3    2      1      0
gco_setsmoothcost(gco, [
    0 1 2;
    1 0 1;
    2 1 0])

# set neighbor system via weight matrix
#          pixel1 pixel1 pixel3 pixel4
# pixel 1    0      1      0      0
# pixel 2    0      0      1      0
# pixel 3    0      0      0      2
# pixel 4    0      0      0      0
gco_setneighbors(gco, [
    0 1 0 0;
    0 0 1 0;
    0 0 0 2;
    0 0 0 0])

# compute energy using α-expansion
gco_expansion(gco)

# get results
gco_getlabeling(gco)

# (total energy, data energy, smooth energy, label energy)
gco_energy(gco)

```

### The low level interface

```julia
using GCoptimization

width = 10
height = 5
pixelNum = width * height
labelNum = 7

# create a handle of grid graph object
gco = GCoptimizationGridGraph(width, height, labelNum)

# define data cost function
function dataFn(pixel::GCOSiteID, label::GCOLabelID)::GCOEnergyTermType
    if pixel < 25
        return label == 0 ? 0 : 10
    else
        return label == 5 ? 0 : 10
    end
end

# set data cost via function
setDataCost(gco, dataFn)

# define smooth cost function
smoothFn(p1::GCOSiteID, p2::GCOSiteID, l1::GCOLabelID, l2::GCOLabelID)::GCOEnergyTermType = (l1-l2)*(l1-l2) <= 4 ? (l1-l2)*(l1-l2) : 4

# set smooth cost via function
setSmoothCost(gco, smoothFn)

# compute energy
println("Before optimization energy is ", compute_energy(gco))
expansion(gco, 2)
println("After optimization energy is ", compute_energy(gco))

# get results
result = [whatLabel(gco, i-1) for i = 1:pixelNum]
showall(result)

```

## TODO List

- [ ] decent documentation
- [ ] towards 100% coverage
- [ ] more high level helper functions

## Links

- [gco-v3.0](http://vision.csd.uwo.ca/code/): original C++ code bundled with a MATLAB wrapper
- [pygco](https://github.com/amueller/gco_python): Python wrappers for gco-v3.0 library

## LICENSE
This package will download and compile gco-v3.0 source code from [GCoptimization](https://github.com/Gnimuc/GCoptimization) which has its own license.
Please checkout [the license](https://github.com/Gnimuc/GCoptimization/blob/master/GCO_README.TXT) before using this package. The Julia wrappers here are licensed under [the MIT "Expat" License](https://github.com/Gnimuc/GCoptimization.jl/blob/master/LICENSE.md).
