<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml"/>

    <xsl:template match="/">
        <disciplines>
            <xsl:apply-templates select="/appdb/version/discipline[not(@parentid)]"/>
        </disciplines>
    </xsl:template>

    <xsl:template match="discipline">
        <xsl:copy>
            <xsl:variable name="id" select="@id"/>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="/appdb/version/discipline[@parentid=$id]"/>

        </xsl:copy>

    </xsl:template>

</xsl:stylesheet>