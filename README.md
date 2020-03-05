# Trac2Markdown.jl

[![Build Status](https://travis-ci.com/Hirlam/Trac2Markdown.jl.svg?branch=master)](https://travis-ci.com/Hirlam/Trac2Markdown.jl)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://Hirlam.github.io/Trac2Markdown.jl/dev)


Converts trac wiki to markdown

## Installation 

You can obtain Trac2Markdown.jl using Julia's Pkg REPL-mode (hitting `]` as the first character of the command prompt):

```julia
(v1.3) pkg> add https://github.com/Hirlam/Trac2Markdown.jl
```

Or 

```bash
git clone https://github.com/Hirlam/Trac2Markdown.jl Trac2Markdown
```

## Usage


In the Julia package manager

```julia
(v1.3) pkg> test Trac2Markdown
```

Or if the `Project.toml` from `Trac2Markdown` is your active environment 

```julia
(Trac2Markdown) pkg> test
```

Or using the command line
```bash
julia --project --color=yes -e 'using Pkg; Pkg.instantiate(); Pkg.test()'
```
This will run the unit tests, downloads wiki pages from hirlam.org 
and converts them to markdown.

Note: outside a domain recognized by hirlam.org run 
```bash
export HLUSER=<hirlam.org username>
export HLPASSW=<hirlam.org password>
```
before instantiating the `Trac2Markdown` package.

## Documention
The documentation is created by 
```bash
cd Trac2Markdown/docs
julia make.jl
```

The HTML pages are written to `docs/build`

The same command is used by travis and runs on any push to github. 
The `docs/build`  directory is deployed to the `gh-pages` branch which get automatically served on `https://hirlam.github.io/Trac2Markdown.jl/dev/`






