# usage:
#   fish -c 'spinner' &
#   set pid $last_pid
#   sleep 2
#   kill $pid
#   echo -ne '\r'
function spinner -d 'A simple loading spinner for Fish'
    argparse c/clock d/dot m/moon w/weather -- $argv 2>/dev/null

    set -l cr '\r'
    set -l spaces ' '
    set -l chars ''
    set -l template '%b%b%s'

    # https://github.com/sindresorhus/cli-spinners/blob/main/spinners.json
    set -l plain_chars '|' / - '\\'
    set -l dot_chars '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏'

    # these are full-width characters so they only require 1 space for alignment
    set -l clock_chars '\U1F55B' # 🕛 twelve o’clock
    set -a clock_chars '\U1F55C' # 🕜 one-thirty
    set -a clock_chars '\U1F552' # 🕒 three o’clock
    set -a clock_chars '\U1F55F' # 🕟 four-thirty
    set -a clock_chars '\U1F555' # 🕕 six o’clock
    set -a clock_chars '\U1F562' # 🕢 seven-thirty
    set -a clock_chars '\U1F558' # 🕘 nine o’clock
    set -a clock_chars '\U1F565' # 🕥 ten-thirty

    set -l moon_chars '\U1F311' # 🌑 new moon
    set -a moon_chars '\U1F312' # 🌒 waxing crescent moon
    set -a moon_chars '\U1F313' # 🌓 first quarter moon
    set -a moon_chars '\U1F314' # 🌔 waxing gibbous moon
    set -a moon_chars '\U1F315' # 🌕 full moon
    set -a moon_chars '\U1F316' # 🌖 waning gibbous moon
    set -a moon_chars '\U1F317' # 🌗 last quarter moon
    set -a moon_chars '\U1F318' # 🌘 waning crescent moon

    # these use a "variation selector" to force them to be rendered as images
    # note: you can run into issues with these
    set -l weather_chars '\U1F324\UFE0F' # 🌤️ sun behind small cloud
    set -a weather_chars '\U1F326\UFE0F' # 🌦️ sun behind rain cloud
    set -a weather_chars '\U1F327\UFE0F' # 🌧️ cloud with rain
    set -a weather_chars '\U26C8\UFE0F' # ⛈️ cloud with lightning and rain
    set -a weather_chars '\U1F329\UFE0F' # 🌩️ cloud with lightning
    set -a weather_chars '\U1F325\UFE0F' # 🌥️ sun behind large cloud

    if set -q _flag_c
        set chars $clock_chars
    else if set -q _flag_m
        set chars $moon_chars
    else if set -q _flag_w
        set chars $weather_chars
        set spaces '  '
    else if set -q _flag_d
        set chars $dot_chars
        set template '%b%s%s'
    else
        set chars $plain_chars
        set template '%b%s%s'
    end

    # I cannot get something like `trap 'echo -ne "\r"' EXIT INT` to work
    # so you just have to clear it manually with `echo -ne '\r'`
    set -l i 1
    while true
        printf $template $cr $chars[$i] $spaces
        set i (math $i % (count $chars) + 1)
        sleep 0.15
    end
end
