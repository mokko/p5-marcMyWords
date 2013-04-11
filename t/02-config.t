use Test::More;
use strict;
use warnings;
use File::HomeDir;
use Path::Class::Dir;
use Path::Class::File;

#try Types::Tiny one of these days
#use Data::Dumper;

use MARC::Shell::Config;

note 'locations with defaults';
{
    my $config = MARC::Shell::Config->new;
    ok( $config, 'object returned' );
    my $config_dir =
      Path::Class::Dir->new( File::HomeDir->my_home, '.marcMyWords' );
    is( $config->dir, $config_dir, 'config dir looks right: ' . $config->dir );

    is(
        $config->file,
        Path::Class::File->new( $config_dir, 'config' ),
        'config file looks right: ' . $config->file
    );
}

note 'locations with specified rel file';
{
    my $rel_path = 'path/to/file';                                #rel to pwd
    my $config = MARC::Shell::Config->new( file => $rel_path );
    ok( $config, 'object returned' );
    my $file = Path::Class::File->new($rel_path)->absolute;
    is( $config->file, $file,      'path looks good' );
    is( $config->dir,  $file->dir, 'dir looks good' );
}

note 'locations with specified rel dir';
{
    my $rel_path = 'path/to/dir'; #rel to pwd
    my $config = MARC::Shell::Config->new( dir => $rel_path );
    ok( $config, 'object returned' );
    my $dir = Path::Class::Dir->new($rel_path)->absolute;
    my $file=Path::Class::File->new( $dir, 'config' );
    is(
        $config->file,
        $file,
        'path looks good'
    );
    is( $config->dir, $file->dir, 'dir looks good' );
}

#print list_methods();
sub list_methods {
    use Class::Inspector;
    use Data::Dumper;
    no strict 'refs';

    print "PUBLIC SYMBOLS\n";
    print Dumper ( Class::Inspector->methods( 'MARC::Shell', 'public' ) );
    use strict 'refs';
}

done_testing;
