<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sf="http://symfony.com/schema/dic/services"         exclude-result-prefixes="sf">
    <xsl:variable name="branchPrefix">
        <xsl:value-of select="document('treeConf')//sf:argument[@key='lavoisierPrefix']" />
    </xsl:variable>

    <xsl:variable name="branchLabel">
        <xsl:value-of select="document('treeConf')//sf:argument[@key='label']" />
    </xsl:variable>

    <xsl:variable name="rootBehaviour">
        <xsl:value-of select="document('treeConf')//sf:argument[@key='root_checked_behaviour']" />
    </xsl:variable>

    <xsl:variable name="rootIcon">
        <xsl:value-of select="document('treeConf')//sf:argument[@key='root_icon']" />
    </xsl:variable>

    <xsl:param name="user_dn"/>

    <xsl:param name="rawViewName" select="'rawData'" />

    <xsl:template match="/">
        <html_data>
            <li id="{$branchPrefix}_all" rel="{$rootIcon}">

                <xsl:choose>
                    <xsl:when test="$rootBehaviour = 'disabled_root'">
                        <span rel="root" class="root_node"><xsl:value-of select="$branchLabel" /></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <a class="root_node" href="#"><xsl:value-of select="$branchLabel" /></a>
                    </xsl:otherwise>
                </xsl:choose>

                <input type="hidden" name="jstree[{$branchPrefix}][{$rootBehaviour}]" value="{$branchPrefix}_all" id="input_{$branchPrefix}_all" disabled="" />
                <ul>
                    <xsl:apply-templates select="document(concat($rawViewName, $user_dn))/Recipients/Recipient"/>
                </ul>
            </li>
        </html_data>
    </xsl:template>

    <xsl:template match="Recipient">
        <li id="{$branchPrefix}_{id}" rel="ml">
            <a href="#"><xsl:value-of select="label"/></a>
            <input type="hidden" name="jstree[{$branchPrefix}][]" value="{$branchPrefix}_{id}" id="input_{$branchPrefix}_{id}" disabled="" />
        </li>
    </xsl:template>

</xsl:stylesheet>
