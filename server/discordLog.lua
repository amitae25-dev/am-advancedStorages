Server = {}
Server.Webhooks = {
    ['purchase_storage'] = 'YOUR_WEBHOOK_HERE',
    ['upgrade_storage'] = 'YOUR_WEBHOOK_HERE',
    ['sell_storage'] = 'YOUR_WEBHOOK_HERE',
    ['enter_exit'] = 'YOUR_WEBHOOK_HERE',
    ['open_stash'] = 'YOUR_WEBHOOK_HERE',
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


 
