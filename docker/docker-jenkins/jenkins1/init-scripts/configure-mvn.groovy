import jenkins.model.*
import hudson.tasks.*

def instance = Jenkins.getInstance()
def mvnDescriptor = instance.getDescriptor(Maven)
mvnDescriptor.setInstallations(
        new Maven.MavenInstallation("3.3.9", "/opt/apache-maven-3.3.9"),
)

instance.save()
