module Trac2Markdown

using Logging, HTTP

export trac2md,
       trac2markdown, 
       fetch_wikipages,
       MARKDOWNDIR




const MARKDOWNDIR      = joinpath(dirname(pathof(Trac2Markdown)), "../docs/src/")
const WIKIDIR          = joinpath(dirname(pathof(Trac2Markdown)), "../src/wiki/")

const tracurl       = "https://hirlam.org/trac/"    # make sure password never shows in Markdown doc. 
const wikiurl       = "$tracurl/wiki/"
const attachmenturl = "$tracurl/raw-attachment/wiki/"


include("trac2markdown.jl")
include("trac2md.jl")
include("getpages.jl")
include("replace_code.jl")
include("replace_tables.jl")
include("replace_headers.jl")
include("pages.jl")
include("fetch_wikipages.jl")
end # module