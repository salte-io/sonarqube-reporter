FROM openjdk:11
LABEL MAINTAINER=dave@salte.io

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install -y nodejs

ENV PATH="/opt/sonar-scanner/bin:${PATH}"
ENV SONAR_SCANNER_HOME=/opt/sonar-scanner
ENV SONAR_SCANNER_OPTS="-Djavax.net.ssl.keyStore=/usr/local/openjdk-11/lib/security/cacerts -Djavax.net.ssl.trustStore=/usr/local/openjdk-11/lib/security/cacerts"

RUN apt update && apt install -y curl zip libsaxonb-java
RUN curl -L -o /tmp/sonar-scanner-cli.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.3.0.2102-linux.zip
RUN unzip /tmp/sonar-scanner-cli.zip -d /opt && \
    mv /opt/sonar-scanner* /opt/sonar-scanner && \
    rm /tmp/sonar-scanner-cli.zip

RUN mkdir -p /opt/sonar-scanner/transformations
ADD mocha.xsl /opt/sonar-scanner/transformations/mocha.xsl
ADD newman.xsl /opt/sonar-scanner/transformations/newman.xsl
ADD ava.xsl /opt/sonar-scanner/transformations/ava.xsl

CMD ["sonar-scanner"]
