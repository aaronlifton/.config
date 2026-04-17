function expo-add-cert --argument-names makecert
    if test "$makecert" = true
        echo "Making cert..."
        set -l ROOT_CA "$(mkcert -CAROOT)/rootCA.pem"
    else if test -z "$ROOT_CA"
        echo "You must set \$ROOT_CA to add the root certificate."
        return 1
    end

    if test -z "$ROOT_CA"
        echo "Error: \$ROOT_CA was empty."
        return 1
    end

    echo "Adding cert..."
    xcrun simctl keychain booted add-root-cert "$ROOT_CA"
end
