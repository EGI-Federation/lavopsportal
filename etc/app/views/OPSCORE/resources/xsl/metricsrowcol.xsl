<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:e="http://software.in2p3.fr/lavoisier/entries.xsd"
                xmlns:math="http://software.in2p3.fr/lavoisier/entries.xsd"
                xmlns="http://software.in2p3.fr/lavoisier/tables.xsd"
        exclude-result-prefixes="e">
    <xsl:output method="xml"/>

    <xsl:template match="/">
        <tables>

            <table>

                <column_labels>
                        <xsl:apply-templates select="e:entries/e:entries[1]/e:entry" mode="label"/>
                </column_labels>

                <xsl:apply-templates select="e:entries/e:entries"/>

                <xsl:apply-templates select="e:entries"></xsl:apply-templates>

            </table>

        </tables>
    </xsl:template>

    <xsl:template match="e:entries/e:entry" mode="label">

        <xsl:choose>
            <xsl:when test="@key='ngi' or @key='site' ">

                <column_label>
                    <xsl:attribute name="label">
                        <xsl:value-of select="@key"/>
                    </xsl:attribute>
                        <xsl:value-of select="@key"/>
                </column_label>
            </xsl:when>
            <xsl:otherwise>
                <column_label unit="number">
                    <xsl:value-of select="@key"></xsl:value-of>
                </column_label>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="e:entries/e:entries">
        <row>
            <xsl:apply-templates select="e:entry">
                <xsl:with-param name="label" select="false"></xsl:with-param>
            </xsl:apply-templates>
        </row>

    </xsl:template>

    <xsl:template match="e:entry">
        <column>
            <xsl:value-of select="text()"></xsl:value-of>
        </column>
    </xsl:template>


    <xsl:template match="e:entries">
        <row>
            <xsl:for-each select="e:entries[1]/e:entry">
                <xsl:variable name="pos" select="position()"></xsl:variable>
                <xsl:choose>
                    <xsl:when test="string(sum(/e:entries/e:entries/e:entry[position()=$pos]/text()) ) != 'NaN'">
                        <column><xsl:value-of select="sum(/e:entries/e:entries/e:entry[position()=$pos]/text()) "/></column>
                    </xsl:when>
                    <xsl:otherwise>
                        <column>Total</column>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </row>

    </xsl:template>





</xsl:stylesheet>