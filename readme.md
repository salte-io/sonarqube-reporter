# Overview
Produces a Docker image that can be used to convert test output produced by Istanbul, Mocha, AVA, or Newman to a SonarQube-compatible format and send it on to SonarQube for processing.

# Usage
## Gitlab Example
### .gitlab-ci.yml
```yaml
stages:
  - install
  - test
  - report

# snip

test:
  stage: test
  image: node:lts-alpine
  script:
    - cd src/application
    - npm run lint
    - npm run coverage
    - npm run report
  artifacts:
    paths:
      - .coverage/
      - .mocha_output/

report:
  stage: report
  image: salte/sonarqube-reporter:latest
  script:
    - convert -f mocha -i .mocha_output/results.xml -o .mocha_output/sonar.xml
    - sonar-scanner -Dsonar.projectKey=$CI_PROJECT_PATH_SLUG -Dsonar.sources=src/application/main -Dsonar.tests=src/application/tests -Dsonar.testExecutionReportPaths=.mocha_output/sonar.xml -Dsonar.javascript.lcov.reportPaths=.coverage/lcov.info -Dsonar.host.url=$SONARQUBE_URL -Dsonar.login=$SONARQUBE_TOKEN
```
### package.json
```json5
{
  "scripts": {
    "lint": "eslint . --ext js --ignore-path ../../.gitignore",
    "coverage": "nyc --reporter=lcov --report-dir=../../.coverage --temp-dir=../../.nyc_output mocha --recursive-tests --reporter mocha-sonar-generic-reporter --reporter-options outputFile=../../.mocha_output/results.xml",
    "report": ""
  },
  "devDependencies": {
    "eslint": "^6.8.0",
    "mocha": "^7.1.2",
    "mocha-sonar-generic-reporter": "0.0.3",
    "nyc": "15.0.1"
  }
  // snip
}
```
### Variable Reference
| Name | Description |
| ---- | ----------- |
| SONAR_SCANNER_HOME | This variable is defined within the Docker image and points to the base directory where the sonarqube scanner was installed. |
| CI_PROJECT_PATH_SLUG | This variable is defined by Gitlab itself and points to the Gitlab project namespace and name lowercased with any whitespace replaced with hyphens. This example assumes a convention where the SonarQube project key is equal to this value. |
| SONARQUBE_URL | This variable is assumed to be set in a Gitlab variable and contains the HTTPS endpoint of the SonarQube server. |
| SONARQUBE_TOKEN | This variable is assumed to be set in a Gitlab variable and contains a security token that allows the CI/CD pipeline to send test results to the specified project hosted on SonarQube. |
