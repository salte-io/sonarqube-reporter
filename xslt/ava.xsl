<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">

  <xsl:key name="filename" match="testsuite" use="substring-before(@name, ' › ')" />
  <xsl:variable name="UC10" select="'&#xA;'"/>

  <xsl:template match="testsuites">
    <testExecutions version="1">
    <xsl:for-each select="testsuite[@name][count(. | key('filename', substring-before(@name, ' › '))[1]) = 1]">
<xsl:sort select="substring-before(@name, ' › ')" />
      <xsl:element name="file">
        <xsl:attribute name="path">
          <xsl:value-of select="concat('unit_tests/', concat(substring-before(@name, ' › '), '.test.js'))" />
        </xsl:attribute>
        <xsl:for-each select="key('filename', substring-before(@name, ' › '))">
        <xsl:sort select="substring-after(@name, ' › ')" />
          <xsl:element name="testCase">
            <xsl:attribute name="name">
              <xsl:value-of select="substring-after(@name, ' › ')" />
            </xsl:attribute>
            <xsl:attribute name="duration">0</xsl:attribute>
            <xsl:if test="testcase/failure">
              <xsl:element name="failure">
                <xsl:attribute name="message">
                  <xsl:value-of select="substring-before(substring-after(testcase/failure/text(), 'name: '), $UC10)" />
                </xsl:attribute>
                <xsl:value-of select="testcase/failure" />
              </xsl:element>
            </xsl:if>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:for-each>
    </testExecutions>
  </xsl:template>
</xsl:stylesheet>
