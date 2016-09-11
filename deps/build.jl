using BinDeps

@BinDeps.setup

const version = "1.2.6"
const name = "GCoptimization"
const repo = "https://github.com/Gnimuc/GCoptimization"
const suffix = Sys.WORD_SIZE == 64 ? "x64" : "x86"

libgco = library_dependency("libGCoptimization", aliases = ["libGCoptimization-x86", "libGCoptimization-x64"])

prefix = joinpath(BinDeps.depsdir(libgco), "usr")
srcdir = joinpath(BinDeps.srcdir(libgco), "$(name)-$(version)")
builddir = joinpath(BinDeps.depsdir(libgco), "builds", "$(name)-$(version)")

# download source files
provides(Sources, URI("$(repo)/archive/v$(version).tar.gz"),
    [libgco], unpacked_dir="$(name)-$(version)")

# directly download pre-complied dll files
provides(Binaries, URI("$(repo)/releases/download/v$(version)/lib$(name)-$(suffix).zip"),
    [libgco], unpacked_dir="usr/lib", os=:Windows)

provides(BuildProcess,
    (@build_steps begin
        GetSources(libgco)
        @build_steps begin
            BinDeps.DirectoryRule(joinpath(prefix,"include"), @build_steps begin
                CreateDirectory(joinpath(prefix,"include"))
                `cp -r $srcdir/include $prefix`
            end)
        end
    end), [libgco], os=:Windows)


# build from source
provides(BuildProcess,
    (@build_steps begin
        GetSources(libgco)
        CreateDirectory(builddir)
        @build_steps begin
            ChangeDirectory(builddir)
            BinDeps.DirectoryRule(joinpath(prefix,"lib"), @build_steps begin
                CreateDirectory(joinpath(prefix,"lib"))
                FileRule(joinpath(prefix,"lib","lib$(name).$(Libdl.dlext)"), @build_steps begin
                    `cmake $(srcdir)`
                    `make`
                    `cp lib$(name).$(Libdl.dlext) $prefix/lib`
                end)
                BinDeps.DirectoryRule(joinpath(prefix,"include"), @build_steps begin
                    CreateDirectory(joinpath(prefix,"include"))
                    `cp -r $srcdir/include $prefix`
                end)
            end)
        end
    end), [libgco], os=:Unix)

@BinDeps.install Dict(:libgco => :libgco)
