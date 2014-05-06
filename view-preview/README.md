View Preview
==========

Simple tool created to speed up view's layout development.
View preview is just a XSL template, which translates Qcadoo View XML into interactive HTML page.
Therefore, all you need to use them is only XSLT processor.

### Usage
OSX users can use built-in processor, xsltproc as follows:
```
xsltproc -o output/dir/outputFileName.html path/to/sources/view-preview.xsl qcadooViewFileToTransform.xml && cp -a path/to/sources/assets output/dir/*
```

