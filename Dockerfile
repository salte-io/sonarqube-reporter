FROM openjdk:11
LABEL MAINTAINER=dave@salte.io

# Setup Environment Variables
ENV SONAR_SCANNER_HOME=/opt/sonar-scanner
ENV PATH="${SONAR_SCANNER_HOME}/bin:${PATH}"
ENV SONAR_SCANNER_OPTS="-Djavax.net.ssl.keyStore=/usr/local/openjdk-11/lib/security/cacerts -Djavax.net.ssl.trustStore=/usr/local/openjdk-11/lib/security/cacerts"

# Install SonarQube and Supporting Libraries
RUN apt update && apt install -y curl zip libsaxonb-java
RUN curl -L -o /tmp/sonar-scanner-cli.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.3.0.2102-linux.zip
RUN unzip /tmp/sonar-scanner-cli.zip -d /opt && \
    mv ${SONAR_SCANNER_HOME}* ${SONAR_SCANNER_HOME} && \
    rm /tmp/sonar-scanner-cli.zip

# Add Transformations to Image
RUN mkdir -p ${SONAR_SCANNER_HOME}/transformations
ADD xslt/mocha.xsl ${SONAR_SCANNER_HOME}/transformations/mocha.xsl
ADD xslt/newman.xsl ${SONAR_SCANNER_HOME}/transformations/newman.xsl
ADD xslt/ava.xsl ${SONAR_SCANNER_HOME}/transformations/ava.xsl

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install -y nodejs

# Add NodeJS Script
ADD package.json ${SONAR_SCANNER_HOME}/transformations/package.json
ADD convert ${SONAR_SCANNER_HOME}/transformations/convert
RUN chmod +x ${SONAR_SCANNER_HOME}/transformations/convert && \
    cd ${SONAR_SCANNER_HOME}/transformations && \
    npm install && \
    ln -s ${SONAR_SCANNER_HOME}/transformations/convert /usr/local/bin/convert

CMD ["sonar-scanner"]
