use strict;
use warnings;


package Perlito5::X64::Label;

sub new {
    my $class = shift;
    bless {@_}, $class;
}

sub pos {
    return $_[0]->{pos} 
}

sub bind {
    $_[0]->{pos} = $_[1];
}


package Perlito5::X64::Register;

sub new {
    my $class = shift;
    bless {@_}, $class;
}

sub code {
    return $_[0]->{code} 
}

sub is {
    return $_[0]->{code} == $_[1]->{code};
}

# Return the high bit of the register code as a 0 or 1.  Used often when constructing the REX prefix byte.
sub high_bit {
    my ($reg) = @_;
    return $reg->{code} >> 3;
}

# Return the 3 low bits of the register code.  Used when encoding registers in modR/M, SIB, and opcode bytes.
sub low_bits {
    my ($reg) = @_;
    return $reg->{code} & 0x7;
}

# emit REX if needed
sub emit_optional_rex_32 {
    my ($reg) = @_;
    Perlito5::X64::Assembler::emit(0x41) if $reg->high_bit();
}


package Perlito5::X64::Assembler;

my @buffer;
my @hex_char = qw( 0 1 2 3 4 5 6 7 8 9 A B C D E F );

#--- registers

my $r_rax = Perlito5::X64::Register->new( code => 0  );
my $r_rcx = Perlito5::X64::Register->new( code => 1  );
my $r_rdx = Perlito5::X64::Register->new( code => 2  );
my $r_rbx = Perlito5::X64::Register->new( code => 3  );
my $r_rsp = Perlito5::X64::Register->new( code => 4  );
my $r_rbp = Perlito5::X64::Register->new( code => 5  );
my $r_rsi = Perlito5::X64::Register->new( code => 6  );
my $r_rdi = Perlito5::X64::Register->new( code => 7  );
my $r_r8  = Perlito5::X64::Register->new( code => 8  );
my $r_r9  = Perlito5::X64::Register->new( code => 9  );
my $r_r10 = Perlito5::X64::Register->new( code => 10 );
my $r_r11 = Perlito5::X64::Register->new( code => 11 );
my $r_r12 = Perlito5::X64::Register->new( code => 12 );
my $r_r13 = Perlito5::X64::Register->new( code => 13 );
my $r_r14 = Perlito5::X64::Register->new( code => 14 );
my $r_r15 = Perlito5::X64::Register->new( code => 15 );

sub rax () { $r_rax } 
sub rcx () { $r_rcx }
sub rdx () { $r_rdx }
sub rbx () { $r_rbx }
sub rsp () { $r_rsp }
sub rbp () { $r_rbp }
sub rsi () { $r_rsi }
sub rdi () { $r_rdi }
sub r8  () { $r_r8  }
sub r9  () { $r_r9  }
sub r10 () { $r_r10 }
sub r11 () { $r_r11 }
sub r12 () { $r_r12 }
sub r13 () { $r_r13 }
sub r14 () { $r_r14 }
sub r15 () { $r_r15 }

#--- scale factors for operands

sub times_1 () { 0 }
sub times_2 () { 1 }
sub times_4 () { 2 }
sub times_8 () { 3 }
sub times_int_size     () { times_4 }
sub times_pointer_size () { times_8 }

#--- general

sub new {
    my $class = shift;
    @buffer = ();
    bless {@_}, $class;
}

sub to_hex {
    return join(' ',
               map( $hex_char[int($_ / 16)] . $hex_char[$_ % 16], @buffer ) );
}

sub asm_reset {
    @buffer = ();
}

sub emit {
    push @buffer, $_[0];
}

sub emitw {
    my ($v) = @_;
    emit( $v & 0xFF );
    emit( ( $v >> 8 ) & 0xFF );
}

sub emitl {
    my ($v) = @_;
    emit( $v & 0xFF );
    emit( ( $v >> 8  ) & 0xFF );
    emit( ( $v >> 16 ) & 0xFF );
    emit( ( $v >> 24 ) & 0xFF );
}

sub emit_rex_64 {
    my ($reg, $rm_reg) = @_;
    if ( @_ == 0 ) {
        # Emit a REX prefix that only sets REX.W to choose a 64-bit operand size.
        emit(0x48);
    }
    elsif ( @_ == 1 ) {
        # Emits a REX prefix that encodes a 64-bit operand size and
        # the top bit of the register code.
        # The high bit of register is used for REX.B.
        # REX.W is set and REX.R and REX.X are clear.
        emit(0x48 | $reg->high_bit());
    }
    elsif ( is_register($reg) && is_register($rm_reg) ) {
        emit(0x48 | $reg->high_bit() << 2 | $rm_reg->high_bit());
    }
    else {
        die "emit_rex_64: don't know what to do with $reg, $rm_reg";
    }
}

# Emit a ModR/M byte with registers coded in the reg and rm_reg fields.
sub emit_modrm {
    my ($reg, $rm_reg) = @_;
    if ( is_register($reg) && is_register($rm_reg) ) {
        emit(0xC0 | $reg->low_bits() << 3 | $rm_reg->low_bits());
    }
    else {
        die "emit_modrm: don't know what to do with $reg, $rm_reg";
    }
}

sub is_register {
    ref($_[0]) eq 'Perlito5::X64::Register'
}

sub is_zero { 
    return $_[0] == 0;
}

