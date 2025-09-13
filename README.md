
# Advanced Storages

With this script your players can buy their own warehouse with storage(es). After entering the warehouse, the player will be teleported to an interior. Inside, they can find their storage(es) and their management point. In the management point they can upgrade their warehouse. With each upgrade the storage grow and you can place more items into them. Some levels also come with new interiors. All the used interiors are from the base game.




# Installation

1. Download the latest release from github.
2. Unzip and install the script between your server scripts.
3. Make sure to ensure the script in your `server.cfg`
4. After the first start you need to restart your server because of the SQL
    
## Requirements

1. [ox_inventory](https://github.com/communityox/ox_inventory/releases)
2. [ox_target](https://github.com/communityox/ox_target/releases)
3. [ox_lib](https://github.com/communityox/ox_lib/releases)

## Customization
You can customize the script as you want.

### Client
You can find every customizable options in `shared/main.lua` and `shared/locales.lua` for the locales.

### Server 
If you want to setup discord log you need to insert the discord webhooks in `server/discordLog.lua`. You can set the same or different webhooks for each option. 
## API Reference

#### Is player inside a warehouse

```lua
  local inside = exports["am-advancedStorages"]:isPlayerInside()
```

| Return | Type     | Description                |
| :-------- | :------- | :------------------------- |
| Yes | `boolean` | Return if the player is inside a warehouse |

## Feedback / Bug report

If you have any feedback, please reach out to me:
- Discord: amitae_

### Changelog:

v1.1:
- Shared option:
  - Now you can add your friends to your warehouse
  - Your friends can enter your warehouse and open your storages
  - In the indoor management point you can add / remove anybody

- Future Plans:
  - Park In option
  - Robbery option
  - Police razzia option

v1.2:
- Targeting system:
  - Now you can choose to use the ox_target for the indoor actions
  - It lowers the resmon and more estatic
  - For the storages it spawn objects to target
  - The objects size is depends on the storage level

- Park In:
  - Now you can park inside with your car for easier depo
  - There is a new zone outside (in front of the garage door), next to the NPC where you can enter the warehouse with a vehicle
  - You can only enter the warehouse with a vehicle from warehouse level 4 (or you can edit this in the config)
  - Only one vehicle can fit inside the warehouse, you can not enter with multiple vehicles

- Future Plans:
  - Robbery option
  - Police razzia option
