function 1p_api_key --argument-names title key url expires
    if test -z "$title" -o -z "$key"
        echo -e "Usage: 1p_api_key [title] [key] [expires]" \
            "\n You provided:\n title: $title\n key: $key\n url: $url\n expires: $expires"
        return 1
    end

    op item create --category="API Credential" --title='$title' \
        credential='$key' \
        url='$url' \
        expires='$expires'
end
