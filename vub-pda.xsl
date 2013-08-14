<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:php="http://php.net/xsl"
    xmlns:xlink="http://www.w3.org/2001/XMLSchema-instance">
    <xsl:output method="xml" indent="yes" encoding="utf-8"/>

<!-- XSLT 2.0, does not work with VuFind PHP Import-Script! PHP functions are not available; use Saxon for transformation -->

	<xsl:template match="/">
	  <xsl:element name="add">
            <xsl:apply-templates/>
	  </xsl:element>
	</xsl:template>

	<xsl:template match="row">
            <doc>
                <!-- ID -->
                <field name="id">
                    <xsl:text>VUB</xsl:text><xsl:value-of select="identifier"/>
                </field>

                <!-- ISBN -->
                <xsl:if test="identifier[normalize-space()]">
                    <field name="isbn">
                        <xsl:value-of select="identifier[normalize-space()]"/>
                    </field>
                </xsl:if>

                <!-- RECORDTYPE -->
                <field name="recordtype">vub</field>

                <!-- FULLRECORD -->
                <!-- disabled for now; records are so large that they cause memory problems!
                <field name="fullrecord">
                    <xsl:copy-of select="php:function('VuFind::xmlAsText', //oai_dc:dc)"/>
                </field>
                  -->

                <!-- ALLFIELDS -->
                <!--  <field name="allfields"> -->
                <!--     <xsl:value-of select="normalize-space(string(/row))"/> -->
                <!-- </field> -->

                <!-- INSTITUTION -->
                <field name="institution">
                  <xsl:text>MPG</xsl:text>
                </field>

                <!-- COLLECTION -->
                <field name="collection">
                  <xsl:text>VUB</xsl:text>
                </field>

                <!-- LANGUAGE -->
                <xsl:if test="language">
                    <xsl:for-each select="language">
                        <xsl:if test="self::node()[text()='eng']">
                            <field name="language">English</field>
                        </xsl:if>
                        <xsl:if test="self::node()[text()='ger']">
                            <field name="language">German</field>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>

                <!-- FORMAT -->
                <field name="format">Book</field>

                <!-- AUTHOR -->
                <xsl:if test="person">
                    <xsl:for-each select="tokenize(person,';')">
                        <xsl:if test="normalize-space()">
                            <xsl:if test="position()=1">
                                <field name="author">
                                    <xsl:value-of select="normalize-space()"/>
                                </field>
                                <field name="author-letter">
                                    <xsl:value-of select="normalize-space()"/>
                                </field>
                            </xsl:if>
                            <xsl:if test="position()>1">
                                <field name="author2">
                                    <xsl:value-of select="normalize-space()"/>
                                </field>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>

                <!-- TITLE -->
                <xsl:if test="title[normalize-space()]">
                    <field name="title">
		        <xsl:value-of select="title[normalize-space()]"/>
                       <!-- <xsl:value-of select="translate(title[normalize-space()], ';', ':')"/> -->
                    </field>
                    <field name="title_short">
		        <xsl:value-of select="title[normalize-space()]"/>
                    </field>
                    <field name="title_full">
                        <xsl:value-of select="title[normalize-space()]"/>
                    </field>
                    <field name="title_sort">
                        <xsl:value-of select="title[normalize-space()]"/>
                    </field>
                    <field name="title_sub">
                        <xsl:value-of select="substring-after(title[normalize-space()],';')"/>
                    </field>

                </xsl:if>

                <!-- PUBLISHER -->
                <xsl:if test="publisher[normalize-space()]">
                    <field name="publisher">
                        <xsl:value-of select="publisher[normalize-space()]"/>
                    </field>
                </xsl:if>

                <!-- PUBLISHDATE -->
                <xsl:if test="publishingyear[normalize-space()]">
                    <field name="publishDate">
                        <xsl:value-of select="publishingyear[normalize-space()]"/>
                    </field>
                    <field name="publishDateSort">
                        <xsl:value-of select="publishingyear[normalize-space()]"/>
                    </field>
                </xsl:if>

                <!-- URL -->
                <!-- <xsl:if test="dc:identifier"> -->
                <!--     <field name="url"> -->
                <!--         <xsl:value-of select="dc:identifier[normalize-space()]"/> -->
                <!--     </field> -->
                <!-- </xsl:if> -->
		
                <!-- DESCRIPTION -->
                <xsl:if test="description[normalize-space()]">
                    <field name="description">
                        <xsl:value-of select="description[normalize-space()]"/>
                    </field>
                </xsl:if>

                <!-- PHYSICAL -->
                <xsl:if test="additionals[normalize-space()]">
                    <field name="physical">
                        <xsl:value-of select="additionals[normalize-space()]"/>
                    </field>
                </xsl:if>

                <!-- SUBJECT HEADINGS -->
                <xsl:if test="catchword">
                    <xsl:for-each select="tokenize(catchword,';')">
                        <xsl:if test="normalize-space()">
                                <field name="topic">
                                    <xsl:value-of select="normalize-space()"/>
                                </field>
                                <field name="topic_facet">
                                    <xsl:value-of select="normalize-space()"/>
                                </field>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>

            </doc>

    </xsl:template>



</xsl:stylesheet>
