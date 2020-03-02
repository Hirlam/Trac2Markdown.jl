module Trac2Markdown

#export trac2md 



#function trac2md(s::String) 

    #subs =  [ 
    #   r"\[(https://.+?) (.+?)\]"    => s"[\2](\1)",  # hrefs
    #   r"\[wiki:(.+?) (.+?)\]"       => s"[\2](\1)",    
    #   r"{{{([^\r\n]+?)}}}"           => s"`\1`",      # code blocks      
    #   r"=== (.+?) ==="              => s"## \1",     # level 2 headers        
    #   r"== '''(.+?)''' =="          => s"## \1",     # level 2 header   
    #   r"= '''(.+)''' ="             => s"# \1",      # level 1 headers  
    #   r"== (.+?) =="                => s"# \1",      # level 1 headers     
    #   r"\[\[.+\]\]\r\n"             => s"",          # Navigation symbols  (removed)    
    #] 

    #return foldl(replace, subs, init = s)
#end 

end # module
