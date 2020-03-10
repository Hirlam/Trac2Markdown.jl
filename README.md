# Trac2Markdown.jl

[![Build Status](https://travis-ci.com/Hirlam/Trac2Markdown.jl.svg?branch=master)](https://travis-ci.com/Hirlam/Trac2Markdown.jl)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://Hirlam.github.io/Trac2Markdown.jl/dev)


Converts trac wiki to markdown

## Obtaining the source  

```bash
git clone https://github.com/Hirlam/Trac2Markdown.jl Trac2Markdown
```

## Usage

From the `Trac2Markdown` directory 

```bash
julia --project --color=yes -e 'using Pkg; Pkg.instantiate(); Pkg.test()'
```

This will run the unit tests, downloads wiki pages from hirlam.org 
and converts them to markdown.

## To do 

Add unit test to Travis so there is no need to have a local Julia installation. 

### Note

Outside a domain recognized by hirlam.org run 
```bash
export HLUSER=<hirlam.org username>
export HLPASSW=<hirlam.org password>
```
before instantiating the `Trac2Markdown` package.






