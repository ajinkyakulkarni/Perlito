package Perlito5::Grammar::Regex;

my %rule_terms;

token ws {  <.Perlito5::Grammar.ws>  }

token rule_ident {  <.Perlito5::Grammar.full_ident> | <digit> }

token any { . }

token literal {
    [
    |  \\ .
    |  <!before \' > .
    ]*
}

token metasyntax_exp {
    [
    |  \\ .
    |  \'  <.literal>     \'
    |  \{  <.string_code> \}
    |  \<  <.metasyntax_exp>  \>
    |  <!before \> > .
    ]+
}

token char_range {
    [
    |  \\ .
    |  <!before \] > .
    ]+
}

token char_class {
    |  <.rule_ident>
    |  \[  <.char_range>  \]
}

# XXX - not needed
token string_code {
    # bootstrap 'code'
    [
    |  \\ .
    |  \'  <.literal>     \'
    |  \{  <.string_code> \}
    |  <!before \} > .
    ]+
}

token parsed_code {
    # this subrule is overridden inside the perl6 compiler
    # XXX - call Perlito 'Statement List'
    <.string_code>
    { make '' . $MATCH }
}

token named_capture_body {
    | \(  <rule>        \)  { make { capturing_group => $MATCH->{"rule"}->flat() ,} }
    | \[  <rule>        \]  { make $MATCH->{"rule"}->flat() }
    | \<  <metasyntax_exp>  \>
            { make Rul::Subrule->new( metasyntax => $MATCH->{"metasyntax_exp"}->flat(), captures => 1 ) }
    | { die 'invalid alias syntax' }
}

token variables {
    |
        '$<'
        <rule_ident> \>
        { make '$MATCH->{' . '\'' . $MATCH->{"rule_ident"} . '\'' . '}' }
    |
        # TODO
        <Perlito5::Grammar.var_sigil>
        <Perlito5::Grammar.val_int>
        { make $MATCH->{"Perlito5::Grammar.var_sigil"} . '/[' . $MATCH->{"Perlito5::Grammar.val_int"} . ']' }
    |
        <Perlito5::Grammar.var_sigil>
        <Perlito5::Grammar.var_twigil>
        <Perlito5::Grammar.full_ident>
        {
            make Rul::Var->new(
                    sigil  => '' . $MATCH->{"Perlito5::Grammar.var_sigil"},
                    twigil => '' . $MATCH->{"Perlito5::Grammar.var_twigil"},
                    name   => '' . $MATCH->{"Perlito5::Grammar.full_ident"}
                   )
        }
}

token rule_terms {
    |   '('
        <rule> \)
        { make Rul::Capture->new( rule_exp => $MATCH->{"rule"}->flat() ) }
    |   '<('
        <rule>  ')>'
        { make Rul::CaptureResult->new( rule_exp => $MATCH->{"rule"}->flat() ) }
    |   '<after'
        <.ws> <rule> \>
        { make Rul::After->new( rule_exp => $MATCH->{"rule"}->flat() ) }
    |   '<before'
        <.ws> <rule> \>
        { make Rul::Before->new( rule_exp => $MATCH->{"rule"}->flat() ) }
    |   '<!before'
        <.ws> <rule> \>
        { make Rul::NotBefore->new( rule_exp => $MATCH->{"rule"}->flat() ) }
    |   '<!'
        # TODO
        <metasyntax_exp> \>
        { make { negate  => { metasyntax => $MATCH->{"metasyntax_exp"}->flat() } } }
    |   '<+'
        # TODO
        <char_class>  \>
        { make Rul::CharClass->new( chars => '' . $MATCH->{"char_class"} ) }
    |   '<-'
        # TODO
        <char_class> \>
        { make Rul::NegateCharClass->new( chars => '' . $MATCH->{"char_class"} ) }
    |   \'
        <literal> \'
        { make Rul::Constant->new( constant => $MATCH->{"literal"}->flat() ) }
    |   # XXX - obsolete syntax
        \< \'
        <literal> \' \>
        { make Rul::Constant->new( constant => $MATCH->{"literal"}->flat() ) }
    |   \<
        [
            <variables>   \>
            # { say 'matching < variables ...' }
            {
                # say 'found < hash-variable >';
                make Rul::InterpolateVar->new( var => $MATCH->{"variables"}->flat() )
            }
        |
            \?
            # TODO
            <metasyntax_exp>  \>
            { make Rul::Subrule->new( metasyntax => $MATCH->{"metasyntax_exp"}->flat(), captures => 0 ) }
        |
            \.
            <metasyntax_exp>  \>
            { make Rul::Subrule->new( metasyntax => $MATCH->{"metasyntax_exp"}->flat(), captures => 0 ) }
        |
            # TODO
            <metasyntax_exp>  \>
            { make Rul::Subrule->new( metasyntax => $MATCH->{"metasyntax_exp"}->flat(), captures => 1 ) }
        ]
    |   \{
        <parsed_code>  \}
        { make Rul::Block->new( closure => $MATCH->{"parsed_code"}->flat() ) }
    |   \\
        [
# TODO
#        | [ x | X ] <[ 0..9 a..f A..F ]]>+
#          #  \x0021    \X0021
#          { make Rul::SpecialChar->new( char => '\\' . $MATCH ) }
#        | [ o | O ] <[ 0..7 ]>+
#          #  \x0021    \X0021
#          { make Rul::SpecialChar->new( char => '\\' . $MATCH ) }
#        | ( x | X | o | O ) \[ (<-[ \] ]>*) \]
#          #  \x[0021]  \X[0021]
#          { make Rul::SpecialChar->new( char => '\\' . $0 . $1 ) }

        | c \[ <Perlito5::Grammar.digits> \]
          { make Rul::Constant->new( constant => chr( $MATCH->{"Perlito5::Grammar.digits"} ) ) }
        | c <Perlito5::Grammar.digits>
          { make Rul::Constant->new( constant => chr( $MATCH->{"Perlito5::Grammar.digits"} ) ) }
        | <any>
          #  \e  \E
          { make Rul::SpecialChar->new( char => $MATCH->{"any"}->flat() ) }
        ]
    |   \.
        { make Rul::Dot->new() }
    |   '['
        <rule> ']'
        { make $MATCH->{"rule"}->flat() }

}

