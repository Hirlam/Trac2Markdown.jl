module Trac2Markdown

using Logging, HTTP

export trac2md,
       trac2markdown, 
       MARKDOWNDIR

# Note `export HLUSER=<hluser>` and `export HLPASSW=<passwd> before using Trac2Markdown 
const hluser = get(ENV,"HLUSER","")
const hlpassw = get(ENV,"HLPASSW","")



const MARKDOWNDIR   = joinpath(dirname(pathof(Trac2Markdown)), "../docs/src/")
const WIKIDIR   = joinpath(dirname(pathof(Trac2Markdown)), "../docs/wiki/")
const tracurl       = "https://$hluser:$hlpassw@hirlam.org/trac/"
const wikiurl       = "$tracurl/wiki/"
const attachmenturl = "$tracurl/raw-attachment/wiki/"

include("trac2markdown.jl")
include("trac2md.jl")
include("getpages.jl")
include("replace_code.jl")
include("replace_tables.jl")
include("pages.jl")

end # module