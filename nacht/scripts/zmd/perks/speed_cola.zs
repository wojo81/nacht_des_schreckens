class zmd_SpeedColaMachine : zmd_PerkMachine {
    Default {
        zmd_PerkMachine.cost 3000;
        zmd_PerkMachine.drink 'zmd_SpeedColaDrink';
    }

    States {
    Spawn:
        spca a 1;
        loop;
    }
}

class zmd_SpeedColaDrink : zmd_Drink {
    Default {
        zmd_Drink.perk 'zmd_SpeedCola';
        tag 'Speed Cola';
    }

    States {
    Sprites:
        ds0c a 0;
        ds1c a 0;
        ds2c a 0;
    Spawn:
        sca0 a -1;
        loop;
    }
}

class zmd_SpeedCola : zmd_Perk {
    Default {
        Inventory.icon 'scic';
    }

    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        zmd_InventoryManager(self.owner.findInventory('zmd_InventoryManager')).activateFastReload();
    }

    override void detachFromOwner() {
        zmd_InventoryManager(self.owner.findInventory('zmd_InventoryManager')).deactivateFastReload();
        super.detachFromOwner();
    }
}