token rule_term {
    |
       # { say 'matching variables' }
       <variables>
       [  <.ws>? '=' <.ws>? <named_capture_body>
          {
            make Rul::NamedCapture->new(
                rule_exp =>  $MATCH->{"named_capture_body"}->flat(),
                capture_ident => $MATCH->{"variables"}->flat()
            );
          }
       |
          {
            make $MATCH->{"variables"}->flat()
          }
       ]
    |
        # { say 'matching terms'; }
        <rule_terms>
        {
            make $MATCH->{"rule_terms"}->flat()
        }
    |  <!before \] | \} | \) | \> | \: | \? | \+ | \* | \| | \& | \/ > <any>   # TODO - <...>* - optimize!
        { make Rul::Constant->new( constant => $MATCH->{"any"}->flat() ) }
}

token quant_exp {
    |   '**'  <.Perlito5::Grammar.opt_ws>
        [
        |  <Perlito5::Grammar.val_int>
           { make $MATCH->{"Perlito5::Grammar.val_int"}->flat() }
        |  <rule_term>
           { make $MATCH->{"rule_term"}->flat() }
        ]
    |   [  \? | \* | \+  ]
}

token greedy_exp {   \?  |  \+  |  ''  }

token quantifier {
    <Perlito5::Grammar.opt_ws>
    <rule_term>
    <Perlito5::Grammar.opt_ws2>
    [
        <quant_exp> <greedy_exp>
        <Perlito5::Grammar.opt_ws3>
        { make Rul::Quantifier->new(
                term    => $MATCH->{"rule_term"}->flat(),
                quant   => $MATCH->{"quant_exp"}->flat(),
                greedy  => $MATCH->{"greedy_exp"}->flat(),
                ws1     => $MATCH->{"Perlito5::Grammar.opt_ws"}->flat(),
                ws2     => $MATCH->{"Perlito5::Grammar.opt_ws2"}->flat(),
                ws3     => $MATCH->{"Perlito5::Grammar.opt_ws3"}->flat(),
            )
        }
    |
        { make $MATCH->{"rule_term"}->flat() }
    ]
}

token concat_list {
    <quantifier>
    [
        <concat_list>
        { make [ $MATCH->{"quantifier"}->flat(), @($MATCH->{"concat_list"}->flat()) ] }
    |
        { make [ $MATCH->{"quantifier"}->flat() ] }
    ]
    |
        { make [] }
}

token concat_exp {
    <concat_list>
    { make Rul::Concat->new( concat => $MATCH->{"concat_list"}->flat() ) }
}

token or_list_exp {
    <concat_exp>
    [
        '|'
        <or_list_exp>
        { make [ $MATCH->{"concat_exp"}->flat(), @($MATCH->{"or_list_exp"}->flat()) ] }
    |
        { make [ $MATCH->{"concat_exp"}->flat() ] }
    ]
    |
        { make [] }
}

token rule {
    [ <.ws>? '|' | '' ]
    # { say 'trying M::G::Rule on ', $s }
    <or_list_exp>
    {
        # say 'found Rule';
        make Rul::Or->new( or_list => $MATCH->{"or_list_exp"}->flat() )
    }
}

=begin

=head1 NAME

Perlito5::Grammar::Regex - Grammar for Perlito Regex

=head1 SYNOPSIS

    my $match = $source.rule;
    $match->flat();    # generated Regex AST

=head1 DESCRIPTION

This module generates a syntax tree for the Regex compiler.

=head1 AUTHORS

Flavio Soibelmann Glock <fglock@gmail.com>.
The Pugs Team E<lt>perl6-compiler@perl.orgE<gt>.

=head1 SEE ALSO

The Perl 6 homepage at L<http://dev.perl.org/perl6>.

The Pugs homepage at L<http://pugscode.org/>.

=head1 COPYRIGHT

Copyright 2006, 2009, 2011 by Flavio Soibelmann Glock, Audrey Tang and others.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=end
