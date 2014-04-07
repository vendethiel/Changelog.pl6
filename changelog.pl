sub MAIN($next-version = 'master') {
	my $first-commit = qx/git log --pretty=%H | tail -1/.chomp;
	my @versions = ('master', qx/git tag/.chomp.split("\n").reverse, $first-commit).uniq;

	sub describe(Int $i, Str $tag) {
		if $tag !eq 'master' {
			print "\n$tag";
			print qqx/git --no-pager log -1 --date=short --pretty=" (%ad)" "$tag"/; # date
		}
		print git-log-short("@versions[$i+1]..$tag");
	}

	say $next-version;
	@versions[0..*-1].grep(* !eq $first-commit).kv.map: &describe;
	say git-log-short($first-commit);
}

sub git-log-short($range) {
	qqx/git --no-pager log --date=short --pretty="- %h: %s" "$range"/;
}