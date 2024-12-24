function llm-glow --description "Generate a Gemini response with glow"
    set -l query $argv[1]

    set -l temp_file (mktemp /tmp/llm-response.XXXXXX)

    llm \
        -m gemini-1.5-flash-latest \
        --system "You are a helpful assistant. You will receive questions from a user who is asking you questions via his Kitty terminal on OSX, and he is a software engineer." "$query" >$temp_file

    glow $temp_file
    rm $temp_file
end