sub is_int8 {
    return -128 <= $_[0] && $_[0] < 128;
}

sub is_int16 {
    return -32768 <= $_[0] && $_[0] < 32768;
}

sub is_uint8 {
    return 0 <= $_[0] && $_[0] < 256;
}

sub is_uint16 {
    return 0 <= $_[0] && $_[0] < 65536;
}

sub label {
    return Perlito5::X64::Label->new();
}

#--- instructions

# bind the current address to a label
sub _bind {
    my ($label) = @_;
    die "bind: expecting a label"
        if ref($label) ne 'Perlito5::X64::Label';
    $label->bind( scalar(@buffer) );
}

sub _movl {
    my ( $dst, $src ) = @_;
    if ( is_register($dst) && is_register($src) ) {
        if ($src->low_bits() == 4) {
            emit_optional_rex_32($src, $dst);
            emit(0x89);
            emit_modrm($src, $dst);
        }
        else {
            emit_optional_rex_32($dst, $src);
            emit(0x8B);
            emit_modrm($dst, $src);
        }
    }
    else {
        die "movl: don't know what to do with $dst, $src";
    }
}

sub _movq {
    my ( $dst, $src ) = @_;
    if ( is_register($dst) && is_register($src) ) {
        if ($src->low_bits() == 4) {
            emit_rex_64($src, $dst);
            emit(0x89);
            emit_modrm($src, $dst);
        }
        else {
            emit_rex_64($dst, $src);
            emit(0x8B);
            emit_modrm($dst, $src);
        }
    }
    else {
        die "movq: don't know what to do with $dst, $src";
    }
}

sub _movsxlq {
    my ( $dst, $src ) = @_;
    if ( is_register($dst) && is_register($src) ) {
        emit_rex_64($src, $dst);
        emit(0x63);
        emit_modrm($src, $dst);
    }
    else {
        die "movsxlq: don't know what to do with $dst, $src";
    }
}

sub _repmovsb() {
    emit(0xF3);
    emit(0xA4);
}

sub _repmovsw() {
    emit(0x66);    # Operand size override.
    emit(0xF3);
    emit(0xA4);
}

sub _repmovsl() {
    emit(0xF3);
    emit(0xA5);
}

sub _repmovsq() {
    emit(0xF3);
    emit_rex_64();
    emit(0xA5);
}

sub _nop {
    emit(0x90);
}

sub _pop {
    my ( $dst ) = @_;
    if ( is_register($dst) ) {
        $dst->emit_optional_rex_32();
        emit(0x58 | $dst->low_bits());
    }
    else {
        die "pop: don't know what to do with $dst";
    }
}

sub _popfq {
    emit(0x9D);
}

sub _push {
    my ( $src ) = @_;
    if ( is_register($src) ) {
        $src->emit_optional_rex_32();
        emit(0x50 | $src->low_bits());
    }
    elsif (is_int8($src)) {
        emit(0x6A);
        emit($src);     # Emit low byte of value.
    }
    elsif (!ref($src)) {
        emit(0x68);
        emitl($src);    # int32
    }
    else {
        die "push: don't know what to do with $src";
    }
}

# Push a 32 bit integer, and guarantee that it is actually pushed as a
# 32 bit value, the normal push will optimize the 8 bit case.
sub _push_imm32 {
    my ( $src ) = @_;
    emit(0x68);
    emitl($src);    # int32
}

sub _pushfq {
    emit(0x9C);
}

sub _rdtsc {
    emit(0x0F);
    emit(0x31);
}

sub _ret {
    my ( $imm16 ) = @_;
    if ( !$imm16 ) {
        emit(0xC3);
    }
    else {
        emit(0xC2);
        emit( $imm16 & 0xFF );
        emit( ( $imm16 >> 8 ) & 0xFF );
    }
}

sub _shld {
    my ( $dst, $src ) = @_;
    emit_rex_64($src, $dst);
    emit(0x0F);
    emit(0xA5);
    emit_modrm($src, $dst);
}

sub _shrd {
    my ( $dst, $src ) = @_;
    emit_rex_64($src, $dst);
    emit(0x0F);
    emit(0xAD);
    emit_modrm($src, $dst);
}

sub _xchg {
    my ( $dst, $src ) = @_;
    if ( $src->is(rax) || $dst->is(rax) ) {
        # Single-byte encoding
        my $other = $src->is(rax) ? $dst : $src;
        emit_rex_64($other);
        emit( 0x90 | $other->low_bits() );
    }
    elsif ( $dst->low_bits() == 4 ) {
        emit_rex_64( $dst, $src );
        emit(0x87);
        emit_modrm( $dst, $src );
    }
    else {
        emit_rex_64( $src, $dst );
        emit(0x87);
        emit_modrm( $src, $dst );
    }
}

1;

__END__

=pod

=head1 Perlito5::X64::Assembler

The Perlito5 x64 backend

=head1 Synopsis

    use Perlito5::X64::Assembler;

    package Perlito5::X64::Assembler;
    _ret();
    say to_hex();   # C3

    asm_reset();
    my $here = label;
    _xchg( rax, rcx );
    _bind($here);
    say "# xchg " . to_hex();
    say "# label pos=", $here->pos();

=head1 References

- V8 Javascript Compiler

    src/x64/assembler-x64.cc

=cut

