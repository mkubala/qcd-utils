<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:qcd="http://schema.qcadoo.org/view"
                xsi:schemaLocation="http://schema.qcadoo.org/view http://schema.qcadoo.org/view.xsd"
                exclude-result-prefixes="qcd xsi">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" />

	<xsl:strip-space elements="*" />

	<xsl:variable name="padding">5</xsl:variable>
	<xsl:variable name="margin">5</xsl:variable>
	<xsl:variable name="border">1</xsl:variable>

	<xsl:template match="//qcd:view//qcd:script"></xsl:template>

	<xsl:template match="//qcd:view">

		<html>
			<head>
				<link rel="stylesheet" type="text/css" href="assets/style.css" />
			</head>
			<body>
				<xsl:apply-templates>
					<xsl:with-param name="width">
						<xsl:value-of select="900" />
					</xsl:with-param>
					<xsl:with-param name="height">
						<xsl:value-of select="900" />
					</xsl:with-param>
					<xsl:with-param name="path" select="concat('plugin_name.', @name)" />
				</xsl:apply-templates>
				<div id="tip">
					<span id="tipContent">XXX</span>
				</div>
				<script src="./assets/jquery-1.11.0.min.js">//</script>
				<script src="./assets/engine.js">//</script>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="//qcd:view//qcd:windowTab">
		<xsl:param name="path" />

		<div>
			<xsl:attribute name="class">
				<xsl:value-of
						select="concat('windowTab viewElement ', @name, @reference)" />
			</xsl:attribute>
			<div class="desc">
				<xsl:value-of select="$path" />
			</div>
			<xsl:value-of select="@name" />
			<xsl:apply-templates>
				<xsl:with-param name="width">
					<xsl:value-of select="900" />
				</xsl:with-param>
				<xsl:with-param name="height">
					<xsl:value-of select="300" />
				</xsl:with-param>
				<xsl:with-param name="path" select="concat($path, '.', @name)" />
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template
			match="//qcd:component[not (@type='lookup' or @type='input' or @type='date' or @type='select' or @type='textarea' or @type='grid' or @type='tree' or @type='awesomeDynamicList')]">
		<xsl:param name="width" />
		<xsl:param name="height" />
		<xsl:param name="path" />
		<div>
			<xsl:attribute name="class">
				<xsl:value-of select="@type" />
			</xsl:attribute>
			<xsl:apply-templates>
				<xsl:with-param name="height" select="$height" />
				<xsl:with-param name="width" select="$width" />
				<xsl:with-param name="path" select="concat($path, '.', @name)" />
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template
			match="//qcd:component[@type='lookup' or @type='input' or @type='date' or @type='select' or @type='textarea' or @type='grid' or @type='tree' or @type='awesomeDynamicList']">
		<xsl:param name="width" />
		<xsl:param name="height" />
		<xsl:param name="path" />
		<div>
			<xsl:attribute name="class">
				<xsl:value-of select="concat('viewElement componentPlaceholder ', @type)" />
			</xsl:attribute>
			<xsl:attribute name="style">
				<xsl:variable name="effectiveHeight">
					<xsl:choose>
						<xsl:when test="$height &lt; 30">
							<xsl:value-of select="$height" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="30" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of
						select="concat('width: ', $width, 'px; height ', $effectiveHeight, 'px; line-height: ', $effectiveHeight ,'px;')" />
			</xsl:attribute>
			<div class="desc">
				<xsl:call-template name="componentPath">
					<xsl:with-param name="path" select="$path" />
				</xsl:call-template>
				<xsl:call-template name="componentTranslations">
					<xsl:with-param name="path" select="$path" />
					<xsl:with-param name="node" select="." />
				</xsl:call-template>
				<br />
				<xsl:value-of select="concat('type: ', @type, ' ')" />
				<br />
				<xsl:value-of select="concat('name: ', @name, ' ')" />
				<br />
				<xsl:if test="@reference">
					<xsl:value-of select="concat('reference: ', @reference, ' ')" />
					<br />
				</xsl:if>
				<xsl:if test="@field">
					<xsl:value-of select="concat('field: ', @field, ' ')" />
					<br />
				</xsl:if>
				<xsl:if test="@source">
					<xsl:value-of select="concat('source: ', @source, ' ')" />
					<br />
				</xsl:if>
			</div>
			<xsl:value-of select="@name" />
		</div>
	</xsl:template>

	<xsl:template match="//qcd:view//qcd:component[@type='borderLayout' or @type='gridLayout']">
		<xsl:param name="width" />
		<xsl:param name="height" />
		<xsl:param name="path" />

		<xsl:variable name="effectiveWidth">
			<xsl:value-of select="$width - 2 * ($padding + $border)" />
		</xsl:variable>

		<xsl:variable name="effectiveHeight">
			<xsl:value-of select="$height - 2 *($padding + $border)" />
		</xsl:variable>

		<div>
			<xsl:attribute name="class">
				<xsl:value-of select="concat('viewElement ', @type, ' ')" />
			</xsl:attribute>
			<xsl:attribute name="style">
				<xsl:value-of
						select="concat('width: ', $effectiveWidth, 'px; height: ', $effectiveHeight, 'px;')" />
			</xsl:attribute>

			<div class="desc">
				<xsl:call-template name="componentPath">
					<xsl:with-param name="path" select="$path" />
				</xsl:call-template>
				<xsl:call-template name="componentTranslations">
					<xsl:with-param name="path" select="$path" />
					<xsl:with-param name="node" select="." />
				</xsl:call-template>
				<br />
				<xsl:value-of select="concat('type: ', @type, ' ')" />
				<br />
				<xsl:value-of select="concat('name: ', @name, ' ')" />
				<br />
				<xsl:if test="@reference">
					<xsl:value-of select="concat('reference: ', @reference, ' ')" />
					<br />
				</xsl:if>
				<xsl:if test="@type='gridLayout'">
					<xsl:value-of select="concat('dimensions: ', @columns, ' x ', @rows, ' ')" />
					<br />
				</xsl:if>
			</div>

			<div class="content">
				<xsl:apply-templates>
					<xsl:with-param name="width">
						<xsl:choose>
							<xsl:when test="@type='gridLayout'">
								<xsl:choose>
									<xsl:when test="@columns > 1">
										<xsl:value-of
												select="(($effectiveWidth) div @columns) - $padding" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
												select="$effectiveWidth" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$effectiveWidth" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="height">
						<xsl:choose>
							<xsl:when test="@type='gridLayout'">
								<xsl:choose>
									<xsl:when test="@rows > 1">
										<xsl:value-of
												select="(($effectiveHeight) div @rows) - $padding" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
												select="$effectiveHeight" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$effectiveHeight" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="path" select="$path" />
				</xsl:apply-templates>
			</div>
		</div>

	</xsl:template>

	<xsl:template match="//qcd:view//qcd:component[@type='gridLayout']/qcd:layoutElement">
		<xsl:param name="width" />
		<xsl:param name="height" />
		<xsl:param name="path" />

		<xsl:variable name="rowSpan">
			<xsl:choose>
				<xsl:when test="@height">
					<xsl:value-of select="@height" />
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="colSpan">
			<xsl:choose>
				<xsl:when test="@width">
					<xsl:value-of select="@width" />
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="effectiveWidth">
			<xsl:value-of select="($width) * $colSpan + ($colSpan - 1) * ($padding + $border)" />
		</xsl:variable>

		<xsl:variable name="effectiveHeight">
			<xsl:value-of select="($height) * $rowSpan + ($rowSpan - 1) * ($padding + $border)" />
		</xsl:variable>

		<div>
			<xsl:attribute name="class">
				<xsl:value-of select="'viewElement layoutElement '" />
			</xsl:attribute>
			<xsl:attribute name="style">
				<xsl:value-of
						select="concat('width: ', $effectiveWidth - 2*($padding + $border), 'px; ',
						'height: ', $effectiveHeight - 2 * ($padding + $border), 'px; ',
						'left: ', (@column - 1) * ($width + $padding + $border), 'px; ',
						'top: ', (@row - 1) * ($height + $padding + $border), 'px;')" />
			</xsl:attribute>

			<div class="desc">
				<xsl:value-of select="$path" />
				<br />
				type: layoutElement
				<br />
				<xsl:value-of select="concat('position: (', @column, ', ', @row
				, ') ')" />
				<br />
				<xsl:value-of select="concat('dimmensions: ', $colSpan, ' x ', $rowSpan, ' ')" />
				<br />
			</div>

			<div class="content">
				<xsl:apply-templates>
					<xsl:with-param name="width">
						<xsl:value-of
								select="$effectiveWidth - 2*($padding + $border)" />
					</xsl:with-param>
					<xsl:with-param name="height">
						<xsl:value-of
								select="$effectiveHeight - 2*($padding + $border)" />
					</xsl:with-param>
					<xsl:with-param name="path" select="$path" />
				</xsl:apply-templates>
			</div>
		</div>

	</xsl:template>

	<xsl:template name="componentPath">
		<xsl:param name="path" />
		path:
		<xsl:value-of select="$path" />
		<br />
	</xsl:template>

	<xsl:template name="componentTranslations">
		<xsl:param name="path" />
		<xsl:param name="node" />

		<xsl:variable name="type" select="$node/@type" />

		XXX:
		<xsl:value-of select="$type" />

		<xsl:choose>
			<xsl:when test="$node/@type='borderLayout'">
				<xsl:call-template name="borderLayoutTranslations">
					<xsl:with-param name="path" select="$path" />
					<xsl:with-param name="node" select="$node" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="fieldComponentTranslations">
					<xsl:with-param name="path" select="$path" />
					<xsl:with-param name="node" select="$node" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="fieldComponentTranslations">
		<xsl:param name="path" />
		<xsl:param name="node" />

		<xsl:variable name="name" select="$node/@name" />
		<xsl:variable name="field" select="$node/@field" />
		<xsl:variable name="modelName" select="/qcd:view/@modelName" />

		translation keys:
		<ul>
			<li>label:
				<ul>
					<li>
						<xsl:value-of select="concat($path, '.', $name, '.label')" />
					</li>
					<xsl:if test="$field">
						<li>
							<xsl:value-of select="concat('plugin.', $modelName, '.', $field, '.label')" />
						</li>
						<li>
							<xsl:value-of select="concat('[btPlugin].[btModel].', $field, '.label')" />
						</li>
					</xsl:if>
				</ul>
			</li>
			<xsl:if test="$node/@hasDescription='true'">
				<li>description:
					<ul>
						<li>
							<xsl:value-of select="concat($path, '.', $name, '.description')" />
						</li>
					</ul>
				</li>
				<li>descriptionHeader:
					<ul>
						<li>TODO</li>
						<li>qcadooView.form.descriptionHeader</li>
					</ul>
				</li>
			</xsl:if>

		</ul>
	</xsl:template>

	<xsl:template name="borderLayoutTranslations">
		<xsl:param name="path" />
		<xsl:param name="node" />

		<xsl:variable name="name" select="$node/@name" />
		<xsl:variable name="labelName" select="$node/qcd:option[@type='label']/@value" />

		translation keys:
		<ul>
			<xsl:if test="$labelName">
				<li>label:
					<ul>
						<li>
							<xsl:value-of select="concat($path, '.', $labelName)" />
						</li>
					</ul>
				</li>
			</xsl:if>
		</ul>
	</xsl:template>

</xsl:stylesheet>