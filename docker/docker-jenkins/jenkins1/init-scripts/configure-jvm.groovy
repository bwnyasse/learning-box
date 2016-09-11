import jenkins.model.*
import hudson.model.*

def instance = Jenkins.getInstance()
def jdkDescriptor = instance.getDescriptor(JDK)
jdkDescriptor.setInstallations(
        new JDK("JDK7", "/usr/lib/jvm/java-7-openjdk-amd64/"),
        new JDK("JDK8", "/usr/lib/jvm/java-8-openjdk-amd64/")
)

instance.save()
