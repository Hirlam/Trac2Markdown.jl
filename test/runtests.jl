using Test, Trac2Markdown


@testset "headers" begin
   @test trac2md("= h1 =") == "# h1"
   @test trac2md("= header with space=") == "# header with space"     
   @test trac2md("== h2 ==") == "## h2"
   @test trac2md("=== h3 ===") == "### h3"
   @test trac2md("= '''h1''' =") == "# h1"  # note no bold in Markdown
   @test trac2md("== ''' Experiment configuration''' ==") == "## Experiment configuration"
   @test trac2md("[[Nav symbol]]\r\n") == ""
end 

@testset "codeblocks" begin 
   @test trac2md("{{{ a=2 }}}")  == "` a=2 `" 
   @test trac2md("{{{\r\n a=2 \r\n}}}")  == "```bash\r\n a=2 \r\n```" 
end 

@testset "tables" begin   
   @test trac2md("|| h1 || h2 ||\r\n|| a1 || a2 ||") == "\r\n| h1 | h2 |\r\n| --- | --- |\r\n| a1 | a2 |"
end 

@testset "Convert wiki to markdown"  begin
   
   pages = Trac2Markdown.getpages(Trac2Markdown.pages)

   pages_noext = getindex.(splitext.(pages),1)
   
   trac2markdown.(pages_noext, getattachments=false)

   @test 1==1
end
