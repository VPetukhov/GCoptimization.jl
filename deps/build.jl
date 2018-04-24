const version = "1.2.8"
const name = "GCoptimization"
const libname = "lib"*name
const repo = "https://github.com/Gnimuc/$name"
const suffix = Sys.WORD_SIZE == 64 ? "x64" : "x86"

prefix = joinpath(dirname(@__FILE__), "usr")
srcdir = joinpath(dirname(@__FILE__), "src", "GraphCutsBuilder-$version")
builddir = joinpath(dirname(@__FILE__), "builds", "$name-$version")

if is_windows()
    # download source code
    mkpath("downloads")
    source = "downloads/$name-$version.zip"
    if !isfile(source)
        info("Downloading $name-$version source from $repo...")
        download("$repo/archive/v$version.zip", source)
    end

    # unpack source zip
    mkpath(srcdir)
    run(`7z x $source -osrc -y`)

    const archive = "downloads/$libname-$suffix-$version.zip"
    if !isfile(archive)
        info("Downloading $name-$version binaries from $repo...")
        download("$repo/releases/download/v$version/$libname-$suffix.zip", archive)
    end
    run(`7z x $archive -y`)
end

if is_apple() || is_linux()
    # download source code
    mkpath("downloads")
    source = "downloads/$name-$version.tar.gz"
    if !isfile(source)
        info("Downloading $name-$version source from $repo...")
        download("$repo/archive/v$version.tar.gz", source)
    end

    # unpack source tarball
    mkpath(srcdir)
    run(`tar xzf $source -C src`)

    try
        mkpath("$prefix/lib")
        mkpath(builddir)
        cd(builddir)
        run(`cmake $srcdir`)
        run(`make`)
        cp("$libname.$(Libdl.dlext)", "$prefix/lib/$libname.$(Libdl.dlext)", remove_destination=true)
    catch err
        warn(err)
        info("Downloading $name-$version binaries from $repo...")
        download("$repo/releases/download/v$version/$libname.$(Libdl.dlext)", "$prefix/lib/$libname.$(Libdl.dlext)")
    end
end

# copy header files
mkpath(joinpath(prefix, "include"))
cp(joinpath(srcdir, "include"), joinpath(prefix, "include"), remove_destination=true)
