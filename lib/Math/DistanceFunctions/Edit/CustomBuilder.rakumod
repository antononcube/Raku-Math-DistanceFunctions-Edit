use LibraryMake;
use Distribution::Builder::MakeFromJSON;

class Math::DistanceFunctions::Edit::CustomBuilder is Distribution::Builder::MakeFromJSON {
    method build(IO() $work-dir = $*CWD) {
        my $workdir = ~$work-dir;
        my $srcdir = "$workdir/src";
        my %vars = get-vars($workdir);
        %vars<EditDistance> = $*VM.platform-library-name('EditDistance'.IO);
        mkdir "$workdir/resources" unless "$workdir/resources".IO.e;
        mkdir "$workdir/resources/libraries" unless "$workdir/resources/libraries".IO.e;
		%vars<DESTDIR> .= subst(' ', '\ '):g;
        process-makefile($srcdir, %vars);
        my $goback = $*CWD;
        chdir($srcdir);
        shell(%vars<MAKE>);
        chdir($goback);
    }
}
