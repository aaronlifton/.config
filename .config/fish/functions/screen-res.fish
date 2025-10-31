function screen-res --description "Get the current screen resolution on macOS"
    system_profiler SPDisplaysDataType | grep Resolution
end
