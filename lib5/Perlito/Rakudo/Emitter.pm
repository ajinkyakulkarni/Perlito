# Do not edit this file - Generated by Perlito 7.0
use v5;
use utf8;
use strict;
use warnings;
no warnings ('redefine', 'once', 'void', 'uninitialized', 'misc', 'recursion');
use Perlito::Perl5::Runtime;
use Perlito::Perl5::Prelude;
our $MATCH = Perlito::Match->new();
{
package GLOBAL;
    sub new { shift; bless { @_ }, "GLOBAL" }

    # use v6 
;
    {
    package CompUnit;
        sub new { shift; bless { @_ }, "CompUnit" }
        sub name { $_[0]->{name} };
        sub attributes { $_[0]->{attributes} };
        sub methods { $_[0]->{methods} };
        sub body { $_[0]->{body} };
        sub emit {
            my $self = $_[0];
            (chr(35) . ' class ' . $self->{name} . (chr(59) . ' ') . (chr(10)) . Main::join(([ map { $_->emit() } @{( (defined $self->{body} ? $self->{body} : ($self->{body} ||= bless([], 'ARRAY'))) )} ]), (chr(59) . ' ')) . (chr(10)))
        }
    }

;
    {
    package Val::Int;
        sub new { shift; bless { @_ }, "Val::Int" }
        sub int { $_[0]->{int} };
        sub emit {
            my $self = $_[0];
            $self->{int}
        }
    }

;
    {
    package Val::Bit;
        sub new { shift; bless { @_ }, "Val::Bit" }
        sub bit { $_[0]->{bit} };
        sub emit {
            my $self = $_[0];
            $self->{bit}
        }
    }

;
    {
    package Val::Num;
        sub new { shift; bless { @_ }, "Val::Num" }
        sub num { $_[0]->{num} };
        sub emit {
            my $self = $_[0];
            $self->{num}
        }
    }

;
    {
    package Val::Buf;
        sub new { shift; bless { @_ }, "Val::Buf" }
        sub buf { $_[0]->{buf} };
        sub emit {
            my $self = $_[0];
            (chr(39) . $self->{buf} . chr(39))
        }
    }

;
    {
    package Val::Undef;
        sub new { shift; bless { @_ }, "Val::Undef" }
        sub emit {
            my $self = $_[0];
            '(undef)'
        }
    }

;
    {
    package Val::Object;
        sub new { shift; bless { @_ }, "Val::Object" }
        sub class { $_[0]->{class} };
        sub fields { $_[0]->{fields} };
        sub emit {
            my $self = $_[0];
            ('bless(' . Main::perl((defined $self->{fields} ? $self->{fields} : ($self->{fields} = bless({}, 'HASH'))), ) . ', ' . Main::perl($self->{class}, ) . ')')
        }
    }

;
    {
    package Lit::Array;
        sub new { shift; bless { @_ }, "Lit::Array" }
        sub array1 { $_[0]->{array1} };
        sub emit {
            my $self = $_[0];
            ('[' . Main::join(([ map { $_->emit() } @{( (defined $self->{array1} ? $self->{array1} : ($self->{array1} ||= bless([], 'ARRAY'))) )} ]), ', ') . ']')
        }
    }

;
    {
    package Lit::Hash;
        sub new { shift; bless { @_ }, "Lit::Hash" }
        sub hash1 { $_[0]->{hash1} };
        sub emit {
            my $self = $_[0];
            ((my  $fields) = (defined $self->{hash1} ? $self->{hash1} : ($self->{hash1} ||= bless([], 'ARRAY'))));
            ((my  $str) = '');
            for my $field ( @{($fields)} ) {
                ($str = ($str . ($field->[0])->emit() . ' ' . chr(61) . '> ' . ($field->[1])->emit() . ','))
            };
            (chr(123) . ' ' . $str . ' ' . chr(125))
        }
    }

;
    {
    package Lit::Code;
        sub new { shift; bless { @_ }, "Lit::Code" }
        1
    }

;
    {
    package Lit::Object;
        sub new { shift; bless { @_ }, "Lit::Object" }
        sub class { $_[0]->{class} };
        sub fields { $_[0]->{fields} };
        sub emit {
            my $self = $_[0];
            ((my  $fields) = (defined $self->{fields} ? $self->{fields} : ($self->{fields} ||= bless([], 'ARRAY'))));
            ((my  $str) = '');
            for my $field ( @{($fields)} ) {
                ($str = ($str . ($field->[0])->emit() . ' ' . chr(61) . '> ' . ($field->[1])->emit() . ','))
            };
            ($self->{class} . '.new( ' . $str . ' )')
        }
    }

;
    {
    package Index;
        sub new { shift; bless { @_ }, "Index" }
        sub obj { $_[0]->{obj} };
        sub index_exp { $_[0]->{index_exp} };
        sub emit {
            my $self = $_[0];
            ($self->{obj}->emit() . '.[' . $self->{index_exp}->emit() . ']')
        }
    }

;
    {
    package Lookup;
        sub new { shift; bless { @_ }, "Lookup" }
        sub obj { $_[0]->{obj} };
        sub index_exp { $_[0]->{index_exp} };
        sub emit {
            my $self = $_[0];
            ($self->{obj}->emit() . '.' . chr(123) . $self->{index_exp}->emit() . chr(125))
        }
    }

;
    {
    package Var;
        sub new { shift; bless { @_ }, "Var" }
        sub sigil { $_[0]->{sigil} };
        sub twigil { $_[0]->{twigil} };
        sub name { $_[0]->{name} };
        sub emit {
            my $self = $_[0];
            ((my  $table) = do {
    (my  $Hash_a = bless {}, 'HASH');
    ($Hash_a->{chr(36)} = chr(36));
    ($Hash_a->{chr(64)} = chr(36) . 'List_');
    ($Hash_a->{chr(37)} = chr(36) . 'Hash_');
    ($Hash_a->{chr(38)} = chr(36) . 'Code_');
    $Hash_a
});
            ((($self->{twigil} eq '.')) ? ((chr(36) . 'self.' . chr(123) . $self->{name} . chr(125))) : (((($self->{name} eq chr(47))) ? (($table->{$self->{sigil}} . 'MATCH')) : (($table->{$self->{sigil}} . $self->{name})))))
        }
    }

;
    {
    package Bind;
        sub new { shift; bless { @_ }, "Bind" }
        sub parameters { $_[0]->{parameters} };
        sub arguments { $_[0]->{arguments} };
        sub emit {
            my $self = $_[0];
            if (Main::isa($self->{parameters}, 'Lit::Array')) {
                ((my  $a) = $self->{parameters}->array());
                ((my  $str) = 'do ' . chr(123) . ' ');
                ((my  $i) = 0);
                for my $var ( @{($a)} ) {
                    ((my  $bind) = Bind->new(('parameters' => $var), ('arguments' => Index->new(('obj' => $self->{arguments}), ('index_exp' => Val::Int->new(('int' => $i)))))));
                    ($str = ($str . ' ' . $bind->emit() . chr(59) . ' '));
                    ($i = ($i + 1))
                };
                return scalar (($str . $self->{parameters}->emit() . ' ' . chr(125)))
            };
            if (Main::isa($self->{parameters}, 'Lit::Hash')) {
                ((my  $a) = $self->{parameters}->hash());
                ((my  $b) = $self->{arguments}->hash());
                ((my  $str) = 'do ' . chr(123) . ' ');
                ((my  $i) = 0);
                (my  $arg);
                for my $var ( @{($a)} ) {
                    ($arg = Val::Undef->new());
                    for my $var2 ( @{($b)} ) {
                        if ((($var2->[0])->buf() eq ($var->[0])->buf())) {
                            ($arg = $var2->[1])
                        }
                    };
                    ((my  $bind) = Bind->new(('parameters' => $var->[1]), ('arguments' => $arg)));
                    ($str = ($str . ' ' . $bind->emit() . chr(59) . ' '));
                    ($i = ($i + 1))
                };
                return scalar (($str . $self->{parameters}->emit() . ' ' . chr(125)))
            };
            if (Main::isa($self->{parameters}, 'Lit::Object')) {
                ((my  $class) = $self->{parameters}->class());
                ((my  $a) = $self->{parameters}->fields());
                ((my  $b) = $self->{arguments});
                ((my  $str) = 'do ' . chr(123) . ' ');
                ((my  $i) = 0);
                (my  $arg);
                for my $var ( @{($a)} ) {
                    ((my  $bind) = Bind->new(('parameters' => $var->[1]), ('arguments' => Call->new(('invocant' => $b), ('method' => ($var->[0])->buf()), ('arguments' => do {
    (my  $List_a = bless [], 'ARRAY');
    (my  $List_v = bless [], 'ARRAY');
    $List_a
}), ('hyper' => 0)))));
                    ($str = ($str . ' ' . $bind->emit() . chr(59) . ' '));
                    ($i = ($i + 1))
                };
                return scalar (($str . $self->{parameters}->emit() . ' ' . chr(125)))
            };
            ($self->{parameters}->emit() . ' ' . chr(61) . ' ' . $self->{arguments}->emit())
        }
    }

;
    {
    package Proto;
        sub new { shift; bless { @_ }, "Proto" }
        sub name { $_[0]->{name} };
        sub emit {
            my $self = $_[0];
            "".($self->{name})
        }
    }

;
    {
    package Call;
        sub new { shift; bless { @_ }, "Call" }
        sub invocant { $_[0]->{invocant} };
        sub hyper { $_[0]->{hyper} };
        sub method { $_[0]->{method} };
        sub arguments { $_[0]->{arguments} };
        sub emit {
            my $self = $_[0];
            ((my  $invocant) = $self->{invocant}->emit());
            if (($invocant eq 'self')) {
                ($invocant = chr(36) . 'self')
            };
            if (((((((($self->{method} eq 'perl')) || (($self->{method} eq 'yaml'))) || (($self->{method} eq 'say'))) || (($self->{method} eq 'join'))) || (($self->{method} eq 'chars'))) || (($self->{method} eq 'isa')))) {
                if (($self->{hyper})) {
                    return scalar (('[ map ' . chr(123) . ' ' . chr(38) . 'Main::' . $self->{method} . '( ' . chr(36) . '_, ' . ', ' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ', ') . ')' . ' ' . chr(125) . ' ' . chr(64) . '( ' . $invocant . ' ) ]'))
                }
                else {
                    return scalar ((chr(38) . 'Main::' . $self->{method} . '(' . $invocant . ', ' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ', ') . ')'))
                }
            };
            ((my  $meth) = $self->{method});
            if (($meth eq 'postcircumfix:<( )>')) {
                ($meth = '')
            };
            ((my  $call) = ('.' . $meth . '(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ', ') . ')'));
            if (($self->{hyper})) {
                ('[ map ' . chr(123) . ' ' . chr(36) . '_' . $call . ' ' . chr(125) . ' ' . chr(64) . '( ' . $invocant . ' ) ]')
            }
            else {
                ($invocant . $call)
            }
        }
    }

