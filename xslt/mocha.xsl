<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />
  <xsl:template match="unitTest">
    <testExecutions version="1">
      <xsl:copy-of select="./*" />
    </testExecutions>
  </xsl:template>
</xsl:stylesheet>
