class zmd_InventoryManager : Inventory {
    Default {
        Inventory.maxAmount 1;
        +Inventory.undroppable
        +Inventory.untossable
        +Inventory.persistentPower
    }

    override bool handlePickup(Inventory item) {
        if (item is 'zmd_Perk') {
            let player = zmd_Player(owner);
            player.perks.push(item.getClassName());
            player.perkHud.add(item);
        } if (item is 'Weapon' && !(item is 'zmd_PerkBottle')) {
            let player = zmd_Player(owner);
            if (player) {
                player.heldWeapons.push(item.getClassName());
                if (player.atWeaponCapacity()) {
                    let removedWeaponName = owner.player.readyWeapon.getClassName();
                    player.heldWeapons.delete(player.heldWeapons.find(removedWeaponName));
                    owner.takeInventory(removedWeaponName, 1);
                    owner.takeInventory(removedWeaponName..'Ammo', 999);
                }
            }
        }
        return super.handlePickup(item);
    }
}