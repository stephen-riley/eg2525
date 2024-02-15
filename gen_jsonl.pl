use strict;
use warnings;
use v5.30;

use JSON;

my @files = <randomized/*.png>;

foreach my $f ( sort @files ) {
    $f =~ s{randomized/}{};
    my $record = {
        imageGcsUri => "gs://2525-icons-1/$f"
    };
    my $label = $f =~ s/_.*//r;
    $label = $label =~ s/\.png//r;
    $record->{classificationAnnotation} = { displayName => $label };
    my $json = to_json( $record );
    say $json;
}

# {"imageGcsUri": "gs://bucket/filename1.jpeg",  "classificationAnnotation": {"displayName": "daisy"}, "dataItemResourceLabels": {"aiplatform.googleapis.com/ml_use": "test"}}
