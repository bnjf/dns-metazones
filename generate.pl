#!/usr/bin/env perl

# vim: set sts=2 sw=2 ts=8 et ai:

# 2014, Brad Forschinger

use strict;
use warnings;

use Net::DNS;

my $MZ_NAME = $ARGV[0] || "fh-sa.mz.vix.com";

my $res = Net::DNS::Resolver->new;
$res->nameservers("localhost");

my @mz = $res->axfr($MZ_NAME) or die "axfr: $!";

print make_zone_config(sort map { $_->ptrdname } grep { $_->type eq "PTR" } @mz);

exit;

sub make_zone_config {
  my $name = shift or return;

  "zone \"$name\" {\n",
  "\ttype slave;\n",
  "\tfile \"sec/$MZ_NAME/$name\";\n",
  conf_from_rt("masters",     $name),
  conf_from_rt("also-notify", $name),
  conf_transfer($name),
  "};\n\n",
  make_zone_config(@_);
}

sub conf_from_rt {
  my $statement = shift or return;

  "\t$statement {\n", (
    map {
      my $server = $_->intermediate;
      map { "\t\t" . $_->address . ";\n" }
      grep { $_->name eq $server && ($_->type eq "A" || $_->type eq "AAAA") } @mz;
    }
    sort { $a->preference <=> $b->preference }
    grep { $_->type eq "RT" && $_->name =~ /^\Q$statement.\E/ } @mz
  ),
  "\t};\n";
}

sub conf_transfer {
  "\tallow-transfer {\n", (
    map { "\t\tkey " . $_->mgmname . ";\n" }
    grep { $_->type eq "MG" && $_->name =~ /^allow-transfer\./ } @mz
  ),
  "\t};\n";
}
