function update-ais
    set_color green
    echo Updating claude code...
    mise upgrade npm:@anthropic-ai/claude-code@latest

    set_color green
    echo Updating codex...
    mise upgrade npm:@openai/codex@latest

    set_color green
    echo Updating gemini...
    # brew upgrade gemini-cli
    mise upgrade npm:@google/gemini-cli@latest

    set_color blue
    echo \nDone
end
