
# Installation 

To install the Julia Documenter dependency run 

```bash
julia --project -e 'using Pkg; Pkg.instantiate()'
```

# Documentation 
The documentation is created by 

```bash
julia --project make.jl
```

The HTML pages are written to `docs/build`

## Travis continuous integration

Travis will run `julia --project make.jl` and pushes the resulting `docs/build` directory to the `gh-pages` branch. By github convention the content of `gh-pages` branch is automatically served on `https://hirlam.github.io/Trac2Markdown.jl/dev/`