;
    {
    package Apply;
        sub new { shift; bless { @_ }, "Apply" }
        sub code { $_[0]->{code} };
        sub arguments { $_[0]->{arguments} };
        sub emit {
            my $self = $_[0];
            ((my  $code) = $self->{code});
            if (Main::isa($code, 'Str')) {

            }
            else {
                return scalar (('(' . $self->{code}->emit() . ').(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ', ') . ')'))
            };
            if (($code eq 'self')) {
                return scalar (chr(36) . 'self')
            };
            if (($code eq 'say')) {
                return scalar (('say(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ', ') . ')'))
            };
            if (($code eq 'print')) {
                return scalar (('print(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ', ') . ')'))
            };
            if (($code eq 'array')) {
                return scalar ((chr(64) . '(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' ') . ')'))
            };
            if (($code eq 'prefix:<' . chr(126) . '>')) {
                return scalar (('(' . chr(34) . chr(34) . ' . ' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' ') . ')'))
            };
            if (($code eq 'prefix:<' . chr(33) . '>')) {
                return scalar (('(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' ') . ' ' . chr(63) . chr(63) . ' 0 ' . chr(33) . chr(33) . ' 1)'))
            };
            if (($code eq 'prefix:<' . chr(63) . '>')) {
                return scalar (('(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' ') . ' ' . chr(63) . chr(63) . ' 1 ' . chr(33) . chr(33) . ' 0)'))
            };
            if (($code eq 'prefix:<' . chr(36) . '>')) {
                return scalar ((chr(36) . '(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' ') . ')'))
            };
            if (($code eq 'prefix:<' . chr(64) . '>')) {
                return scalar ((chr(64) . '(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' ') . ')'))
            };
            if (($code eq 'prefix:<' . chr(37) . '>')) {
                return scalar ((chr(37) . '(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' ') . ')'))
            };
            if (($code eq 'infix:<' . chr(126) . '>')) {
                return scalar (('(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' ' . chr(126) . ' ') . ')'))
            };
            if (($code eq 'infix:<+>')) {
                return scalar (('(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' + ') . ')'))
            };
            if (($code eq 'infix:<->')) {
                return scalar (('(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' - ') . ')'))
            };
            if (($code eq 'infix:<' . chr(38) . chr(38) . '>')) {
                return scalar (('(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' ' . chr(38) . chr(38) . ' ') . ')'))
            };
            if (($code eq 'infix:<' . chr(124) . chr(124) . '>')) {
                return scalar (('(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' ' . chr(124) . chr(124) . ' ') . ')'))
            };
            if (($code eq 'infix:<eq>')) {
                return scalar (('(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' eq ') . ')'))
            };
            if (($code eq 'infix:<ne>')) {
                return scalar (('(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' ne ') . ')'))
            };
            if (($code eq 'infix:<' . chr(61) . chr(61) . '>')) {
                return scalar (('(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' ' . chr(61) . chr(61) . ' ') . ')'))
            };
            if (($code eq 'infix:<' . chr(33) . chr(61) . '>')) {
                return scalar (('(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ' ' . chr(33) . chr(61) . ' ') . ')'))
            };
            if (($code eq 'ternary:<' . chr(63) . chr(63) . ' ' . chr(33) . chr(33) . '>')) {
                return scalar (('(' . ((defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY')))->[0])->emit() . ' ' . chr(63) . chr(63) . ' ' . ((defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY')))->[1])->emit() . ' ' . chr(33) . chr(33) . ' ' . ((defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY')))->[2])->emit() . ')'))
            };
            ('' . $self->{code} . '(' . Main::join(([ map { $_->emit() } @{( (defined $self->{arguments} ? $self->{arguments} : ($self->{arguments} ||= bless([], 'ARRAY'))) )} ]), ', ') . ')')
        }
    }

;
    {
    package Return;
        sub new { shift; bless { @_ }, "Return" }
        sub result { $_[0]->{result} };
        sub emit {
            my $self = $_[0];
            return scalar (('return(' . $self->{result}->emit() . ')'))
        }
    }

;
    {
    package If;
        sub new { shift; bless { @_ }, "If" }
        sub cond { $_[0]->{cond} };
        sub body { $_[0]->{body} };
        sub otherwise { $_[0]->{otherwise} };
        sub emit {
            my $self = $_[0];
            ('do ' . chr(123) . ' if (' . $self->{cond}->emit() . ') ' . chr(123) . ' ' . Main::join(([ map { $_->emit() } @{( (defined $self->{body} ? $self->{body} : ($self->{body} ||= bless([], 'ARRAY'))) )} ]), chr(59)) . ' ' . chr(125) . ' else ' . chr(123) . ' ' . Main::join(([ map { $_->emit() } @{( (defined $self->{otherwise} ? $self->{otherwise} : ($self->{otherwise} ||= bless([], 'ARRAY'))) )} ]), chr(59)) . ' ' . chr(125) . ' ' . chr(125))
        }
    }

;
    {
    package For;
        sub new { shift; bless { @_ }, "For" }
        sub cond { $_[0]->{cond} };
        sub body { $_[0]->{body} };
        sub topic { $_[0]->{topic} };
        sub emit {
            my $self = $_[0];
            ((my  $cond) = $self->{cond});
            if ((Main::isa($cond, 'Var') && ($cond->sigil() eq chr(64)))) {
                ($cond = Apply->new(('code' => 'prefix:<' . chr(64) . '>'), ('arguments' => do {
    (my  $List_a = bless [], 'ARRAY');
    (my  $List_v = bless [], 'ARRAY');
    push( @{$List_a}, $cond );
    $List_a
})))
            };
            ('do ' . chr(123) . ' for my ' . $self->{topic}->emit() . ' ( ' . $cond->emit() . ' ) ' . chr(123) . ' ' . Main::join(([ map { $_->emit() } @{( (defined $self->{body} ? $self->{body} : ($self->{body} ||= bless([], 'ARRAY'))) )} ]), chr(59)) . ' ' . chr(125) . ' ' . chr(125))
        }
    }

;
    {
    package Decl;
        sub new { shift; bless { @_ }, "Decl" }
        sub decl { $_[0]->{decl} };
        sub type { $_[0]->{type} };
        sub var { $_[0]->{var} };
        sub emit {
            my $self = $_[0];
            return scalar (($self->{decl} . ' ' . $self->{type} . ' ' . $self->{var}->emit()))
        }
    }

;
    {
    package Sig;
        sub new { shift; bless { @_ }, "Sig" }
        sub invocant { $_[0]->{invocant} };
        sub positional { $_[0]->{positional} };
        sub named { $_[0]->{named} };
        sub emit {
            my $self = $_[0];
            ' print ' . chr(39) . 'Signature - TODO' . chr(39) . chr(59) . ' die ' . chr(39) . 'Signature - TODO' . chr(39) . chr(59) . ' '
        }
    }

;
    {
    package Method;
        sub new { shift; bless { @_ }, "Method" }
        sub name { $_[0]->{name} };
        sub sig { $_[0]->{sig} };
        sub block { $_[0]->{block} };
        sub emit {
            my $self = $_[0];
            ((my  $sig) = $self->{sig});
            ((my  $invocant) = $sig->invocant());
            ((my  $pos) = $sig->positional());
            ((my  $str) = '');
            ((my  $pos) = $sig->positional());
            for my $field ( @{($pos)} ) {
                ($str = ($str . '' . $field->emit() . chr(63) . ', '))
            };
            ('method ' . $self->{name} . '(' . $invocant->emit() . ': ' . $str . ') ' . chr(123) . ' ' . Main::join(([ map { $_->emit() } @{( (defined $self->{block} ? $self->{block} : ($self->{block} ||= bless([], 'ARRAY'))) )} ]), chr(59) . ' ') . ' ' . chr(125))
        }
    }

;
    {
    package Sub;
        sub new { shift; bless { @_ }, "Sub" }
        sub name { $_[0]->{name} };
        sub sig { $_[0]->{sig} };
        sub block { $_[0]->{block} };
        sub emit {
            my $self = $_[0];
            ((my  $sig) = $self->{sig});
            ((my  $pos) = $sig->positional());
            (my  $str);
            ((my  $pos) = $sig->positional());
            for my $field ( @{($pos)} ) {
                ($str = ($str . '' . $field->emit() . chr(63) . ', '))
            };
            if (($self->{name} eq '')) {
                return scalar (('(sub (' . $str . ') ' . ' ' . chr(123) . ' ' . Main::join(([ map { $_->emit() } @{( (defined $self->{block} ? $self->{block} : ($self->{block} ||= bless([], 'ARRAY'))) )} ]), chr(59) . ' ') . ' ' . chr(125) . ')'))
            };
            ('sub ' . $self->{name} . '(' . $str . ') ' . ' ' . chr(123) . ' ' . Main::join(([ map { $_->emit() } @{( (defined $self->{block} ? $self->{block} : ($self->{block} ||= bless([], 'ARRAY'))) )} ]), chr(59) . ' ') . ' ' . chr(125))
        }
    }

;
    {
    package Do;
        sub new { shift; bless { @_ }, "Do" }
        sub block { $_[0]->{block} };
        sub emit {
            my $self = $_[0];
            ('do ' . chr(123) . ' ' . Main::join(([ map { $_->emit() } @{( (defined $self->{block} ? $self->{block} : ($self->{block} ||= bless([], 'ARRAY'))) )} ]), chr(59) . ' ') . ' ' . chr(125))
        }
    }

;
    {
    package Use;
        sub new { shift; bless { @_ }, "Use" }
        sub mod { $_[0]->{mod} };
        sub emit {
            my $self = $_[0];
            ('use ' . $self->{mod})
        }
    }


}

1;
