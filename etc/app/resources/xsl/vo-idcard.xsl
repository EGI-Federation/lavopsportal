<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
    <xsl:output indent="yes" xmlns:e="http://software.in2p3.fr/lavoisier/entries.xsd" omit-xml-declaration="yes" method="xml" version="1.0" cdata-section-elements="AUP Description OtherRequirements" />



    <xsl:variable select="document('voms-certificates')"   name="voms-certificates" />
    <xsl:variable select="document('cic_dump')"   name="cic_dump" />
    <xsl:variable select="document('VoDisciplinesList')" name="VoDisciplinesList" />

    <!-- ____________________ Main template ___________________________________ -->


    <xsl:template match="/">
        <root current="v2">

            <xsl:apply-templates select="/data/Vo/data"/>
        </root>
    </xsl:template>


   <!-- ________________________ IDCard level ________________________________  -->

    <xsl:template match="data">

        <xsl:param name="VONAME1" select="Vo/VoHeader/name"></xsl:param>
         <IDCard>
             <xsl:choose>
                 <xsl:when test="$cic_dump/VOs/VO[@Name=$VONAME1]/@ID">
                     <xsl:attribute name="CIC_ID">
                         <xsl:value-of select="$cic_dump/VOs/VO[@Name=$VONAME1]/@ID"/>
                     </xsl:attribute>
                 </xsl:when>
                 <xsl:otherwise>

                     <xsl:attribute name="CIC_ID">
                         <xsl:value-of select="Vo/VoHeader/@serial + 10000"/>
                     </xsl:attribute>
                 </xsl:otherwise>
             </xsl:choose>


             <xsl:attribute name="Name">
                <xsl:value-of select="Vo/VoHeader/name"/>
            </xsl:attribute>
            <xsl:attribute name="Serial">
                <xsl:value-of select="Vo/VoHeader/@serial"/>
            </xsl:attribute>
            <xsl:attribute name="Status">
                <xsl:value-of select="Vo/VoHeader/VoStatus/status"/>
            </xsl:attribute>
            <xsl:attribute name="Alias">
                <xsl:value-of select="Vo/VoHeader/alias"/>
            </xsl:attribute>
            <xsl:attribute name="GridId">
                <xsl:value-of select="Vo/VoHeader/gridid"/>
            </xsl:attribute>
            <ValidationDate>
				<xsl:attribute name='TimeZone'>UTC</xsl:attribute>
                <xsl:value-of  select="Vo/validationdate"/>
            </ValidationDate>
			<LastChange>
				<xsl:attribute name='TimeZone'>UTC</xsl:attribute>
				<xsl:value-of  select="Vo/lastchange"/>
            </LastChange>
            <Scope>
                <xsl:value-of  select="Vo/VoHeader/VoScope/scope"/>
            </Scope>
            <SupportProcedure>
                <xsl:value-of  select="Vo/VoHeader/supportprocedureurl"/>
            </SupportProcedure>
            <Discipline>
                <xsl:value-of  select="Vo/VoHeader/VoDiscipline/discipline"/>
            </Discipline>
            <EnrollmentUrl>
                <xsl:value-of  select="Vo/VoHeader/enrollmenturl"/>
            </EnrollmentUrl>
            <HomepageUrl>
                <xsl:value-of  select="Vo/VoHeader/homepageurl"/>
            </HomepageUrl>
            <AUP>
				<xsl:attribute name='type'>
                  <xsl:value-of select='Vo/VoHeader/auptype/text()'/>
                </xsl:attribute>
				<xsl:value-of  select="Vo/VoHeader/aup"/>
            </AUP>
            <Description>
				<xsl:value-of  select="Vo/VoHeader/description"/>
            </Description>
             <!--
            <Middlewares>
                <xsl:attribute name="ARC">
                    <xsl:value-of select="Vo/VoHeader/@arc_supported"/>
                </xsl:attribute>
                <xsl:attribute name="gLite">
                    <xsl:value-of select="Vo/VoHeader/@glite_supported"/>
                </xsl:attribute>
                <xsl:attribute name="UNICORE">
                    <xsl:value-of select="Vo/VoHeader/@unicore_supported"/>
                </xsl:attribute>
                <xsl:attribute name="GLOBUS">
                    <xsl:value-of select="Vo/VoHeader/@globus_supported"/>
                </xsl:attribute>
                <xsl:attribute name="CLOUD_STORAGE">
                    <xsl:value-of select="Vo/VoHeader/@cloud_storage_supported"/>
                </xsl:attribute>
                <xsl:attribute name="CLOUD_COMPUTING">
                    <xsl:value-of select="Vo/VoHeader/@cloud_computing_supported"/>
                </xsl:attribute>
           </Middlewares>-->
            <gLiteConf>
		<FQANs>
                   <xsl:apply-templates select="DoctrineCollection/VoVomsGroup"/>
                </FQANs>
              <!--
                <CoreServices></CoreServices>
                <BlackList><Sites></Sites><Services></Services></BlackList>
                <WhiteList><Sites></Sites><Services></Services></WhiteList>
              -->
                <VOMSServers>
                    <xsl:apply-templates select="DoctrineCollection/VoVomsServer"/>
                </VOMSServers>
            </gLiteConf>

            <Contacts>
                <MailingList>
                    <xsl:apply-templates select="DoctrineCollection/VoMailingList"/>
                </MailingList>
                <Individuals>
                    <xsl:apply-templates select="DoctrineCollection/VoContactHasProfile/VoContacts"/>
                </Individuals>
            </Contacts>

             <Disciplines>
                 <xsl:copy-of  select="$VoDisciplinesList/rootD/vo_Disciplines[@name=$VONAME1]/vo_Disciplines/*"/>
             </Disciplines>




             <xsl:apply-templates select="DoctrineCollection/VoRessources"/>
	 </IDCard>
    </xsl:template>

   
    <!-- ***************************************************************************************************************************************
            Contact template
            @todo :
                - Phone is missing in database
                - check Name format
                - deleteTimeStamp and pendingEmail are not in database too
                - must we add the whole list or the Vo manager contact only ??
                - xml schema seems not matching p28 official doc, p28 taken as reference
    ******************************************************************************************************************************************** -->
    <xsl:template match ="data/DoctrineCollection/VoContactHasProfile/VoContacts">
        <Contact>
            <Name>
                <xsl:value-of select="firstname"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="lastname"/>
            </Name>
		<Role>
		<xsl:value-of select="ancestor::VoContactHasProfile/VoUserProfile/profile"/>
		</Role>	
            <Email>
                <xsl:value-of select="email"/>
            </Email>
		<DN>
			<xsl:value-of select="dn"/>
		</DN>
            <Phone>
                <xsl:value-of select="phone"/>
            </Phone>
        </Contact>
    </xsl:template>

        <!-- ********************** NEW DISCIPLINS CLASSIFICATION **************** -->
        <xsl:template match ="data/DoctrineCollection/Disciplines ">
	                <Discipline><xsl:attribute name="id">
                        <xsl:value-of select="@discipline_id"/></xsl:attribute><xsl:value-of select="disciplinelabel/text()"/></Discipline>
        </xsl:template>


    <!-- ***************************************************************************************************************************************
            Mailing list template
     ******************************************************************************************************************************************** -->
    <xsl:template match ="data/DoctrineCollection/VoMailingList ">
        <Admins>
            <xsl:value-of select="adminsmailinglist"/>
        </Admins>
        <Operations>
            <xsl:value-of select="operationsmailinglist"/>
        </Operations>
        <UserSupport>
            <xsl:value-of select="usersupportmailinglist"/>
        </UserSupport>
        <Users>
            <xsl:value-of select="usersmailinglist"/>
        </Users>
        <Security>
            <xsl:value-of select="securitycontactmailinglist"/>
        </Security>
    </xsl:template>

    <!-- ***************************************************************************************************************************************
            Ressources template
            @todo :
                - check if matching is ok
     ******************************************************************************************************************************************** -->
    <xsl:template match ="data/DoctrineCollection/VoRessources">
        <Ressources>
            <QueueConfiguration>
                <JobMaxCPUTime>
                    <xsl:value-of select="@job_max_cpu"/>
                </JobMaxCPUTime>
                <JobMaxWallClockTime>
                    <xsl:value-of select="@job_max_wall"/>
                </JobMaxWallClockTime>

            </QueueConfiguration>
           <SingleCoreJobs>
               <RAM_per_i386_Core>
                   <xsl:value-of select="@ram386"/>
               </RAM_per_i386_Core>
               <RAM_per_x86_64_Core>
                   <xsl:value-of select="@ram64"/>
               </RAM_per_x86_64_Core>
               <JobScratchSpace>
                   <xsl:value-of select="@job_scratch_space"/>
               </JobScratchSpace>
           </SingleCoreJobs>
            <MultiCoreJobs>
                <RamValuesPerJob>
                    <min><xsl:value-of select="@minimum_ram"/></min>
                    <prefered><xsl:value-of select="@pref_ram"/></prefered>
                    <max><xsl:value-of select="@maxi_ram"/></max>
                </RamValuesPerJob>
                <ScratchValuesPerJob>
                    <min><xsl:value-of select="@min_scratch_space_values"/></min>
                    <prefered><xsl:value-of select="@pref_scratch_space_values"/></prefered>
                    <max><xsl:value-of select="@max_scratch_space_values"/></max>
                </ScratchValuesPerJob>
                <CoresValuesPerJob>
                    <min><xsl:value-of select="@min_number_cores"/></min>
                    <prefered><xsl:value-of select="@pref_number_cores"/></prefered>
                    <max><xsl:value-of select="@max_number_cores"/></max>
                </CoresValuesPerJob>
            </MultiCoreJobs>
            <CloudCompute>
                <CloudCPUCore><xsl:value-of select="@cloud_cpu_core"/></CloudCPUCore>
                <CloudStorageSize><xsl:value-of select="@cloud_storage_size"/></CloudStorageSize>
                <CloudVmRam><xsl:value-of select="@cloud_vm_ram"/></CloudVmRam>
            </CloudCompute>
            <CernCVMFS>
                <endpoints><xsl:value-of select="@cvmfs"/></endpoints>
            </CernCVMFS>
            <OtherRequirements>
				<xsl:value-of select="otherrequirements"/>
            </OtherRequirements>
        </Ressources>
    </xsl:template>

     <!-- ***************************************************************************************************************************************
            VomsServer template
            @todo :
     ******************************************************************************************************************************************** -->
    <xsl:template match ="data/DoctrineCollection/VoVomsServer">
        <xsl:choose>
            <xsl:when test="contains(hostname,'perun')">
                <Perun>
                    <xsl:attribute name="MembersListUrl">
                        <xsl:value-of select="memberslisturl"/>
                    </xsl:attribute>

                </Perun>
            </xsl:when>
            <xsl:when test="contains(hostname,'checkin')">
                <Comanage>
                    <xsl:attribute name="MembersListUrl">
                        <xsl:value-of select="concat(memberslisturl,id_comanage)"/>
                    </xsl:attribute>

                </Comanage>
            </xsl:when>
            <xsl:when test="contains(hostname,'aai.egi.eu')">
                <Comanage>
                    <xsl:attribute name="MembersListUrl">
                        <xsl:value-of select="concat(memberslisturl,id_comanage)"/>
                    </xsl:attribute>

                </Comanage>
            </xsl:when>
            <xsl:otherwise>
                <VOMS_Server>
                    <xsl:attribute name="HttpsPort">
                        <xsl:value-of select="@https_port"/>
                    </xsl:attribute>
                    <xsl:attribute name="VomsesPort">
                        <xsl:value-of select="@vomses_port"/>
                    </xsl:attribute>

                    <xsl:attribute name="IsVomsAdminServer">
                        <xsl:value-of select="@is_vomsadmin_server"/>
                    </xsl:attribute>

                    <xsl:attribute name="MembersListUrl">
                        <xsl:value-of select="memberslisturl"/>
                    </xsl:attribute>

                    <xsl:param name="hostname" select="hostname"/>
                    <hostname>
                        <xsl:value-of select="$hostname"/>
                    </hostname>

                    <xsl:apply-templates select="$voms-certificates/*/X509Cert[@host=$hostname][1]" />

                </VOMS_Server>

            </xsl:otherwise>
        </xsl:choose>




    </xsl:template>
   
     <!-- ***************************************************************************************************************************************************
           VOMS cert data aggregation
    ***************************************************************************************************************************************************** -->
   <xsl:template match="X509Cert">
      <X509Cert>
       <xsl:copy-of select="*"/>
     </X509Cert>
   </xsl:template>


    <!-- ***************************************************************************************************************************************************
           VomsGroup template (FQANs)
           @todo : - check pb insert date
    ***************************************************************************************************************************************************** -->
    <xsl:template match="data/DoctrineCollection/VoVomsGroup">
        <FQAN>
            <xsl:attribute name="IsGroupUsed">
                 <xsl:value-of select="@is_group_used"/>
            </xsl:attribute>
            <xsl:attribute name="GroupType"> 
               <xsl:value-of select="grouptype"/>
            </xsl:attribute>
            <FqanExpr>
          	<xsl:value-of select="grouprole" />
            </FqanExpr> 
            <Description> 
                 <xsl:value-of select="description"/>
            </Description>
            <ComputingShare>
                 <xsl:value-of select="@allocated_ressources"/>
            </ComputingShare>
        </FQAN>
    </xsl:template>

</xsl:stylesheet>	

