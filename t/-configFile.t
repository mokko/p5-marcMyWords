use Test::More;
use strict;
use warnings;
use File::HomeDir;
use Path::Class;
use_ok('Config::File');

note 'config location';

#print "path:".$conf->path."\n";

note 'defaults';
{
    my $conf = Config::File->new();
    ok( $conf, 'config object exists' );
    is( $conf->dir, File::HomeDir->my_home, 'dir default ok' );
    is( $conf->file, 'config', 'file (basename?) default ok' );
    is(
        $conf->path,
        file( File::HomeDir->my_home, 'config' ),
        'path default ok'
    );
}

note 'input via dir (relative) + file';
{
    my $path = 'path/to';
    my $file = 'file.txt';
    my $conf = Config::File->new( dir => $path, file => $file );
    ok( $conf, 'config object exists' );
    is( $conf->dir,  Path::Class::Dir->new($path)->absolute,  'dir' );
    is( $conf->file, $file, 'file' );
    is( $conf->path, file( $path, 'file.txt' ), 'path' );
}

note 'input via path (absolute)';
{
    my $path = '/path/to/file.txt';
    my $conf = Config::File->new( path => $path );
    ok( $conf, "config object exists for '$path'" );
    is( $conf->dir,  Path::Class::Dir->new ('/path/to'), 'derrived dir ok' );
    is( $conf->file, 'file.txt', 'derrived file ok' );
    is( $conf->path, Path::Class::File->new ($path),      'path ok'.$conf->path );
}

note 'input via path (relative)';
{
    my $path = 'path/to/file.txt';
    my $conf = Config::File->new( path => $path );
    ok( $conf, "config object exists for '$path'" );
    is(
        $conf->dir,
        Path::Class::Dir->new('path/to')->absolute,
        'derrived dir ok'
    );
    is( $conf->file, 'file.txt', 'derrived file ok' );
    is( $conf->path, $path,      'path ok' );
}

note 'input via path (relative, unclean, inexistent)';
{
    my $path = 'path//to/../file.txt';
    my $conf = Config::File->new( path => $path );
    ok( $conf, "config object exists for '$path'" );
    is(
        $conf->dir,
        Path::Class::File->new($path)->cleanup->absolute->dir,
        'derrived dir ok' . $conf->dir
    );
    is( $conf->file, 'file.txt', 'derrived file ok' );
    is( $conf->path, $path,      'path ok' );
}
done_testing;

1;
