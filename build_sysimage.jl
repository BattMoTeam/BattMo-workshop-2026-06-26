import Pkg

const PROJECT_DIR = @__DIR__

# Make sure the workshop project itself is fully instantiated before we build
# a sysimage out of it.
Pkg.activate(PROJECT_DIR)
Pkg.instantiate()

# PackageCompiler (and JSON, used below to edit settings.json) are only needed
# to build the sysimage, not to run the notebooks, so we install them into a
# throwaway environment instead of adding them to the workshop project.
Pkg.activate(; temp = true)
Pkg.add(["PackageCompiler", "JSON"])

import PackageCompiler
import JSON

sysimage_name = "battmo_sysimage." * (Sys.iswindows() ? "dll" : Sys.isapple() ? "dylib" : "so")
sysimage_path = joinpath(PROJECT_DIR, sysimage_name)
precompile_file = joinpath(PROJECT_DIR, "sysimage_precompile_workload.jl")

println("Building a Julia sysimage for the BattMo workshop project.")
println("This compiles BattMo, Jutul, GLMakie, CSV and DataFrames into a single image.")
println("It can take 10-20 minutes the first time - grab a coffee.\n")

PackageCompiler.create_sysimage(
    [:BattMo, :Jutul, :GLMakie, :CSV, :DataFrames];
    sysimage_path = sysimage_path,
    project = PROJECT_DIR,
    precompile_execution_file = precompile_file,
)

# Point VS Code's Julia extension at the new sysimage so it gets used
# automatically. `julia.additionalArgs` is read for every Julia process the
# extension starts, both the integrated REPL and notebook kernels.
settings_path = joinpath(PROJECT_DIR, ".vscode", "settings.json")
mkpath(dirname(settings_path))

settings = isfile(settings_path) ? JSON.parsefile(settings_path; dicttype = Dict{String, Any}) : Dict{String, Any}()

existing_args = get(settings, "julia.additionalArgs", Any[])
other_args = filter(a -> !(a isa AbstractString && startswith(a, "--sysimage=")), existing_args)
settings["julia.additionalArgs"] = vcat(other_args, ["--sysimage=$(sysimage_path)"])

open(settings_path, "w") do io
    JSON.print(io, settings, 4)
end

println("\nDone! Sysimage written to:")
println("  $sysimage_path")
println("\nUpdated $settings_path so VS Code uses it automatically.")
println("Reload the VS Code window (Ctrl+Shift+P -> \"Reload Window\") for the change to take effect.")
println("\nIf you ever update packages (a new Manifest.toml) or your Julia version, rerun this script.")
