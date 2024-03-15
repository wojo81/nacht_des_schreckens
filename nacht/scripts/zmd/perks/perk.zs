class zmd_PerkMachine : zmd_Interactable {
    class<zmd_Perk> perk;
    int cost;

    property cost: cost;
    property perk: perk;

    Default {
        radius 30;
        height 80;

        +solid
        +special
        +wallSprite
    }

    override void doTouch(zmd_Player player) {
        if (player.countInv(self.perk) == 0 && player.countInv('zmd_PerkBottle') == 0)
            player.hintHud.setMessage(self.costOf(self.cost));
    }

    override bool doUse(zmd_Player player) {
        if (player.countInv(self.perk) == 0 && player.countInv('zmd_PerkBottle') == 0 && player.purchase(self.cost)) {
            zmd_PerkBottle.giveTo(player, self.perk);
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
    class<zmd_Perk> perk;
    int ticksLeft;

    Default {
        Weapon.ammoType 'clip';
        Weapon.ammoGive 1;
        +Weapon.ammo_optional
    }

    static void giveTo(zmd_Player player, class<zmd_Perk> perk) {
        player.a_giveInventory('zmd_PerkBottle', 1);
        let self = zmd_PerkBottle(player.findInventory('zmd_PerkBottle'));
        self.perk = perk;
        self.ticksLeft = 70;
        player.a_selectWeapon('zmd_PerkBottle');
    }

    override void tick() {
        super.tick();
        if (self.ticksLeft-- == 0) {
            self.owner.giveInventory(self.perk, 1);
            self.setStateLabel('Deselect');
        }
    }

    States {
    Ready:
        rayf a 1 a_weaponReady;
        loop;
    Select:
        rayf a 1 a_raise;
        wait;
    Deselect:
        tnt1 a 0;
        stop;
    Fire:
        rayf a 1 a_fireBullets(0.0, 0.0, 1, 99999);
        goto deselect;
    }
}

class zmd_PerkHud : zmd_HudElement {
    const offsetDelta = 15;

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