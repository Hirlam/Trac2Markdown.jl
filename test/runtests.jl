using Test, Trac2Markdown

@testset "trac2md" begin

   @test trac2md("= h1 =") == "# h1"
   @test trac2md("== h1 ==") == "## h1"
   @test trac2md("[[Nav symbol]]\r\n") == ""
   @test trac2md("{{{ a=2 }}}")  == "` a=2 `" 
   @test trac2md("{{{ \r\n a=2 \r\n }}}")  == "```bash \r\n a=2 \r\n ```" 

   # This should work because we will assume ecf/myfile is a path
   @test_broken trac2md("Hello ecf/myfile ") == "Hello `ecf/myfile` " 

   # This should work because _ implies a code symbol 
   @test_broken trac2md("Hello config_exp.h ") == "Hello `config_exp.h` "

   # This should work basd on explicit list of Harmonie code keywords
   @test_broken trac2md("Hello ANAATMO ") == "Hello `ANAATMO` "

   # This 
   @test trac2md("{{{ Hello ecf/myfile }}}") == "` Hello ecf/myfile `"







end