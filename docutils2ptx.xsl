<?xml version='1.0'?>

<!--
    Transform docutuls xml to PreTeXt
    This stylesheet is meant to translate individual subchapters of a RST Runesotone book
    The main index.rst file can easily be done by hand.
    There is a separate script to transform each of the chapter based toctree.rst files.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:str="http://exslt.org/strings" extension-element-prefixes="str" version="1.0" encoding="utf8">
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes" />

    <!-- use a string param for the filename  if filename is Exercises then top level should be exercises not section
    The xml:id for the section should be changed to use the folder name (lowercased) -->

    <xsl:param name="filename" select="''" />
    <xsl:param name="folder" select="''" />

    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="document">
        <xsl:apply-templates select="node()" />
    </xsl:template>


    <xsl:template match="section">
        <xsl:variable name="division">
            <xsl:variable name="depth" select="count(ancestor::section)" />
            <xsl:choose>
                <xsl:when test="$depth = 0 and $filename = 'Exercises.xml'">
                    <xsl:text>exercises</xsl:text>
                </xsl:when>
                <!-- <xsl:when test="$depth = 0 and $filename = 'Glossary.xml'">
                    <xsl:text>glossary</xsl:text>
                </xsl:when> -->
                <xsl:when test="$depth = 0">
                    <xsl:text>section</xsl:text>
                </xsl:when>
                <xsl:when test="$depth = 1">
                    <xsl:text>subsection</xsl:text>
                </xsl:when>
                <xsl:when test="$depth = 2">
                    <xsl:text>subsubsection</xsl:text>
                </xsl:when>
                <xsl:when test="$depth = 3">
                    <xsl:text>paragraphs</xsl:text>
                </xsl:when>
                <xsl:when test="$depth = 4">
                    <xsl:text>paragraphs</xsl:text>
                </xsl:when>
                <xsl:when test="$depth = 5">
                    <xsl:text>paragraphs</xsl:text>
                </xsl:when>
                <xsl:when test="$depth = 6">
                    <xsl:text>paragraphs</xsl:text>
                </xsl:when>
                <xsl:when test="$depth = 7">
                    <xsl:text>paragraphs</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>Division depth too deep</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$division}">
            <!-- todo: add title -->
            <xsl:apply-templates select="node()|@ids" />
        </xsl:element>
    </xsl:template>

    <xsl:template match="figure">
        <figure>
            <xsl:attribute name="align">
                <xsl:value-of select="@align" />
            </xsl:attribute>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="@ids" />
            </xsl:attribute>
            <xsl:copy-of select="caption" />
            <!-- <image>
                <xsl:attribute name="source">
                    <xsl:value-of select="image/@uri" />
                </xsl:attribute>
            </image> -->
            <xsl:apply-templates select="image" />

            <!-- <xsl:copy-of select="*[not(self::image) and not(self::caption)]" /> -->
            <xsl:apply-templates select="*[not(self::image) and not(self::caption)]" />
        </figure>
    </xsl:template>


    <xsl:template match="@ids">
        <xsl:attribute name="xml:id">
            <xsl:choose>
                <xsl:when test=". = 'proof-content'">
                    <xsl:value-of select="generate-id()" />
                </xsl:when>
                <xsl:when test="starts-with(.,'id')">
                    <xsl:value-of select="generate-id()" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="." />
                </xsl:otherwise>
            </xsl:choose>

        </xsl:attribute>
    </xsl:template>

    <!-- <xsl:template match="@enumtype">
    <xsl:attribute name="label">
        <xsl:value-of select="."/>
    </xsl:attribute>
