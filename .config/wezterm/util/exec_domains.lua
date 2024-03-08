local wezterm = require("wezterm")

function docker_list()
	local success, stdout, stderr =
		wezterm.run_child_process({ "/usr/local/bin/docker", "container", "ls", "--format", "{{.ID}}:{{.Names}}" })
	-- when docker is not running, it returns "Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?"
	-- if #result == 1 and result[1] == 'Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?' then
	if success == false then
		print(stderr)
		return {}
	end
	-- stdout = "5cd129eedb84:ollama-webui\n3cd2a15c0186:ollama\n"
	-- local str = "5cd129eedb84:ollama-webui\n3cd2a15c0186:ollama\n"
	-- local pattern = "%w+:%w+"
	-- local matches = string.gmatch(str, "%w+:%w+")
	--
	-- for match in matches do
	--   print(match)
	-- end
	--
	-- local match1, match2, match3, match4 = str:match("(%w+):(%w+)(%w+):(%w+)")
	-- print(match1, match2, match3, match4)
	local lines = {}
	local containers = {}
	for line in stdout:gmatch("[%s][^\n]+") do
		table.insert(lines, line)
		local id, name = string.match(line, "^(%S+):(.+)$")
		-- if name = ollama-webui\n3cd2a15c0186:ollama\n
		if id and name then
			containers[id] = name
		end
	end
	return containers, lines

	-- Use wezterm.run_child_process to run
	-- `docker container ls --format '{{.ID}}:{{.Names}}'` and parse
	-- the output and return a mapping from ID -> name
end

function make_docker_fixup_func(id)
	return function(cmd)
		cmd.args = cmd.args or { "/bin/bash" }
		local wrapped = {
			"docker",
			"exec",
			"-it",
			id,
		}
		for _, arg in ipairs(cmd.args) do
			table.insert(wrapped, arg)
		end

		cmd.args = wrapped
		return cmd
	end
end

function make_docker_label_func(id)
	return function(name)
		-- TODO: query the container state and show info about
		-- whether it is running or stopped.
		-- If it stopped, you may wish to change the color to red
		-- to make it stand out
		return wezterm.format({
			{ Foreground = { AnsiColor = "Red" } },
			{ Text = "docker container named " .. name },
		})
	end
end

local exec_domains = {}
for id, name in pairs(docker_list()) do
	table.insert(
		exec_domains,
		wezterm.exec_domain("docker: " .. name, make_docker_fixup_func(id), make_docker_label_func(id))
	)
end

return exec_domains
