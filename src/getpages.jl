
"""
    getpages(s)

Given an arbitray nested structure of Arrays of pairs of Arrays etc
This will return an array with all the markdown filenames
"""
getpages(s::String) = s
getpages(p::Pair)   = getpages(p.second)
getpages(a::Array)  = reduce(vcat,getpages.(a))
