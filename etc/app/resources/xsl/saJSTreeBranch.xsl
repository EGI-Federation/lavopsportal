<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sf="http://symfony.com/schema/dic/services"
                exclude-result-prefixes="sf">

    <xsl:output indent="no" omit-xml-declaration="yes" method="xml" version="1.0"/>

    <xsl:variable name="rawViewName" select="document('rawData')"/>

    <xsl:variable name="branchLabel">
        <xsl:value-of select="document('treeConf')//sf:argument[@key='label']" />
    </xsl:variable>

    <xsl:variable name="branchPrefix">
        <xsl:value-of select="document('treeConf')//sf:argument[@key='lavoisierPrefix']" />
    </xsl:variable>

    <xsl:variable name="rootBehaviour">
        <xsl:value-of select="document('treeConf')//sf:argument[@key='root_checked_behaviour']" />
    </xsl:variable>

    <xsl:variable name="rootIcon">
        <xsl:value-of select="document('treeConf')//sf:argument[@key='root_icon']" />
    </xsl:variable>


    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <html_data>
            <li rel='{$rootIcon}' id='{$branchPrefix}_all' >
                <a href='#' class="root_node" ><xsl:value-of select="$branchLabel" /></a>

                <!--  mailing-list added to root on CENTRAL instance only -->
                <xsl:choose>
                    <xsl:when test="count($rawViewName/*/NGI) &gt; 1">
                        <input type='hidden' id='input_{$branchPrefix}_all' name='jstree[{$branchPrefix}][{$rootBehaviour}]' value='{$branchPrefix}_all' disabled=''/>
                    </xsl:when>
                    <xsl:otherwise>
                        <input type='hidden' id='input_{$branchPrefix}_all' name='jstree[{$branchPrefix}][{$rootBehaviour}]' value='{$branchPrefix}_all' disabled=''/>
                    </xsl:otherwise>
                </xsl:choose>
                <ul>
                    <xsl:apply-templates select="$rawViewName/*/NGI[@name!='EGI.eu']" />
                </ul>
            </li>
        </html_data>
    </xsl:template>

    <!--  _____________ template for NGI level _________________ -->
    <xsl:template match="NGI">
        <xsl:variable name="nginame" select = "@name" />
        <xsl:if test="count(Sites/Site) &gt; 0">
            <li id='{$branchPrefix}_{$nginame}' rel='branch'>
                <a href='#'>
                    <xsl:value-of select="$nginame"/>
                </a>
                <input type='hidden' id='input_{$branchPrefix}_{$nginame}' name='jstree[{$branchPrefix}][{$nginame}][check_all]' value='{$branchPrefix}_{$nginame}' disabled='' />
                <ul>
                    <xsl:apply-templates select="Sites/Site" />
                </ul>
            </li>
        </xsl:if>
    </xsl:template>

    <!-- ______________________ template for site level ____________ -->
    <xsl:template match="Site">
        <xsl:variable name="nginame" select = "ancestor::NGI/@name" />
        <li id='{$branchPrefix}_{@primary_key}' rel='ml'>
            <a href="#">
                <xsl:value-of select="@name"/>
            </a>
            <input type='hidden' id='input_{$branchPrefix}_{@primary_key}' name='jstree[{$branchPrefix}][{$nginame}][]' value='{$branchPrefix}_{@primary_key}' disabled=''/>
        </li>
    </xsl:template>

</xsl:stylesheet>
