--http://regex.info/blog/lua/json
local JSON = require("JSON")

function probe()
	--Trying to catch any json input from playing.
	if string.match( vlc.path, "ttl=" ) or 
	string.match( vlc.path, "hash=" ) or 
	string.match( vlc.path, ".mp4" ) or
	string.match( vlc.path, ".m3u8" ) or
	string.match( vlc.path, "youtube.com" ) or
	string.match( vlc.path, "youtu.be" ) or
	string.match( vlc.path, "twitch.tv" ) or
	string.match( vlc.path, "dailymotion.com" ) or
	string.match( vlc.path, "soundcloud.com" )
	then
		return false
	end
	if vlc.access == "http" or vlc.access == "https"
	then
		return true
	else
		return false
	end  
end

function parse()
	local url = vlc.access .. "://" .. vlc.path

	local file = assert(io.popen('youtube-dl -j '..url))
	local output = trim1(file:read('*all'))
	file:close()

  local input = JSON:decode(output)

  if input then
	return { { path = input.url; name = input.title;} }
  end
end

function trim1(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
