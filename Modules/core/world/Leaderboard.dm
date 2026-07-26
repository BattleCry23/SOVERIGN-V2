/proc/GetLeaderboardValue(mob/M, var/stat_name)
	if(!M) return null

	switch(stat_name)
		if("total_rpps_gained")     return M.total_rpps_gained
		if("scouter_crushes")  return M.scouter_crushes
		if("mute_count")    return M.mute_count
		if("ban_count")     return M.ban_count

	return null
/proc/GetTopPlayersByStat(var/stat_name)
	var/list/entries = list()

	for(var/mob/M in players)
		if(!M || !M.client) continue

		var/value = GetLeaderboardValue(M, stat_name)
		if(!isnum(value)) value = 0

		entries += list(list("mob"=M, "value"=value))

	// Descending sort (manual)
	for(var/i=1 to entries.len)
		for(var/j=i+1 to entries.len)
			if(entries[j]["value"] > entries[i]["value"])
				var/tmp = entries[i]
				entries[i] = entries[j]
				entries[j] = tmp

	return entries


/proc/_SortLeaderboard(a, b, stat_name)
    return (b["value"] - a["value"])

/mob/proc/OpenLeaderboard(var/tab = "rpps")

    var/title = "Global Leaderboard"

    var/css = {"
    <style>
    body{
        background:linear-gradient(180deg,#0f1022,#15173a);
        font-family:Verdana;
        margin:0;
        padding:16px;
        color:white;
    }

    .header{
        font-size:22px;
        font-weight:bold;
        margin-bottom:12px;
        color:#7aa2ff;
    }

    .tabs{
        display:flex;
        gap:8px;
        margin-bottom:14px;
    }

    .tab{
        padding:8px 14px;
        border-radius:8px;
        background:#1c1f44;
        border:1px solid #2d3170;
        color:#ccc;
        text-decoration:none;
        transition:0.2s;
    }

    .tab:hover{
        background:#2a2f6e;
        color:white;
    }

    .tab.active{
        background:#3a41a8;
        color:white;
        box-shadow:0 0 10px rgba(90,120,255,0.6);
    }

    .panel{
        background:#141636;
        border:1px solid #2a2d66;
        border-radius:12px;
        padding:12px;
    }

    .row{
        display:flex;
        justify-content:space-between;
        padding:10px;
        border-bottom:1px solid #242760;
        transition:0.2s;
    }

    .row:hover{
        background:#1d2160;
    }

    .rank{
        color:#ffd54a;
        font-weight:bold;
        margin-right:8px;
    }

    .value{
        color:#00e0ff;
        font-weight:bold;
    }

    </style>
    "}

    var/tabs = {"
    <div class='tabs'>
        <a class='tab [tab=="rpps"?"active":""]' href='?src=\ref[src];lb=1;tab=rpps'>RPPs</a>
        <a class='tab [tab=="scouter"?"active":""]' href='?src=\ref[src];lb=1;tab=scouter'>Scouter Crushes</a>
        <a class='tab [tab=="mutes"?"active":""]' href='?src=\ref[src];lb=1;tab=mutes'>Mutes</a>
        <a class='tab [tab=="bans"?"active":""]' href='?src=\ref[src];lb=1;tab=bans'>Bans</a>
    </div>
    "}

    var/html = "<html><head>[css]</head><body>"
    html += "<div class='header'>[title]</div>"
    html += tabs
    html += "<div class='panel'>"

    var/list/data

    switch(tab)
        if("rpps")
            data = GetTopPlayersByStat("total_rpps_gained")
        if("scouter")
            data = GetTopPlayersByStat("scouter_crushes")
        if("mutes")
            data = GetTopPlayersByStat("mute_count")
        if("bans")
            data = GetTopPlayersByStat("ban_count")

    if(!data || !data.len)
        html += "<div>No data available.</div>"
    else
        var/rank = 1
        for(var/entry in data)
            if(rank > 20) break // top 20 cap

            var/mob/M = entry["mob"]
            var/value = entry["value"]

            html += {"
            <div class='row'>
                <div><span class='rank'>#[rank]</span> [M.key]</div>
                <div class='value'>[value]</div>
            </div>
            "}

            rank++

    html += "</div></body></html>"

    src << browse(html, "window=leaderboard;size=720x520")
