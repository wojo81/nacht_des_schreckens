class zmd_PerkMachine : zmd_Interactable {
    class<zmd_Drink> drink;
    int cost;

    property cost: cost;
    property drink: drink;

    Default {
        radius 30;
        height 80;

        +solid
        +special
        +wallSprite
    }

    override void doTouch(zmd_Player player) {
        if (player.findInventory(getDefaultByType(self.drink).perk) == null)
            player.hintHud.setMessage(self.costOf(self.cost));
    }

    override bool doUse(zmd_Player player) {
        return player.findInventory(getDefaultByType(self.drink).perk) == null && player.purchase(self.cost) && player.a_giveInventory(self.drink);
    }
}

class zmd_Perk : Inventory {
    Default {
        Inventory.maxAmount 1;
    }
}

class zmd_Drink : zmd_Weapon {
    readonly class<zmd_Perk> perk;

    property perk: perk;

    Default {
        Weapon.ammoType 'clip';
        Weapon.ammoGive 1;
        zmd_Weapon.reloadRate 2;
        +Weapon.ammo_optional
    }

    override void activateFastReload() {
        self.reloadRate = 1;
    }

    action State loadSprites(int index) {
        switch (index) {
        case 0:
            return resolveState('Sprites0');
        case 1:
            return resolveState('Sprites1');
        case 2:
            return resolveState('Sprites2');
        }
        return null;
    }

    States {
    Ready:
        tnt1 a 2;
        tnt1 a 0 loadSprites(0);
    Sprites0:
        #### abcdefghijklmnopqrstuvwxyz 2 {a_weaponReady(); fr();}
        tnt1 a 0 loadSprites(1);
    Sprites1:
        #### abcdefghijklmnopqrstuvwxyz 2 {a_weaponReady(); fr();}
        tnt1 a 0 loadSprites(2);
    Sprites2:
        #### abcdefghijkl 2 {a_weaponReady(); fr();}
        tnt1 a 0 a_giveInventory(invoker.perk);
        goto Deselect;
    Select:
        tnt1 a 0 a_raise;
        wait;
    Deselect:
        tnt1 a 0 a_takeInventory(invoker.getClassName(), 1);
        stop;
    Fire:
        tnt1 a 1 a_fireBullets(0.0, 0.0, 1, 99999);
        goto Deselect;
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