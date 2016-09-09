using BinDeps

@BinDeps.setup

const version = "1.2.2"
const name = "GCoptimization"
const repo = "https://github.com/Gnimuc/GCoptimization"

libGCO = library_dependency("libGCoptimization", aliases = ["libGCoptimization-x86", "libGCoptimization-x64"])

prefix = joinpath(BinDeps.depsdir(libGCO), "usr")
srcdir = joinpath(BinDeps.srcdir(libGCO), "$(name)-$(version)")

if is_windows()
    # directly download pre-complied dll files
    info("Downloading generated binaries from Gnimuc/GCoptimization repo...")
    provides(Binaries, URI("$(repo)/releases/download/v$(version)/lib$(name)-x$(Sys.WORD_SIZE).zip"),
        libGCO, unpacked_dir="$(prefix)/lib$(Sys.WORD_SIZE)")
else
    mkpath("usr/lib")
    info("Downloading source code from Gnimuc/GCoptimization repo...")
    provides(Sources, URI("$(repo)/archive/v$(version).tar.gz"),
        libGCO, unpacked_dir="$(name)-$(version)")

    provides(BuildProcess,
        (@build_steps begin
            GetSources(libGCO)
            @build_steps begin
                ChangeDirectory(srcdir)
                @build_steps begin
                    `cmake .`
                    `make`
                    `cp -R lib ../../usr`
                end
            end
        end), libGCO)
end

@BinDeps.install Dict(:libGCO => :libGCO)
