#!/bin/sh
cat input | perl -ne 'BEGIN { $count = 0; $prev = 0+"inf" } $count++ if ($_ > $prev); $prev = $_;  END { print $count }'
