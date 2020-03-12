using HTTP


if  get(ENV, "REFRESH_WIKIPAGES", nothing) == "true" 

# Note `export HLUSER=<hluser>` and 
#      `export HLPASSW=<passwd> 
#   before building Trac2Markdown outside recognized domains 

const hluser = get(ENV,"HLUSER","")
const hlpassw = get(ENV,"HLPASSW","")
const wikiurl = "https://$hluser:$hlpassw@hirlam.org/trac/wiki/"


wikifiles = readlines("wikifiles")


for file in wikifiles
    @info "Retrieving $file"    
    resp = HTTP.get("$wikiurl$file?format=txt")    
    mkpath(dirname("wiki/$file"))
    write("wiki/$file.wiki",String(resp.body))   
end 

end 