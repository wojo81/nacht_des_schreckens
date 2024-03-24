class zmd_InventoryManager : Inventory {
    Default {
        Inventory.maxAmount 1;
        +Inventory.undroppable
        +Inventory.untossable
        +Inventory.persistentPower
    }

    override bool handlePickup(Inventory item) {
        if (item is 'zmd_Drink') {
            let player = zmd_Player(owner);
            let drink = zmd_Drink(item);
            if (player.fastReload)
                drink.activateFastReload();
            return super.handlePickup(item);
        }

        if (item is 'zmd_Perk') {
            let player = zmd_Player(owner);
            player.perks.push(item.getClassName());
            player.perkHud.add(item);
        } if (item is 'zmd_Weapon') {
            let player = zmd_Player(owner);
            let weapon = zmd_Weapon(item);
            if (player) {
                if (player.fastReload)
                    weapon.activateFastReload();
                if (player.doubleFire)
                    weapon.activateDoubleFire();
                player.heldWeapons.push(weapon);
                if (player.atWeaponCapacity()) {
                    let removedWeapon = player.heldWeapons[player.heldWeapons.size() - 1];
                    player.heldWeapons.delete(player.heldWeapons.find(removedWeapon));
                    owner.takeInventory(removedWeapon.getClass(), 1);
                    owner.takeInventory(removedWeapon.getClass()..'Ammo', 999);
                }
            }
        }
        return super.handlePickup(item);
    }
}