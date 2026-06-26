using Pkg: Pkg

Pkg.activate(".") # Activates the environment in the current folder
Pkg.instantiate()
Pkg.Registry.update()
Pkg.add("BattMo")
Pkg.add("GLMakie")      # For plotting
Pkg.add("Jutul")        # A multiphysics simulation framework for reservoir modeling and scientific computing
Pkg.add("CSV")          # For reading and writing CSV files
Pkg.add("DataFrames")   # Provides tabular data structures and data manipulation tools, similar to pandas
Pkg.add("LanguageServer") # Helps VS Code run julia notebooks.



