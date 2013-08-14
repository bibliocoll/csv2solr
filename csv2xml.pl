#!/usr/bin/perl
# Erik Altmann, MPDL 2013
####
use Text::CSV;
use XML::Writer;
use IO::File;

my $file = shift;

die "file missing or not readable" if(!$file);

# create objects
my $csv = Text::CSV->new({binary => 1}); my $xml = XML::Writer->new(OUTPUT => \$out, DATA_INDENT => 1, DATA_MODE => 1);

# data
my $data = [];

# read csv data
open my $fh, "<:encoding(UTF-8)", $file or die $!; $csv->column_names($csv->getline($fh));
$data = $csv->getline_hr_all($fh);
close $fh;

# write xml
$xml->xmlDecl("utf-8");
$xml->startTag("records");

foreach my $rs (@$data) {
    $xml->startTag("row");
     foreach my $key(keys(%$rs)) {
         $xml->dataElement($key, $rs->{$key});
     }
    $xml->endTag("row");
}

$xml->endTag("records");
$xml->end();

# create otuput
binmode STDOUT, ":utf8";
print "$out\n";
####
