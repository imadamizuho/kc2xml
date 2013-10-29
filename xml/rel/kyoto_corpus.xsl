<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:output method="html" indent="yes"/>
    <xsl:template match="/document">
        <html>
            <head>
                <meta http-equiv="Content-Style-Type" content="text/css"/>
                <style type="text/css">
                    th {vertical-align: top;}
                    span {vertical-align: bottom;}
                    .chunk {border-bottom: 3px solid red; margin: 0px 2px 1px 0px; display: inline-block; border-radius: 3px;}
                    .chunk sub {font-weight: bold; font-size: xx-small; color: red;}
                    .tag {border-bottom: 3px solid green; margin: 0px 2px 1px 0px; display: inline-block; border-radius: 3px;}
                    .tag sub {font-weight: bold; font-size: xx-small; color: green;}
                    .tok {border-bottom: 3px solid blue; margin: 0px 2px 1px 0px; display: inline-block; border-radius: 3px;}
                    .tok sub {font-weight: bold; font-size: xx-small; color: blue;}
                    <!--
                    .chunk {border-bottom: 4px solid red; margin: 0px 1px 1px 0px; display: inline-block;}
                    .chunk sub {font-weight: bold; font-size: xx-small; color: red;}
                    .tag {border-bottom: 4px solid green; margin: 0px 1px 1px 0px; display: inline-block;}
                    .tag sub {font-weight: bold; font-size: xx-small; color: green;}
                    .tok {margin: 0px 4px 2px 0px; display: inline-block; box-shadow: 1px 1px 1px 1px; border-radius: 5px;}
                    .tok sub {font-weight: bold; font-size: xx-small; color: blue;}
                     -->
                </style>
            </head>
            <body>
                <table>
                    <xsl:apply-templates select="sentence"/>
                </table>               
            </body>
        </html>
    </xsl:template>
    <xsl:template match="sentence">
        <tr>
            <th><xsl:value-of select="@S-ID"/></th>
            <td><span><xsl:apply-templates select="chunk"/></span></td>
        </tr>
    </xsl:template>
    <xsl:template match="chunk">
        <span class="chunk">
            <xsl:apply-templates select="tag"/>
            <sub>
                <xsl:attribute name="title">
                    <xsl:value-of select="@link"/>
                    <xsl:value-of select="@rel"/>
                </xsl:attribute>
                <xsl:value-of select="@id"/>
            </sub>
        </span>
    </xsl:template>
    <xsl:template match="tag">
        <span class="tag">
            <xsl:apply-templates select="tok"/>
            <sub>
                <xsl:attribute name="title">
                    <xsl:value-of select="@link"/>
                    <xsl:value-of select="@rel"/>
                </xsl:attribute>
                <xsl:value-of select="@id"/>
            </sub>
        </span>
    </xsl:template>
    <xsl:template match="tok">
        <span class="tok">
            <xsl:attribute name="title">
                <xsl:value-of select="@base"/><xsl:text>&#10;</xsl:text>
                <xsl:value-of select="@read"/><xsl:text>&#10;</xsl:text>
                <xsl:value-of select="@pos"/><xsl:text>&#10;</xsl:text>
                <xsl:value-of select="@ctype"/><xsl:text>&#10;</xsl:text>
                <xsl:value-of select="@cform"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
</xsl:stylesheet>