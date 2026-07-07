{ pkgs, ... }:

let
  skull = pkgs.writeText "skull.txt" ''
        .-=$$$$$$$$=-
  $    :+=$$$$$$$$$$$$$$++:
    :=$$$$$$$$$$$$$$$$$$$=:
   +$$$$$$$$++==++=+$$$$$$$$$$-
  =$$+-:.:.-$$..$$+::.-=$$*:  %
 .$$=.  x   =-  ==   t  :$$+:
 -++:    ..-=.  :$-.     +$$:
.-+$$-.:-+++=:    =$$==+::+$$=
:=$$$$$$$$$$+--===+$$$$$$$$$+.
.-=::..-+++++++$$$$$$+-:::-++:
 .=++=-  -$$++$$$$$$$: .-=$$=
 .=$$+. +$+=+==*=+$$$-.-$$*=.
  :=+$$-$$=:.    c .-+$=:*+$$-
   .=+=.--       y   ::.*$+:.
    -=-     0          .$$=
    .=++-             .+$$+
    -*$$=:   n       -+$$$:
     :*$$*-. .... .=*+*+-    .
      :+*$$$$$$$$+*$$+=.
        :*$$$$$$$$$$=.
 |       .=$********=.
           .=$$$$$$-
  '';

  fingers = pkgs.writeText "fingers.txt" ''
                @   @@         @  @          @ @
                 @  @          @  @            @
                    @           @@           @@
                 @ @            @
                  @@
  '';

  thumb = pkgs.writeText "thumb.txt" ''
          @
         @@
        @ @
       @ @@
      @ @ @
     @  @@@
    @  @@@@@
     @@ @@@
     @   @@@@
       @  @@ @
        @   @ @
  '';

  dashboardSh = pkgs.writeShellScript "dashboard.sh" ''
    #!/usr/bin/env bash
    set -uo pipefail

    SKULL_W=33
    THUMB_W=13
    RIGHT_W=55
    MIN_COLS=88
    MIN_LINES=23

    COLS=$(tput cols  2>/dev/null || echo 80)
    LINES=$(tput lines 2>/dev/null || echo 24)

    NAME=$(${pkgs.figlet}/bin/figlet -f slant "$USER")
    DISK=$(df -h / | awk 'NR==2 { print $4 }')
    DATE=$(date +'%A, %B %d, %Y')
    STATS=$(cat <<STATS
[SYSTEM STATUS]
- Disk Space Left : $DISK
- Current Date    : $DATE

[REMINDERS & ALIASES]
- Type 'nixconfig' to edit/rebuild configs
- Type 'nixman'    for package operations
STATS
)

    if (( COLS < MIN_COLS || LINES < MIN_LINES )); then
      printf '%s\n' "$NAME"
      printf '%s\n' "$STATS"
      exit 0
    fi

    col_join() {
      awk -v w="$1" '
        FILENAME==ARGV[1]{L[NR]=$0;n=NR;next}{R[FNR]=$0;m=FNR}
        END{
          rows=(n>m)?n:m
          for(i=1;i<=rows;i++)
            printf "%-*s%s\n",w,(i in L?L[i]:""),(i in R?R[i]:"")
        }
      ' "$2" "$3"
    }

    awk -v w="$RIGHT_W" '{printf "%*s\n", w, $0}' "${fingers}" > /tmp/db_fingers.txt
    printf '%s\n' "$NAME"  > /tmp/db_name.txt
    printf '%s\n' "$STATS" > /tmp/db_stats.txt

    col_join "$THUMB_W" "${thumb}" /tmp/db_stats.txt > /tmp/db_bottom.txt
    cat /tmp/db_fingers.txt /tmp/db_name.txt /tmp/db_bottom.txt > /tmp/db_right.txt
    col_join "$SKULL_W" "${skull}" /tmp/db_right.txt

    rm -f /tmp/db_fingers.txt /tmp/db_name.txt /tmp/db_stats.txt \
          /tmp/db_bottom.txt /tmp/db_right.txt
  '';

in
{
  environment.systemPackages = [ pkgs.figlet ];
  environment.shellAliases.v = "${dashboardSh}";

  programs.zsh.loginShellInit = ''
    [[ $- == *i* ]] && ${dashboardSh}
  '';
}
