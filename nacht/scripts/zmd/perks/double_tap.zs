class zmd_DoubleTapMachine : zmd_PerkMachine {
    Default {
        zmd_PerkMachine.cost 4000;
        zmd_PerkMachine.drink 'zmd_DoubleTapDrink';
    }

    States {
    Spawn:
        dbtp a 1;
        loop;
    }
}

class zmd_DoubleTapDrink : zmd_Drink {
    Default {
        zmd_Drink.perk 'zmd_DoubleTap';
        tag 'Double Tap';
    }

    States {
    Sprites:
        dd0t a 0;
        dd1t a 0;
        dd2t a 0;
    Spawn:
        dta0 a -1;
        loop;
    }
}

class zmd_DoubleTap : zmd_Perk {
    Default {
        Inventory.icon 'dtic';
    }

    override void modifyDamage(int damage, Name damageType, out int newDamage, bool passive, Actor inflictor, Actor source, int flags) {
        if (inflictor != null && !inflictor.bmissile && !passive && source != self.owner) {
            newDamage = damage * 2;
        }
    }

    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        zmd_InventoryManager(self.owner.findInventory('zmd_InventoryManager')).activateDoubleFire();
    }

    override void detachFromOwner() {
        zmd_InventoryManager(self.owner.findInventory('zmd_InventoryManager')).deactivateDoubleFire();
        super.detachFromOwner();
    }
}