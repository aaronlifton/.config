# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_spotify_player_global_optspecs
	string join \n t/theme= c/config-folder= C/cache-folder= h/help V/version
end

function __fish_spotify_player_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_spotify_player_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_spotify_player_using_subcommand
	set -l cmd (__fish_spotify_player_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c spotify_player -n "__fish_spotify_player_needs_command" -s t -l theme -d 'Application theme' -r
complete -c spotify_player -n "__fish_spotify_player_needs_command" -s c -l config-folder -d 'Path to the application\'s config folder' -r
complete -c spotify_player -n "__fish_spotify_player_needs_command" -s C -l cache-folder -d 'Path to the application\'s cache folder' -r
complete -c spotify_player -n "__fish_spotify_player_needs_command" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_needs_command" -s V -l version -d 'Print version'
complete -c spotify_player -n "__fish_spotify_player_needs_command" -f -a "get" -d 'Get Spotify data'
complete -c spotify_player -n "__fish_spotify_player_needs_command" -f -a "playback" -d 'Interact with the playback'
complete -c spotify_player -n "__fish_spotify_player_needs_command" -f -a "connect" -d 'Connect to a Spotify device'
complete -c spotify_player -n "__fish_spotify_player_needs_command" -f -a "like" -d 'Like currently playing track'
complete -c spotify_player -n "__fish_spotify_player_needs_command" -f -a "authenticate" -d 'Authenticate the application'
complete -c spotify_player -n "__fish_spotify_player_needs_command" -f -a "playlist" -d 'Playlist editing'
complete -c spotify_player -n "__fish_spotify_player_needs_command" -f -a "generate" -d 'Generate shell completion for the application CLI'
complete -c spotify_player -n "__fish_spotify_player_needs_command" -f -a "search" -d 'Search spotify'
complete -c spotify_player -n "__fish_spotify_player_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand get; and not __fish_seen_subcommand_from key item help" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand get; and not __fish_seen_subcommand_from key item help" -f -a "key" -d 'Get data by key'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand get; and not __fish_seen_subcommand_from key item help" -f -a "item" -d 'Get a Spotify item\'s data'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand get; and not __fish_seen_subcommand_from key item help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand get; and __fish_seen_subcommand_from key" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand get; and __fish_seen_subcommand_from item" -s i -l id -r
complete -c spotify_player -n "__fish_spotify_player_using_subcommand get; and __fish_seen_subcommand_from item" -s n -l name -r
complete -c spotify_player -n "__fish_spotify_player_using_subcommand get; and __fish_seen_subcommand_from item" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand get; and __fish_seen_subcommand_from help" -f -a "key" -d 'Get data by key'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand get; and __fish_seen_subcommand_from help" -f -a "item" -d 'Get a Spotify item\'s data'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand get; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a "start" -d 'Start a new playback'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a "play-pause" -d 'Toggle between play and pause'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a "play" -d 'Resume the current playback if stopped'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a "pause" -d 'Pause the current playback if playing'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a "next" -d 'Skip to the next track'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a "previous" -d 'Skip to the previous track'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a "shuffle" -d 'Toggle the shuffle mode'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a "repeat" -d 'Cycle the repeat mode'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a "volume" -d 'Set the volume percentage'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a "seek" -d 'Seek by an offset milliseconds'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from start" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from start" -f -a "context" -d 'Start a context playback'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from start" -f -a "track" -d 'Start playback for a track'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from start" -f -a "liked" -d 'Start a liked tracks playback'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from start" -f -a "radio" -d 'Start a radio playback'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from start" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from play-pause" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from play" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from pause" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from next" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from previous" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from shuffle" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from repeat" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from volume" -l offset -d 'Increase the volume percent by an offset'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from volume" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from seek" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from help" -f -a "start" -d 'Start a new playback'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from help" -f -a "play-pause" -d 'Toggle between play and pause'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from help" -f -a "play" -d 'Resume the current playback if stopped'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from help" -f -a "pause" -d 'Pause the current playback if playing'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from help" -f -a "next" -d 'Skip to the next track'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from help" -f -a "previous" -d 'Skip to the previous track'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from help" -f -a "shuffle" -d 'Toggle the shuffle mode'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from help" -f -a "repeat" -d 'Cycle the repeat mode'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from help" -f -a "volume" -d 'Set the volume percentage'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from help" -f -a "seek" -d 'Seek by an offset milliseconds'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playback; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand connect" -s i -l id -r
complete -c spotify_player -n "__fish_spotify_player_using_subcommand connect" -s n -l name -r
complete -c spotify_player -n "__fish_spotify_player_using_subcommand connect" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand like" -s u -l unlike -d 'Unlike the currently playing track'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand like" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand authenticate" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a "new" -d 'Create a new playlist'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a "delete" -d 'Delete a playlist'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a "import" -d 'Imports all songs from a playlist into another playlist.'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a "list" -d 'Lists all user playlists.'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a "fork" -d 'Creates a copy of a playlist and imports it.'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a "sync" -d 'Syncs imports for all playlists or a single playlist.'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from new" -s p -l public -d 'Sets the playlist to public'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from new" -s c -l collab -d 'Sets the playlist to collaborative'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from new" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from import" -s d -l delete -d 'Deletes any previously imported tracks that are no longer in the imported playlist since last import.'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from import" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from fork" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from sync" -s d -l delete -d 'Deletes any previously imported tracks that are no longer in an imported playlist since last import.'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from sync" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from help" -f -a "new" -d 'Create a new playlist'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from help" -f -a "delete" -d 'Delete a playlist'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from help" -f -a "import" -d 'Imports all songs from a playlist into another playlist.'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from help" -f -a "list" -d 'Lists all user playlists.'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from help" -f -a "fork" -d 'Creates a copy of a playlist and imports it.'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from help" -f -a "sync" -d 'Syncs imports for all playlists or a single playlist.'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand playlist; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand generate" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand search" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a "get" -d 'Get Spotify data'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a "playback" -d 'Interact with the playback'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a "connect" -d 'Connect to a Spotify device'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a "like" -d 'Like currently playing track'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a "authenticate" -d 'Authenticate the application'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a "playlist" -d 'Playlist editing'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a "generate" -d 'Generate shell completion for the application CLI'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a "search" -d 'Search spotify'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from get" -f -a "key" -d 'Get data by key'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from get" -f -a "item" -d 'Get a Spotify item\'s data'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playback" -f -a "start" -d 'Start a new playback'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playback" -f -a "play-pause" -d 'Toggle between play and pause'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playback" -f -a "play" -d 'Resume the current playback if stopped'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playback" -f -a "pause" -d 'Pause the current playback if playing'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playback" -f -a "next" -d 'Skip to the next track'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playback" -f -a "previous" -d 'Skip to the previous track'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playback" -f -a "shuffle" -d 'Toggle the shuffle mode'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playback" -f -a "repeat" -d 'Cycle the repeat mode'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playback" -f -a "volume" -d 'Set the volume percentage'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playback" -f -a "seek" -d 'Seek by an offset milliseconds'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playlist" -f -a "new" -d 'Create a new playlist'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playlist" -f -a "delete" -d 'Delete a playlist'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playlist" -f -a "import" -d 'Imports all songs from a playlist into another playlist.'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playlist" -f -a "list" -d 'Lists all user playlists.'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playlist" -f -a "fork" -d 'Creates a copy of a playlist and imports it.'
complete -c spotify_player -n "__fish_spotify_player_using_subcommand help; and __fish_seen_subcommand_from playlist" -f -a "sync" -d 'Syncs imports for all playlists or a single playlist.'
