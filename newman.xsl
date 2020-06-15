<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">

  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />

  <xsl:template match="testsuites">
    <testExecutions version="1">
      <xsl:element name="file">
        <xsl:attribute name="path">
          <xsl:value-of select="@name" />
        </xsl:attribute>
        <xsl:apply-templates />
      </xsl:element>
    </testExecutions>
  </xsl:template>

  <xsl:template match="testsuite/testcase">
    <xsl:element name="testCase">
      <xsl:attribute name="name">
        <xsl:value-of select="@name" />
      </xsl:attribute>
      <xsl:attribute name="duration">
        <xsl:value-of select="@time * 1000" />
      </xsl:attribute>
      <xsl:if test="failure">
        <xsl:element name="failure">
          <xsl:attribute name="message">
            <xsl:value-of select="failure/@type" />
          </xsl:attribute>
          <xsl:value-of select="failure" />
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
