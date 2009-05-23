# Version number for this release
VERSION_NUMBER = "0.1.0"
# Version number for the next release - TODO How is this actually used?
NEXT_VERSION = "0.1.1"

# Group identifier for your projects
GROUP = "com.tristanhunt"
COPYRIGHT = "Copyright 2009 Tristan Juricek"

# Fix for buildr 1.3.3
require 'buildr/scala'

# Currently pointing to a convenient location, my company's nexus server. Should be fine for read
# usage, but you *shouldn't* have access to publishing.
repositories.remote << "http://nexus.emarsys.com/content/groups/public"

# Configure all project dependencies here... except for scala, which uses the SCALA_HOME environment
# variable to create the big fat jar for distribution.
JARJAR          = "jarjar:jarjar:jar:1.0"
TESTNG          = "org.testng:testng:jar:jdk15:5.8"


desc "KnockOff - Markdown Parser in Scala"
define "knockoff" do

    project.version = VERSION_NUMBER
    project.group = GROUP
    manifest["Implementation-Vendor"] = COPYRIGHT

    package(:jar, :id => "knockoff")

    test.using :testng, :fail_on_failure=>false
end