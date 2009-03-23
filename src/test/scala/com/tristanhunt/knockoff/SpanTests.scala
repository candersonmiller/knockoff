package com.tristanhunt.knockoff

import org.testng.Assert._
import org.testng.annotations._

@Test
class SpanTests {
 
    def inlineHTML = {
     
        val actual = (SpanParser.apply).parse("""A block with <span class="strong">Some <br><br> HTML</span> in it.""")
        
        val expected = List(
            Text("A block with "),
            HTML("""<span class="strong">Some <br><br> HTML</span>"""),
            Text(" in it."))
        
        assertTrue(actual sameElements expected)
    }
    
    def emphasisTest = {
        assertTrue(Emphasis(Nil) == Emphasis(Nil))
        assertTrue(Emphasis(List(Text("a"))) == Emphasis(List(Text("a"))))
        assertTrue(Emphasis(List(Text("b"))) != Emphasis(List(Text("a"))))
    }
    
    
    def emphasisUnderscore = {
     
        val actual = (SpanParser.apply).parse("""_emphasis_ possibly with _two words_""")
        
        val expected = List(
            Emphasis(List(Text("emphasis"))),
            Text(" possibly with "),
            Emphasis(List(Text("two words"))))
        
        assertTrue(actual sameElements expected)
    }
    
    def emphasisAsterix = {
     
        val actual = (SpanParser.apply).parse("""*shocking _but_ true*""")
        
        val expected = List(
            Emphasis(List(
                Text("shocking "),
                Emphasis(List(Text("but"))),
                Text(" true"))))
        
        assertTrue(actual sameElements expected)
    }
    
    def strongUnderscore = {
        
        val actual = (SpanParser.apply).parse("""This __is a *fucking* test__""")
        
        val expected = List(
            Text("This "),
            Strong(List(
                Text("is a "),
                Emphasis(List(Text("fucking"))),
                Text(" test"))))
                
        assertTrue(actual sameElements expected)
    }
    
    def strongAsterix { // != obelix
        
        val actual = (SpanParser.apply).parse("""**hi** you **guy__**what__?""")
        
        val expected = List(
            Strong(List(Text("hi"))),
            Text(" you "),
            Strong(List(Text("guy__"))),
            Text("what__?"))
            
        assertTrue(actual sameElements expected)
    }
    
    def inlineLink {
     
        val actual = (SpanParser.apply).parse("[First](http://example.com) link has no title." +
            "[The *second* link](http://example.com/foo?bar=bat \"Crappy \"Think\" Link\") has a title. And then, " +
            "of course, there's the [Empty]() empty link.")
        
        val expected = List(
            Link(List(Text("First")), "http://example.com", ""),
            Text(" link has no title."),
            Link(
                List(Text("The "), Emphasis(List(Text("second"))), Text(" link")),
                "http://example.com/foo?bar=bat",
                "Crappy \"Think\" Link"),
            Text(" has a title. And then, of course, there's the "),
            Link(List(Text("Empty")), "", ""),
            Text(" empty link."))
        
        assertTrue(actual sameElements expected)
    }
    
    def imageLink {
        
        val actual = (SpanParser.apply).parse("![Alternative Text](http://path/to/image.jpg \"Title\")")
        
        val expected = List(ImageLink(List(Text("Alternative Text")), "http://path/to/image.jpg", "Title"))
        
        assertTrue(actual sameElements expected)
    }
}