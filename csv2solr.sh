#!/bin/bash
# Daniel Zimmel 2013
# Conversion CSV -> Solr XML for import in VuFind
# Delete matching lines containing ISBNs from rows in isbn.csv
# csv2csv, discard duplicates (awk)
# csv2xml (Perl)
# xml2solrxml (Saxon) - change xsl if needed (select fields, adapt Solr schema)

FILE=$1

if [ -z "$1" ] || [ ! -f $FILE ]; then
    echo "Input file $FILE not found! Exiting..";
    exit
fi

echo "deleting duplicates...";

# discard duplicates
# a = array
# -F = csv value
# $1 = first column in isbn.csv
# $2 = second column in $FILE
awk -F "," 'FNR==NR { a[$1]; next } !($2 in a)' isbn.csv $FILE > update-noduplicates.csv;
awk -F "," 'FNR==NR { a[$1]; next } ($2 in a)' isbn.csv $FILE > update-duplicates.csv;

echo "deleted duplicates, next: creating update.xml... take a coffee, this might take a while...";

# csv2xml
perl csv2xml.pl update-noduplicates.csv > update.xml;

echo "created update.xml, next: creating update.solr.xml...";

# xml2solrxml - change -xsl if needed
java -Xmx1024m -jar saxon9he.jar -s:update.xml -xsl:vub-pda.xsl -o:update.solr.xml;

echo "created update.solr.xml, all done!"
