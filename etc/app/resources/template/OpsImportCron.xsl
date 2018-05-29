<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:lav="http://software.in2p3.fr/lavoisier/config.xsd"
                xmlns="http://software.in2p3.fr/lavoisier/application.xsd">
    <!-- This template creates a map of the database foreign keys -->
    <xsl:template match="lav:view-template[contains(@stylesheet,'OpsImportCron.xsl')]">
        <xsl:variable name="url" select="lav:parameter[@name='base_url']/text()"/>
        <xsl:variable name="cid" select="lav:parameter[@name='collection']/text()"/>
        <xsl:variable name="time" select="lav:parameter[@name='cache_time']/text()"/>
        <view>
            <xsl:copy-of select="@*[not(local-name()='stylesheet')]"/>
            <namespace prefix="e" uri="http://software.in2p3.fr/lavoisier/entries.xsd"/>
            <xsl:copy-of select="lav:*[not(self::lav:parameter)]"/>
            <connector type="HTTPConnector">
                <parameter name="certificate" eval="property('certificate.path')"/>
                <parameter name="passphrase" eval="property('certificate.password')"/>
                <parameter name="url" eval="concat(property('{$url}'),
                        '/importXMLIssues?cid=',
                        '{$cid}')">
                </parameter>
                <parameter name="force-redirect">true</parameter>
            </connector>

            <cache type="FileCache">
                <trigger type="ViewNotifiedTrigger"/>
                <trigger type="DeltaTimeTrigger">
                    <parameter name="minutes">
                        <xsl:value-of select="$time"/>
                    </parameter>
                </trigger>
            </cache>
            <pre-renderers>
                <title>concat('XII import of ', /XIImport/@cid)</title>
                <field label="module">/XIImport/@module</field>
                <field label="data view">/XIImport/@view</field>
                <field label="generation date ">/XIImport/@gdate</field>
                <field label="logs">/XIImport/@logs</field>
                <row foreach="/XIImport/Counters">
                    <column label="RaisedBrowsed">concat(RaisedBrowsed, ' ( ',Timers/@raised, ' s )')</column>
                    <column>DateUpdated</column>
                    <column>NewInserted</column>
                    <column>ChangedInserted</column>
                    <column label="Recoveries">concat(Recoveries, ' ( ',Timers/@recovery, ' s )')</column>
                    <column label="Missing">concat(Missing, ' (',Timers/@missing, ' s)')</column>
                </row>
            </pre-renderers>
        </view>
    </xsl:template>
</xsl:stylesheet>