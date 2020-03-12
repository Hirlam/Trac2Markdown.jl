module Trac2Markdown

using Logging, HTTP

export trac2md,
       trac2markdown, 
       MARKDOWNDIR




const MARKDOWNDIR      = joinpath(dirname(pathof(Trac2Markdown)), "../docs/src/")
const WIKIDIR          = joinpath(dirname(pathof(Trac2Markdown)), "../deps/wiki/")

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

end # module