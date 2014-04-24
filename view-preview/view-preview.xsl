<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:qcd="http://schema.qcadoo.org/view"
                xsi:schemaLocation="http://schema.qcadoo.org/view http://schema.qcadoo.org/view.xsd"
                exclude-result-prefixes="qcd xsi">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" />

	<xsl:strip-space elements="*" />

	<xsl:template name="windowTab">
		<xsl:param name="name" />
		<xsl:param name="reference" />

		<div>
			<xsl:attribute name="class">
				<xsl:value-of
						select="concat('windowTab ', $name, $reference)" />
			</xsl:attribute>
			<xsl:value-of select="$name" />
			<xsl:apply-templates>
				<xsl:with-param name="width">
					<xsl:value-of select="900" />
				</xsl:with-param>
				<xsl:with-param name="height">
					<xsl:value-of select="900" />
				</xsl:with-param>
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template match="//qcd:view//qcd:script"></xsl:template>

	<xsl:template match="//qcd:view">
		<html>
			<head>
				<link rel="stylesheet" type="text/css" href="style.css" />
			</head>
			<body>
				<xsl:apply-templates>
					<xsl:with-param name="width">
						<xsl:value-of select="900" />
					</xsl:with-param>
					<xsl:with-param name="height">
						<xsl:value-of select="900" />
					</xsl:with-param>
				</xsl:apply-templates>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="//qcd:view//qcd:windowTab">
		<xsl:call-template name="windowTab">
			<xsl:with-param name="name" select="@name" />
			<xsl:with-param name="reference" select="@reference" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template
			match="//qcd:component[@type='lookup' or @type='input' or @type='date' or @type='select' or @type='textarea' or @type='grid' or @type='tree' or @type='awesomeDynamicList']">
		<div>
			<xsl:attribute name="class">
				<xsl:value-of select="concat('componentPlaceholder ', @type)" />
			</xsl:attribute>
			<xsl:value-of select="@name" />
		</div>
	</xsl:template>

	<!--<xsl:template-->
	<!--match="//qcd:component[@type='grid' or @type='tree' or @type='awesomeDynamicList']">-->
	<!--<xsl:param name="width" />-->
	<!--<xsl:param name="height" />-->
	<!--<div class="bigComponentPlaceholder">-->
	<!--&lt;!&ndash;<xsl:attribute name="style">&ndash;&gt;-->
	<!--&lt;!&ndash;<xsl:value-of select="concat('width: ', $width, 'px; height: ', $height, 'px;')" />&ndash;&gt;-->
	<!--&lt;!&ndash;</xsl:attribute>&ndash;&gt;-->
	<!--<xsl:attribute name="style">-->
	<!--<xsl:value-of select="'width: 100%; height: 100%;'" />-->
	<!--</xsl:attribute>-->
	<!--<xsl:value-of select="@name" />-->
	<!--</div>-->
	<!--</xsl:template>-->

	<xsl:template match="//qcd:view//qcd:component[@type='gridLayout']/qcd:layoutElement">
		<xsl:param name="width" />
		<xsl:param name="height" />
		<div>

			<xsl:attribute name="class">
				<xsl:value-of select="'layoutElement '" />
			</xsl:attribute>
			<xsl:attribute name="style">
				<xsl:variable name="h">
					<xsl:choose>
						<xsl:when test="@height">
							<xsl:value-of select="@height" />
						</xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="w">
					<xsl:choose>
						<xsl:when test="@width">
							<xsl:value-of select="@width" />
						</xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of
						select="concat('width: ', $width * $w - ($w * 11), 'px; height: ', $height * $h + (($h - 1) * 20), 'px; left: ', ($width * (@column - 1) + ((@column - 1) * 11)), 'px; top: ', ($height * (@row - 1)) + ((@row - 1) * 20), 'px;')" />
			</xsl:attribute>

			<div class="content">
				<xsl:apply-templates>
					<xsl:with-param name="width">
						<xsl:value-of select="$width" />
					</xsl:with-param>
					<xsl:with-param name="height">
						<xsl:value-of select="$height" />
					</xsl:with-param>
				</xsl:apply-templates>
			</div>
		</div>

	</xsl:template>

	<xsl:template match="//qcd:view//qcd:component[@type='borderLayout' or @type='gridLayout']">
		<xsl:param name="width" />
		<xsl:param name="height" />
		<div>
			<xsl:attribute name="class">
				<xsl:value-of select="concat(@type, ' ')" />
			</xsl:attribute>
			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="@type='gridLayout'">
						<xsl:value-of
								select="concat('width: ', $width, 'px; height: ', @rows * 55, 'px;')" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
								select="'width: 100%;'" />
					</xsl:otherwise>
				</xsl:choose>

			</xsl:attribute>

			<div class="desc">
				<xsl:value-of select="concat('name: ', @name, ' ')" />
				<xsl:if test="@reference">
					<xsl:value-of select="concat('reference: ', @reference, ' ')" />
				</xsl:if>
				<xsl:if test="@type='gridLayout'">
					<xsl:value-of select="concat('dimensions: ', @columns, ' x ', @rows, ' ')" />
				</xsl:if>
			</div>

			<div class="content">
				<xsl:apply-templates>
					<xsl:with-param name="width">
						<xsl:choose>
							<xsl:when test="@type='gridLayout'">
								<xsl:value-of select="(number($width) - 27) div number(@columns)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number($width) - 27" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="height">
						<xsl:value-of select="35" />
					</xsl:with-param>
				</xsl:apply-templates>
			</div>
		</div>

	</xsl:template>

</xsl:stylesheet>