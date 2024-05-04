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

    override void doTouch(PlayerPawn player) {
        if (player.countInv(self.drink) == 0 && player.findInventory(getDefaultByType(self.drink).perk) == null)
            zmd_HintHud(player.findInventory('zmd_HintHud')).setMessage(self.costOf(self.cost));
    }

    override bool doUse(PlayerPawn player) {
        if (player.countInv(self.drink) == 0 && player.findInventory(getDefaultByType(self.drink).perk) == null && zmd_Points.takeFrom(player, self.cost) && player.a_giveInventory(self.drink)) {
            self.a_startSound("game/purchase");
            player.a_selectWeapon(self.drink);
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

class zmd_Drink : zmd_Weapon {
    readonly class<zmd_Perk> perk;
    readonly class<zmd_Bottle> bottle;
    int sprites[3];
    bool isEmpty;

    property perk: perk;
    property bottle: bottle;

    Default {
        Weapon.ammoType 'zmd_DrinkAmmo';
        Weapon.ammoGive 1;
        zmd_Weapon.reloadFrameRate 2;
    }

    override void beginPlay() {
        let state = self.findState('Sprites');
        self.sprites[0] = state.sprite;
        self.sprites[1] = state.nextState.sprite;
        self.sprites[2] = state.nextState.nextState.sprite;
    }

    action void loadSprites(int index) {
        self.player.findPSprite(psp_weapon).sprite = invoker.sprites[index];
    }

    action void rfr() {
        a_weaponReady();
        fr();
    }

    action void givePerk() {
        if (!invoker.isEmpty) {
            self.a_startSound("game/swallow2");
            self.giveInventory(invoker.perk, 1);
            invoker.isEmpty = true;
        }
    }

    action void finish() {
        self.takeInventory(invoker.ammoType1, 1);
        self.takeInventory(invoker.getClass(), 1);
    }

    States {
    Ready:
        tnt1 a 0 loadSprites(0);
        #### abcdefghijklmnopqrstuvwxyz 2 rfr;
        tnt1 a 0 loadSprites(1);
        #### abcdefghi 2 rfr;
        #### a 0 givePerk;
        #### jklmnopqrstuvwxyz 2 rfr;
        tnt1 a 0 loadSprites(2);
        #### ab 2 rfr;
        tnt1 a 0 {invoker.a_startSound("game/bottle_break");}
        goto Deselect;
    Select:
        tnt1 a 0 a_raise;
        wait;
    Deselect:
        tnt1 a 0 finish;
        stop;
    Fire:
        tnt1 a 0 shootProjectile(invoker.bottle);
        goto Deselect;
    }
}

class zmd_DrinkAmmo : Ammo {
    Default {
        Inventory.maxAmount 1;
    }
}

class zmd_Bottle : Rocket {
    Name spriteName;

    property sprite: spriteName;

    Default {
        scale 0.5;
        health 1;
        radius 5;
        height 5;
        speed 25;
        damage 300;
        damageType 'Bottle';
        seeSound '';
        deathSound 'game/bottle_break';
        gravity 0.5;

        +flatSprite
        -rocketTrail
        -nogravity
    }

    override void beginPlay() {
        self.sprite = Actor.getSpriteIndex(self.spriteName);
    }

    action void spin() {
        invoker.pitch += 25;
    }

    States {
    Spawn:
        #### a 1 spin;
        loop;
    Death:
        tnt1 a 0;
        stop;
    }
}

class zmd_PerkHud : zmd_HudItem {
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