#  Outside a domain recognized by hirlam.org create a ~/.netrc file (chmod 600) 
#  machines hirlam.org 
#  login <username>
#  password <password>

function fetch_wikipages() 
    # wikiurl = "https://hirlam.org/trac/wiki/"

    files = "$(@__DIR__)/hsdfiles"

    @sync for file in readlines(files)
       #  @async run(`curl -n -sS --create-dirs $wikiurl$file\?format=txt -o $WIKIDIR/$file.wiki`)
       println("Fetching $wikiurl$file?format=txt") 
       run(`curl -n -sS --create-dirs $wikiurl$file\?format=txt -o $WIKIDIR/$file.wiki`)
    end
end 

