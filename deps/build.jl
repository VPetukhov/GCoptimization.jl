const version = "1.2.6"
const name = "GCoptimization"
const libname = "lib"*name
const repo = "https://github.com/Gnimuc/$name"
const suffix = Sys.WORD_SIZE == 64 ? "x64" : "x86"

prefix = joinpath(dirname(@__FILE__), "usr")
srcdir = joinpath(dirname(@__FILE__), "src", "$name-$version")
builddir = joinpath(dirname(@__FILE__), "builds", "$name-$version")

# download source code
mkpath("downloads")
tarball = "downloads/$name-$version.tar.gz"
if !isfile(tarball)
    info("Downloading $name-$version source from $repo...")
    download("$repo/archive/v$version.tar.gz", tarball)
end

# unpack source tarball
mkpath(srcdir)
run(`tar xzf $tarball -C src`)

# copy header files
mkpath(joinpath(prefix, "include"))
cp(joinpath(srcdir, "include"), joinpath(prefix, "include"), remove_destination=true)


if is_windows()
    const archive = "downloads/$name-$version.zip"
    if !isfile(archive)
        info("Downloading $name-$version binaries from $repo...")
        download("$repo/releases/download/v$version/$libname-$suffix.zip", archive)
    end
    run(`7z e $archive`)
end

if is_apple() || is_linux()
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
