use strict;
use warnings;
use Test::More 0.88;
# This is a relatively nice way to avoid Test::NoWarnings breaking our
# expectations by adding extra tests, without using no_plan.  It also helps
# avoid any other test module that feels introducing random tests, or even
# test plans, is a nice idea.
our $success = 0;
END { $success && done_testing; }

my $v = "\n";

eval {                     # no excuses!
    # report our Perl details
    my $want = "any version";
    my $pv = ($^V || $]);
    $v .= "perl: $pv (wanted $want) on $^O from $^X\n\n";
};
defined($@) and diag("$@");

# Now, our module version dependencies:
sub pmver {
    my ($module, $wanted) = @_;
    $wanted = " (want $wanted)";
    my $pmver;
    eval "require $module;";
    if ($@) {
        if ($@ =~ m/Can't locate .* in \@INC/) {
            $pmver = 'module not found.';
        } else {
            diag("${module}: $@");
            $pmver = 'died during require.';
        }
    } else {
        my $version;
        eval { $version = $module->VERSION; };
        if ($@) {
            diag("${module}: $@");
            $pmver = 'died during VERSION check.';
        } elsif (defined $version) {
            $pmver = "$version";
        } else {
            $pmver = '<undef>';
        }
    }

    # So, we should be good, right?
    return sprintf('%-45s => %-10s%-15s%s', $module, $pmver, $wanted, "\n");
}

eval { $v .= pmver('Carp','any version') };
eval { $v .= pmver('Data::Couplet','0.02004312') };
eval { $v .= pmver('Data::Dumper','any version') };
eval { $v .= pmver('Dist::Zilla::PluginBundle::Author::KENTNL','1.0.0') };
eval { $v .= pmver('Dist::Zilla::PluginBundle::Author::KENTNL::Lite','0.01009803') };
eval { $v .= pmver('English','any version') };
eval { $v .= pmver('File::Find','any version') };
eval { $v .= pmver('File::Temp','any version') };
eval { $v .= pmver('HTML::Tiny','any version') };
eval { $v .= pmver('List::MoreUtils','any version') };
eval { $v .= pmver('List::Util','any version') };
eval { $v .= pmver('Module::Build','0.3601') };
eval { $v .= pmver('Module::Pluggable::Object','any version') };
eval { $v .= pmver('Moose','0.90') };
eval { $v .= pmver('Moose::Role','0.90') };
eval { $v .= pmver('MooseX::Clone','any version') };
eval { $v .= pmver('MooseX::LazyRequire','0.04') };
eval { $v .= pmver('MooseX::Types','0.20') };
eval { $v .= pmver('MooseX::Types::Moose','any version') };
eval { $v .= pmver('Scalar::Util','any version') };
eval { $v .= pmver('Test::More','0.88') };
eval { $v .= pmver('namespace::autoclean','any version') };



# All done.
$v .= <<'EOT';

Thanks for using my code.  I hope it works for you.
If not, please try and include this output in the bug report.
That will help me reproduce the issue and solve you problem.

EOT

diag($v);
ok(1, "we really didn't test anything, just reporting data");
$success = 1;

# Work around another nasty module on CPAN. :/
no warnings 'once';
$Template::Test::NO_FLUSH = 1;
exit 0;
