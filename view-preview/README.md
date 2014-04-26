View Preview
==========

Simple tool created to speed up view's layout development.
View preview is just a XSLT, which translate Qcadoo View XML into HTML so all that you need to use them is any XSLT processor.

### Usage
For OSX with built in 'xsltproc':
```
xsltproc -o output/dir/outputFileName.html path/to/sources/view-preview.xsl qcadooViewFileToTransform.xml && cp -a path/to/sources/assets output/dir/*
```

