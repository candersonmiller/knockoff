# Generated by Buildr 1.3.2, change to your liking
# Version number for this release
VERSION_NUMBER = "1.0.0"
# Version number for the next release
NEXT_VERSION = "1.0.1"
# Group identifier for your projects
GROUP = "com.tristanhunt"
COPYRIGHT = "Copyright 2009 Tristan Juricek"

# Fix for buildr 1.3.3
require 'buildr/scala'

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

    test.with TESTNG
    
    task 'testng' do
        prepare_testng(test.dependencies)
    end
   
    # ## TODO librarize this shit
    # task 'jarjar' do
    #     
    #     ant('jarjar') do |ant|
    #        
    #         ant.taskdef :name=>'jarjar', :classname=>'com.tonicsystems.jarjar.JarJarTask',
    #             :classpath=> artifact(JARJAR).to_s
    #         
    #         # TODO I'm fairly certain that the directory name should be pulled.
    #         ant.jarjar :jarfile=>'target/knockoff.jar' do
    #            
    #             ant.fileset :dir=>"target/classes"
    #             ant.fileset :dir=>"target/resources"
    #            
    #             ant.zipfileset :src=>"#{ENV['SCALA_HOME']}/lib/scala-library.jar"
    #            
    #             test.dependencies.to_a.each { |dep|
    #                 if dep.to_s[-4..-1] == ".jar" then
    #                     ant.zipfileset :src=>dep.to_s
    #                 end
    #             }
    #             
    #         end
    # 
    #     end
    #     
    # end

end

def store_classpath(file_list, file_name)

	# TODO perhaps move this to another function
	dir = File.dirname(file_name)
	
	if !File.exists?(dir) then
		File.makedirs(dir)
	end
	
	File.open(file_name, "w") do |out_file|
	
		out_file.print "export CLASSPATH="
	
		first = true
	
		file_list.to_a.each { |path|
			if (first) then first = false else out_file.print ":" end
			out_file.print path.to_s
		}
	
		out_file.print "\n"
	end
	
end

def make_test_script(file_name)
    File.open(file_name, "w") do |out_file|

        out_file.print <<-END
#!/bin/sh
# 
# This is a test script that is expected to be run from the main project directory. This is for
# path resolution. Pretty much everything generated should end up as a subdirectory of the 'target'
# directory.

cd target

# Check to see if a set of base dependencies are found.
if [ -f test.classpath ]
then
    . test.classpath
else
    echo "No test.classpath found"
    exit 1
fi

# Inject scala and local dependencies
CLASSPATH=$SCALA_HOME/lib/scala-library.jar:$CLASSPATH
CLASSPATH=classes:resources:test/classes:test/resources:$CLASSPATH

# We run the test suite and report it's return value as the real return value, in case a script
# wants to decide to "fail at first failure"
java -cp $CLASSPATH org.testng.TestNG -d test-output ../testng.xml
RETVAL=$?

cd ..
exit $RETVAL
END

		out_file.print "\n"

	end
	
	FileUtils.chmod(0755, file_name)
end


def prepare_testng(dependencies)
    store_classpath(dependencies, "target/test.classpath")
    make_test_script("target/test.sh")
end