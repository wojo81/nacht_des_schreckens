class zmd_InventoryManager : Inventory {
    Default {
        Inventory.maxAmount 1;
        +Inventory.undroppable
        +Inventory.untossable
        +Inventory.persistentPower
    }

    override bool handlePickup(Inventory item) {
        let player = zmd_Player(owner);
        if (item is 'zmd_Drink') {
            let drink = zmd_Drink(item);
            if (player.fastReload)
                drink.activateFastReload();
        } else if (item is 'zmd_Perk') {
            player.perks.push(item.getClassName());
            player.perkHud.add(item);
        } else if (item is 'zmd_Weapon') {
            let weapon = zmd_Weapon(item);
            if (player) {
                if (player.fastReload)
                    weapon.activateFastReload();
                if (player.doubleFire)
                    weapon.activateDoubleFire();
                player.heldWeapons.push(weapon);
                if (player.atWeaponCapacity()) {
                    let removedWeapon = player.player.readyWeapon;
                    let removedWeaponClass = removedWeapon.getClassName();
                    player.heldWeapons.delete(player.heldWeapons.find(removedWeapon));
                    owner.takeInventory(removedWeaponClass, 1);
                    owner.takeInventory(removedWeaponClass..'Ammo', 999);
                }
            }
        }
        return super.handlePickup(item);
    }
}