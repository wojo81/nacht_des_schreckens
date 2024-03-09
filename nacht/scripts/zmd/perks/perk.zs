class zmd_PerkMachine : zmd_Interactable {
    int cost;
    class<Inventory> perk;

    property cost: cost;
    property perk: perk;

    Default {
        radius 30;
        height 60;

        +solid
        +special
        +wallSprite
    }

    override void doTouch(zmd_Player player) {
        if (!player.countInv(self.perk))
            player.hintHud.setMessage(zmd_Interactable.costOf(self.cost));
    }

    override bool doUse(zmd_Player player) {
        if (!player.countInv(self.perk) && player.maybePurchase(self.cost)) {
            player.a_giveInventory('zmd_PerkBottle', 1);
            zmd_PerkBottle(player.findInventory('zmd_PerkBottle')).perk = self.perk;
            player.a_selectWeapon('zmd_PerkBottle');
            return true;
        }
        return false;
    }
}

class zmd_Perk : Inventory {
    Default {
        Inventory.maxAmount 1;
    }
}

class zmd_PerkBottle : Weapon {
    class<Inventory> perk;
    int tickCount;

    Default {
        Weapon.ammoType 'clip';
        Weapon.ammoGive 1;
        +Weapon.ammo_optional
    }

    action State maybeGivePerk() {
        if (invoker.tickCount++ == 70)
            return resolveState('GivePerk');
        return resolveState(null);
    }

    States {
    Ready:
        rayf a 1 a_weaponReady;
        rayf a 0 maybeGivePerk;
        loop;
    Select:
        rayf a 1 a_raise;
        wait;
    Deselect:
        rayf a 1 a_lower;
        rayf a 0 a_takeInventory('zmd_PerkBottle', 1);
        wait;
    Fire:
        rayf a 1 a_fireBullets(0.0, 0.0, 1, 99999);
        goto deselect;
    GivePerk:
        rayf a 0 a_giveInventory(invoker.perk, 1);
        goto Deselect;
    }
}

class zmd_PerkHud : zmd_HudElement {
    const offsetDelta = 13;

    Array<zmd_PerkIcon> icons;
    int offset;

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        foreach (icon : self.icons)
            icon.draw(hud, state, tickFrac);
    }

    void add(Inventory perk) {
        let perkIcon = new('zmd_PerkIcon');
        perkIcon.perk = perk;
        perkIcon.offset = self.offset;
        self.icons.push(perkIcon);
        self.offset += self.offsetDelta;
    }

    void clear() {
        self.icons.resize(0);
        self.offset = 0;
    }
}

class zmd_PerkIcon : zmd_HudElement {
    Inventory perk;
    int offset;

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        hud.drawInventoryIcon(self.perk, (15 + self.offset, -23), hud.di_screen_left_bottom, scale: (0.3, 0.3));
    }
}