</xsl:template> -->
    <xsl:template match="admonition">
        <note>
            <xsl:apply-templates select="node()|@ids" />
        </note>
    </xsl:template>
    <xsl:template match="example_node">
        <figure>
            <xsl:apply-templates select="node()|@ids" />
        </figure>
    </xsl:template>
    <xsl:template match="definition_node">
        <definition>
            <xsl:apply-templates select="node()[self::title]|@ids" />
            <statement>
                <xsl:apply-templates select="node()/*[not(self::title)]|@classes" />
            </statement>
        </definition>
    </xsl:template>
    <xsl:template match="math">
        <m>
            <xsl:apply-templates select="node()|@ids" />
        </m>
    </xsl:template>

    <xsl:template match="img">
        <image>
            <xsl:attribute name="source">
                <xsl:value-of select="@src"/>
            </xsl:attribute>
            <xsl:attribute name="width">
                <xsl:text>50%</xsl:text>
            </xsl:attribute>
            <description>
                <p>
                    <xsl:value-of select="@alt"/>
                </p>
            </description>
        </image>
    </xsl:template>

    <xsl:template match="caution">
        <warning>
            <xsl:apply-templates select="node()|@ids" />
        </warning>
    </xsl:template>

    <xsl:template match="tip">
        <note>
            <xsl:apply-templates select="node()|@ids" />
        </note>
    </xsl:template>

    <xsl:template match="image">
        <image>
            <xsl:attribute name="source">
                <xsl:value-of select="@uri" />
                <!-- concat('images/', @uri) -->
            </xsl:attribute>
            <xsl:if test="@width">
                <xsl:attribute name="width">
                    <xsl:value-of select="concat(@width, '%')" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="not(@width)">
                <xsl:attribute name="width">
                    <xsl:text>50%</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="@alt|@height" />
        </image>
    </xsl:template>


    <xsl:template match="paragraph">
        <p>
            <xsl:apply-templates select="node()|@*" />
        </p>
    </xsl:template>

    <xsl:template match="emphasis">
        <em>
            <xsl:apply-templates select="node()|@*" />
        </em>
    </xsl:template>

    <xsl:template match="strong">
        <term>
            <xsl:apply-templates select="node()|@*" />
        </term>
    </xsl:template>

    <xsl:template match="literal">
        <c>
            <xsl:apply-templates select="node()|@*" />
        </c>
    </xsl:template>

    <xsl:template match="bullet_list">
        <p>
            <ul>
                <xsl:apply-templates select="node()" />
            </ul>
        </p>
    </xsl:template>

    <xsl:template match="enumerated_list">
        <p>
            <ol>
                <xsl:attribute name="label">
                    <xsl:variable name="kind" select="@enumtype" />
                    <xsl:choose>
                        <xsl:when test="$kind = 'arabic'">
                            <xsl:text>1</xsl:text>
                        </xsl:when>
                        <xsl:when test="$kind = 'loweralpha'">
                            <xsl:text>a</xsl:text>
                        </xsl:when>
                        <xsl:when test="$kind = 'upperalpha'">
                            <xsl:text>A</xsl:text>
                        </xsl:when>
                        <xsl:when test="$kind = 'lowerroman'">
                            <xsl:text>i</xsl:text>
                        </xsl:when>
                        <xsl:when test="$kind = 'upperroman'">
                            <xsl:text>I</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>A</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:apply-templates select="node()" />
            </ol>
        </p>
    </xsl:template>

    <xsl:template match="list_item">
        <li>
            <xsl:apply-templates select="node()|@*" />
        </li>
    </xsl:template>

    <xsl:template match="table">
        <table>
            <xsl:apply-templates select="@ids" />
            <tabular>
                <xsl:apply-templates select="node()" />
            </tabular>
        </table>
    </xsl:template>

    <xsl:template match="tgroup">
        <xsl:apply-templates select="node()|@ids" />
    </xsl:template>

    <!-- Delete colspecs-->
    <xsl:template match="colspec" />

    <xsl:template match="thead|tbody">
        <xsl:apply-templates select="node()|@ids" />
    </xsl:template>

    <xsl:template match="thead/row">
        <row header="yes">
            <xsl:apply-templates select="node()|@ids" />
        </row>
    </xsl:template>

    <xsl:template match="tbody/row">
        <row>
            <xsl:apply-templates select="node()|@ids" />
        </row>
    </xsl:template>

    <xsl:template match="entry">
        <cell>
            <xsl:apply-templates select="node()|@ids" />
        </cell>
    </xsl:template>

    <xsl:template match="entry/paragraph">
        <xsl:apply-templates select="node()" />
    </xsl:template>


    <xsl:template match="literal_block[@language='default']">
        <pre>
            <xsl:apply-templates select="node()" />
        </pre>
    </xsl:template>


    <xsl:template match="literal_block">
        <program>
            <xsl:attribute name="language">
                <xsl:value-of select="@language" />
            </xsl:attribute>
            <input>
                <xsl:text>&#xa;</xsl:text>
                <xsl:apply-templates select="node()" />
                <xsl:text>&#xa;</xsl:text>
            </input>
        </program>
    </xsl:template>

    <xsl:template match="block_quote">
        <blockquote>
            <xsl:apply-templates select="node()" />
        </blockquote>
    </xsl:template>

    <xsl:template match="comment">
    </xsl:template>

    <!-- ignore the inline element that contains the content (link title) -->
    <xsl:template match="reference[@internal='True']">
        <xref>
            <xsl:attribute name='ref'>
                <xsl:value-of select="@refid|@refuri" />
            </xsl:attribute>
        </xref>
    </xsl:template>

    <xsl:template match="reference[not(@internal)]">
        <url>
            <xsl:attribute name='href'>
                <xsl:value-of select="@refuri" />
            </xsl:attribute>
            <xsl:attribute name='visual'>
                <xsl:value-of select="@refuri" />
            </xsl:attribute>
            <!-- Don't copy refuri or name attributes-->
            <xsl:apply-templates select="node()" />
        </url>
    </xsl:template>


    <xsl:template match="glossary/definition_list">
        <xsl:apply-templates select="node()" mode="glossary" />
    </xsl:template>

    <xsl:template match="definition_list_item" mode="glossary">
        <gi>
            <xsl:apply-templates select="node()" />
        </gi>
    </xsl:template>

    <xsl:template match="term" mode="glossary">
        <title>
            <xsl:apply-templates select="node()" />
        </title>
    </xsl:template>
    <xsl:template match="title">

        <xsl:variable name="title">
            <xsl:variable name="tag" select="name(..)" />
            <xsl:choose>
                <xsl:when test="$tag = 'example_node'">
                    <xsl:text>caption</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>title</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$title}">
            <!-- todo: add title -->
            <xsl:apply-templates select="node()|@ids" />
        </xsl:element>
    </xsl:template>

    <xsl:template match="definition" mode="glossary">
        <xsl:apply-templates select="node()" />
    </xsl:template>

    <xsl:template match="definition_list">
        <dl>
            <xsl:apply-templates select="node()" />
        </dl>
    </xsl:template>

    <xsl:template match="definition_list_item">
        <li>
            <xsl:apply-templates select="node()" />
        </li>
    </xsl:template>

    <xsl:template match="term">
        <title>
            <xsl:apply-templates select="node()" />
        </title>
    </xsl:template>

    <xsl:template match="definition">
        <xsl:apply-templates select="node()" />
    </xsl:template>

    <!-- target was a sibling of reference that we want to ignore -->
    <xsl:template match="target">
        <xsl:message>Ignored Target</xsl:message>
        <xsl:text>[TARGET]</xsl:text>
    </xsl:template>

    <xsl:template match="compound[contains(@classes, 'toctree-wrapper')]">
        <tocToBeReplaced/>
    </xsl:template>

    <xsl:template match="compound">
        <xsl:message>Ignoring Compound for now</xsl:message>
        <xsl:text>[UNKNOWN COMPOUND]</xsl:text>
    </xsl:template>

    <xsl:template match="substitution_definition"></xsl:template>

    <xsl:template match="index"></xsl:template>

    <xsl:template match="target"></xsl:template>

    <!-- PreTeXt does not have tabbed grouping like Runestone, but they have better ways to break up questions
