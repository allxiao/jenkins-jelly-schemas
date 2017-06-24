# Schema Definition for the Jenkins Jelly TagLib

Provides schema definitions for the Jelly tag libraries defined in the Jenkins core project.

The schemas were generated with the script [`schema-gen.rb`](https://github.com/ArieShout/jenkins-jelly-schemas/blob/master/schema-gen.rb)
from [the tag libraries in the Jenkins core](https://github.com/jenkinsci/jenkins/tree/master/core/src/main/resources/lib)
with some manual updates on the `targetNamespace` and `documentation`.

This completes the schema set suggested in the official wiki page
[Writing Jelly views with IDE assistance](https://wiki.jenkins.io/display/JENKINS/Writing+Jelly+views+with+IDE+assistance).

* For [Jelly core, define, format, util and other tag libraries maintained in Apache](http://commons.apache.org/jelly/libs/index.html),
   go to https://github.com/kohsuke/maven-jellydoc-plugin/tree/master/maven-jellydoc-plugin/schemas.
* For staper, go to http://stapler.kohsuke.org/taglib.xsd.
* For Jenkins core tag libraries, refer to the schemas in this repository.

## How to use this?

1. Download the schema files
2. Follow the instructions for your IDE to add the local schema locations for the XML namespaces.
   * [IntelliJ IDEA](https://www.jetbrains.com/help/idea/schemas-and-dtds.html)
   * [Eclipse](https://wiki.eclipse.org/Using_the_XML_Catalog)
   * [NetBeans](https://stackoverflow.com/a/3581954/483266)
3. Now you should have autocompletion support for the tags / attributes in Jelly.
