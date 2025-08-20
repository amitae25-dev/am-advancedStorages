Server = {}
Server.Webhooks = {
    ['purchase_storage'] = ,
    ['upgrade_storage'] = ,
    ['sell_storage'] = ,
    ['enter_exit'] = ,
    ['open_stash'] = ,
}


function DiscordLog(message, webhook)
    if not webhook then 
        print("^2[am_storages]^7 Couldn\'t send discord log, because the webhook is invalid!")
    end
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = Config.Translate['bot_username'],
        avatar_url = "https://i.imgur.com/PdV59tQ.png",
        embeds = { {
          color = 65280,
          fields = { {
            value = message,
            inline = true
          }},
          footer = {
            text = string.format(Config.Translate['bot_footer'], os.date('%c')),
          }
        }
    }
}), { ['Content-Type'] = 'application/json' })
end

 