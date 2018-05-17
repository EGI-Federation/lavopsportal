<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"

                exclude-result-prefixes="e">
    <xsl:output method="xml"/>

    <xsl:variable name="get_user" select="document('get_user')"/>

    <xsl:variable name="csi_csirt-team"  select="document('csi_csirt-team')" />


    <xsl:variable name="voms-team-users" select="document('voms-team-users')"/>





    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <root>

    <!-- manage EGEE_USERS from get_user view -->
    <xsl:apply-templates select="$get_user/results"/>
    <!-- copy all CSIRT members only in csi_csirt-team view -->
    <xsl:apply-templates select="$csi_csirt-team/CSIRTTeam/Users/EGEE_USER[not(CERTDN=$get_user/results/EGEE_USER/CERTDN)]" mode="add"/>
    <!-- Add voms team group members -->
    <xsl:apply-templates select="$voms-team-users/VOMSTEAMUSERS/USERS" mode="add"/>
    </root>
        </xsl:template>

        <!-- __________________________________________________________

             copy all CSIRT members only in csi_csirt-teeam view
        _______________________________________________________________ -->

<xsl:template match="Users/EGEE_USER" mode="add">
<xsl:variable name="current_dn" select="CERTDN"/>
<xsl:copy-of select="."/>
</xsl:template>

        <!-- __________________________________________________________

          copy VOMS team group users
     _______________________________________________________________ -->


<xsl:template match="VOMSTEAMUSERS/USERS/EGEE_USER" mode="add">
<xsl:variable name="current_dn" select="CERTDN"/>
<xsl:copy-of select="."/>
</xsl:template>

        <!-- __________________________________________________________

             copy  EGEE_USER from get_user view, exept CSIRT role
        _______________________________________________________________ -->


<xsl:template match="results/EGEE_USER">
<xsl:element name="{name()}">
    <xsl:copy-of select="@*"/>
    <xsl:copy-of select="CERTDN"/>
    <CN><xsl:value-of select="concat(FORENAME,' ',SURNAME)"/></CN>
    <xsl:copy-of select="EMAIL"/>
    <xsl:variable name="egee_user_dn" select="CERTDN" />
    <xsl:apply-templates select="$csi_csirt-team/CSIRTTeam/Users/EGEE_USER[CERTDN=$egee_user_dn]" mode="merge"/>
    <xsl:copy-of select="USER_ROLE[not((USER_ROLE='Security Officer') and (ON_ENTITY='EGI') and (ENTITY_TYPE='group'))]"/>
</xsl:element>
</xsl:template>

        <!-- __________________________________________________________

             merge data from CSIRT view
        _______________________________________________________________ -->


<xsl:template match="Users/EGEE_USER" mode="merge">

<CSIRT_EMAIL><xsl:value-of select="EMAIL"/></CSIRT_EMAIL>
<xsl:copy-of select="USER_ROLE"/>
</xsl:template>

        <!-- __________________________________________________________

              merge data from VOMS TEAM view
         _______________________________________________________________ -->

<xsl:template match="VOMSTEAMUSERS/USERS/EGEE_USER" mode="merge">
<xsl:copy-of select="USER_ROLE"/>
</xsl:template>

        </xsl:stylesheet>