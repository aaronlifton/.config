# Example usage: run-ginkgo component "Store - GetScriptsByAssetUID" ./modules/asset-service/v2/internal/test/component/
function run-ginkgo --argument-names tags focus package_path
    # Check if required arguments are provided (optional but good practice)
    if not set -q tags
        echo "Error: --argument-names 'tags' is missing."
        echo "Usage: run-ginkgo <tags> <focus> <package_path>"
        return 1
    end
    if not set -q focus
        echo "Error: --argument-names 'focus' is missing."
        echo "Usage: run-ginkgo <tags> <focus> <package_path>"
        return 1
    end
    if not set -q package_path
        echo "Error: --argument-names 'package_path' is missing."
        echo "Usage: run-ginkgo <tags> <focus> <package_path>"
        return 1
    end

    # Construct and run the command
    # Use 'command' to prevent potential alias issues
    # Quote variables to handle spaces or special characters correctly
    command godotenv -f .env.test ginkgo \
        --tags="$tags" \
        --focus="$focus" \
        -v \
        "$package_path"
end

# Example usage (you would type this in your terminal):
# run-ginkgo component "Store - GetScriptsByAssetUID" ./modules/asset-service/v2/internal/test/component/

# To save this function:
# 1. Open your fish config file (e.g., ~/.config/fish/functions/run-ginkgo.fish)
# 2. Paste the function definition into the file.
# 3. Save the file.
# 4. Either restart fish or run 'source ~/.config/fish/functions/run-ginkgo.fish'
