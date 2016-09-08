using BinDeps

@BinDeps.setup

const version = "1.2.0"
const name = "GCoptimization"
const repo = "https://github.com/Gnimuc/GCoptimization"

libGCO = library_dependency("libGCoptimization", aliases = ["libGCoptimization-x86", "libGCoptimization-x64"])

prefix = joinpath(BinDeps.depsdir(libGCO), "usr")
srcdir = joinpath(BinDeps.srcdir(libGCO), "$(name)-$(version)")

if is_windows()
    # directly download complied dll files
    info("Downloading generated binaries from Gnimuc/GCoptimization repo...")
    downloads("$(repo)/releases/download/v$(version)/lib$(name)-x$(Sys.WORD_SIZE).$(Libdl.dlext)", "usr/lib$(Sys.WORD_SIZE)/lib$(name).$(Libdl.dlext)")
end
    info("Downloading source code from Gnimuc/GCoptimization repo...")
    provides(Sources, URI("$(repo)/archive/v$(version).tar.gz"),
        [libGCO], unpacked_dir="$(name)-$(version)")

    provides(BuildProcess,
        (@build_steps begin
            GetSources(libGCO)
            @build_steps begin
                ChangeDirectory(srcdir)
                @build_steps begin
                    `cmake .`
                    `make`
                end
            end
        end), libGCO, os = :Unix)

    cp(joinpath(srcdir, "lib"), joinpath(BinDeps.depsdir(libGCO), "usr/lib"), remove_destination=true)
end

@BinDeps.install Dict(:libGCO => :libGCO)