-->
    <xsl:template match="TabbedStuffNode">
        <xsl:variable name="exid">
            <xsl:value-of select="child::exercise[@xml:id]" />
        </xsl:variable>
        <exercise>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="child::*/exercise/@xml:id" />
            </xsl:attribute>
            <xsl:apply-templates select="TabNode" />
        </exercise>
    </xsl:template>

    <xsl:template match='TabNode[@tabname="Question"]'>
        <statement>
            <xsl:apply-templates select="exercise/statement/node()" />
            <!-- <xsl:apply-templates select="exercise/node()[not(self::statement)]" /> -->
            <!-- <xsl:apply-templates select="paragraph/node()[not(self::statement)]" mode="nonex" /> -->
        </statement>
        <program>
            <xsl:attribute name="interactive">
                <xsl:value-of select="*/program/@interactive" />
            </xsl:attribute>
            <xsl:attribute name="language">
                <xsl:value-of select="*/program/@language" />
            </xsl:attribute>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="*/program/@xml:id" />
            </xsl:attribute>
            <xsl:apply-templates select="exercise/program/node()" />
        </program>
    </xsl:template>

    <xsl:template match="paragraph" mode="nonex">
        <p>
            <xsl:apply-templates select="node()" />
        </p>
    </xsl:template>

    <!-- <xsl:template match='TabNode[@tabname="Answer"]/listing'>
        <solution>
            <xsl:apply-templates select="node()" mode="solution"/>
        </solution>
    </xsl:template> -->

    <xsl:template match='TabNode[@tabname="Answer"]'>
        <solution>
            <xsl:apply-templates select="node()" mode="solution" />
            <xsl:apply-templates select="node()[not(self::program)]" />
        </solution>
    </xsl:template>

    <xsl:template match='listing' mode="solution">
        <xsl:apply-templates select="node()" mode="solution" />
    </xsl:template>

    <xsl:template match='program' mode="solution">
        <program>
            <xsl:apply-templates select="@interactive" mode="solution" />
            <xsl:apply-templates select="node()|@xml:id|@language" />
        </program>
    </xsl:template>

    <xsl:template match='@interactive' mode="solution"></xsl:template>

    <xsl:template match='TabNode[@tabname="Discussion"]'></xsl:template>

    <xsl:template match="QuestionNode">
        <xsl:apply-templates select="node()" />
    </xsl:template>

    <xsl:template match='TabNode[@tabname="Tip"]'>
        <hint>
            <xsl:apply-templates select="node()" />
        </hint>
    </xsl:template>

    <xsl:template match='RevealNode'>
        <hint>
            <xsl:apply-templates select="node()" />
        </hint>
    </xsl:template>

    <!-- kludges to mush CSAwesome into someting that PreTeXt doesn't choke on. -->

    <xsl:template match="TimedNode">
        <exercises>
            <xsl:apply-templates select="node()|@*"/>
        </exercises>
    </xsl:template>

    <xsl:template match='RevealNode[exercise]'>
        <exercises>
            <xsl:apply-templates select="node()|@*" />
        </exercises>
    </xsl:template>


</xsl:stylesheet>
