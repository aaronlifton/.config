## !/usr/local/bin/fish
## Save as ~/.config/yadm/hooks/post_pull and make executable

# Pull the private config repo
set private_repo "git@github.com:aaronlifton/.config-private.git"
set temp_dir (mktemp -d)
git clone $private_repo $temp_dir

# Process each file in the private repo
for file in (find $temp_dir -type f)
    # Get the relative path by removing the temp dir prefix
    set relative_path (string replace "$temp_dir/" "" $file)

    # Construct the target path in home directory
    set target_path "$HOME/$relative_path"

    # Create target directory if it doesn't exist
    mkdir -p (dirname $target_path)

    # If target exists, rename it with .new
    if test -f $target_path
        cp $file "$target_path.new"
        echo "Conflict: $target_path exists, saved as $target_path.new"
    else
        cp $file $target_path
        echo "Moved: $file -> $target_path"
    end
end

# Cleanup: remove the temporary directory
rm -rf $temp_dir
echo "Config files updated successfully"
