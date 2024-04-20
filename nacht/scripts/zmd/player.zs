class zmd_Player : DoomPlayer {
    const regularHealthMin = 150;
    const juggHealthMin = 0;

    int healthMin;

    int maxWeaponCount;
    Array<Weapon> heldWeapons;
    Array<String> perks;
    Array<zmd_HudItem> hudItems;
    bool justTookDamage;

    bool fastReload;
    bool doubleFire;

    zmd_HintHud hintHud;
    zmd_PointsHud pointsHud;
    zmd_PowerupHud powerupHud;
    zmd_PerkHud perkHud;
    zmd_ReviveHud reviveHud;

    Default {
        Player.StartItem 'Colt';
        Player.StartItem 'ColtAmmo', 32;
        Player.startItem 'zmd_Points', 500;
        Player.StartItem 'zmd_Regen';
        Player.StartItem 'NTM_QuickMelee';
        Player.StartItem 'zmd_InventoryManager';
        Player.StartItem 'zmd_PickupDropper';

        Player.WeaponSlot 1, 'Raygun', 'Colt', 'Ppsh', 'M1Garand', 'DoubleBarrelShotgun', 'Magnum', 'Thompson';

        Player.maxHealth 250;
    }

    override void beginPlay() {
        super.beginPlay();

        self.healthMin = regularHealthMin;
        self.maxWeaponCount = 2;
        self.justTookDamage = false;

        self.hintHud = zmd_HintHud(self.giveHud('zmd_HintHud'));
        self.pointsHud = zmd_PointsHud(self.giveHud('zmd_PointsHud'));
        self.powerupHud = zmd_PowerupHud(self.giveHud('zmd_PowerupHud'));
        self.perkHud = zmd_PerkHud(self.giveHud('zmd_PerkHud'));
        self.reviveHud = zmd_ReviveHud(self.giveHud('zmd_ReviveHud'));
        self.giveHud('zmd_AmmoHud');
        self.giveHud('zmd_RoundHud');
    }

    override int damageMobJ(Actor inflictor, Actor source, int damage, Name meansOfDeath, int flags, double angle) {
        if (inflictor != self && self.health - damage <= self.healthMin) {
            console.printf("\cf"..self.player.getUserName().."\cj went down!");
            let worry = zmd_Worry(self.findInventory('zmd_Worry'));
            if (worry != null)
                worry.handler.deactivate();
            zmd_DownedPlayer.morphFrom(self);
            return 0;
        }
        self.justTookDamage = true;
        return super.damageMobJ(inflictor, source, damage, meansOfDeath, flags, angle);
    }

    zmd_HudItem giveHud(class<zmd_HudItem> hud) {
        self.a_giveInventory(hud);
        let item = zmd_HudItem(self.findInventory(hud));
        self.hudItems.push(item);
        return item;
    }

    bool atWeaponCapacity() {
        return self.heldWeapons.size() == self.maxWeaponCount;
    }

    bool purchase(int cost) {
        if (self.countInv('zmd_Points') >= cost) {
            self.takeInventory('zmd_Points', cost);
            self.pointsHud.addDecrease(cost);
            return true;
        }
        return false;
    }
}

class zmd_HintHud : zmd_HudItem {
    const fadeDelay = 40;
    const fadeTicks = 5;

    String message;
    int ticksLeft;
    double alpha;

    override void update() {
        if (self.ticksLeft != 0) {
            --self.ticksLeft;
            self.alpha = self.ticksLeft / double(self.fadeTicks);
        }
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        if (self.ticksLeft != 0)
            hud.drawString(hud.hintFont, self.message, (0, -42), hud.di_screen_center_bottom | hud.di_text_align_center, Font.cr_blue, alpha, scale: (1.5, 1.5));
    }

    void setMessage(String message) {
        self.message = message;
        self.ticksLeft = self.fadeDelay;
        self.alpha = 1.0;
    }

    void clearMessage() {
        self.ticksLeft = self.fadeTicks;
    }
}

class zmd_AmmoHud : zmd_HudItem {
    override void draw(zmd_Hud hud, int state, double tickFrac) {
        let ammo = hud.getCurrentAmmo();
        let weapon = zmd_Weapon(hud.cplayer.readyWeapon);
        if (ammo && weapon) {
            if (weapon.Default.activeAmmo > 0)
                hud.drawString(hud.defaultFont, weapon.activeAmmo..'/'..ammo.amount, (hud.right_margin, hud.bottom_margin), hud.di_screen_right_bottom | hud.di_text_align_right, Font.cr_green);
            else
                hud.drawString(hud.defaultFont, ''..ammo.amount, (hud.right_margin, hud.bottom_margin), hud.di_screen_right_bottom | hud.di_text_align_right, Font.cr_green);
        }
    }
}