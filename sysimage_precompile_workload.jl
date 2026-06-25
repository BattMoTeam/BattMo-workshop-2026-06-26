using BattMo, Jutul, GLMakie, CSV, DataFrames

GLMakie.activate!(inline = false)

cell_parameters = load_cell_parameters(; from_default_set = "chen_2020")
cycling_protocol = load_cycling_protocol(; from_default_set = "cc_discharge")

model = LithiumIonBattery()
sim = Simulation(model, cell_parameters, cycling_protocol)
output = solve(sim)

plot_dashboard(output; plot_type = "simple")
GLMakie.closeall()

data = DataFrame(x = 1:5, y = rand(5))
csv_path = joinpath(tempdir(), "battmo_sysimage_precompile.csv")
CSV.write(csv_path, data)
CSV.read(csv_path, DataFrame)
rm(csv_path; force = true)
