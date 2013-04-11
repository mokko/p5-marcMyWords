package MARC::Shell::Base;    #it's a role, not sure base is suitable
use strict;
use warnings;
use Moo::Role;
use File::Spec;
use MooX::Types::MooseLike::Base qw (Str);
#with 'MARC::Shell::History'; dont need no freaking history right now
#with 'MARC::Shell::Plugins';



#
# FileUtils
#

#from Dancer::FileUtils:path should not verify paths, just normalize
sub path {
    my $self  = shift;
    my @parts = @_;
    my $path  = File::Spec->catfile(@parts);

    return _normalize_path($path);
}

=function _normalize_path

Private function!

=cut

sub _normalize_path {    #from Dancer::FileUtils

    # this is a revised version of what is described in
    # http://www.linuxjournal.com/content/normalizing-path-names-bash
    # by Mitch Frazier
    my $path = shift or return;
    my $seqregex = qr{
        [^/]*  # anything without a slash
        /\.\./ # that is accompanied by two dots as such
    }x;

    $path =~ s{/\./}{/}g;
    while ($path =~ s{$seqregex}{}) { }

    return $path;
}


=method my $text=$self->_get_file_text($file);

returns slurped text file.

Keep this private (underscore)?

=cut

sub _get_file_text {    #from Test::Mining::Shell
    my ($self, $path_file_name) = @_;
    my ($text, $line);
    if (-e $path_file_name) {
        open(my $IN, '<', $path_file_name)
          || $self->error("(Get) Cannot open $path_file_name: $!");
        while ($line = <$IN>) { $text .= $line; }
        close($IN) || $self->error("(Get) Cannot close $path_file_name: $!");
    }
    return $text;
}



#
# MESSAGES
#

sub debug {
    my $self = shift;
    my $msg = shift or return;
    print "$msg\n";
}

sub error {
    my $self = shift;
    my $msg = shift or return;
    print "Error: $msg\n";
}

1;
