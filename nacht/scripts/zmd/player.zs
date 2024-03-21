class zmd_Player : DoomPlayer {
    const regularHealthMin = 150;
    const juggHealthMin = 0;

    int healthMin;

    int weaponCount;
    int maxWeaponCount;
    Array<String> heldWeapons;
    Array<String> perks;
    bool justTookDamage;

    Array<zmd_HudElement> hudElements;
    zmd_PointsHud pointsHud;
    zmd_HintHud hintHud;
    zmd_ReviveHud reviveHud;
    zmd_PowerupHud powerupHud;
    zmd_PerkHud perkHud;
    zmd_RoundHud roundHud;

    Default {
        Player.StartItem 'Colt';
        Player.StartItem 'ColtAmmo', 40;
        Player.startItem 'zmd_Points', 500;
        Player.StartItem 'zmd_Regen';
        Player.StartItem 'NTM_QuickMelee';
        Player.StartItem 'zmd_InventoryManager';

        Player.WeaponSlot 1, 'Raygun', 'Colt', 'Ppsh', 'M1Garand', 'DoubleBarrelShotgun';

        Player.maxHealth 250;
    }

    override void beginPlay() {
        super.beginPlay();

        self.healthMin = regularHealthMin;
        self.weaponCount = 0;
        self.maxWeaponCount = 2;
        self.justTookDamage = false;

        let ammoHud = new('zmd_AmmoHud');
        self.pointsHud = new('zmd_PointsHud');
        self.hintHud = new('zmd_HintHud');
        self.powerupHud = new('zmd_PowerupHud');
        self.reviveHud = new('zmd_ReviveHud');
        self.perkHud = new('zmd_PerkHud');
        self.roundHud = zmd_RoundHud.create();

        self.hudElements.push(ammoHud);
        self.hudElements.push(self.pointsHud);
        self.hudElements.push(self.hintHud);
        self.hudElements.push(self.powerupHud);
        self.hudElements.push(self.reviveHud);
        self.hudElements.push(self.perkHud);
        self.hudElements.push(self.roundHud);
    }

    override int damageMobJ(Actor inflictor, Actor source, int damage, Name meansOfDeath, int flags, double angle) {
        if (inflictor != self && self.health - damage <= self.healthMin) {
            console.printf("\cf"..self.player.getUserName().."\cj went down!");
            zmd_DownedPlayer.morphFrom(self);
            return 0;
        }
        self.justTookDamage = true;
        return super.damageMobJ(inflictor, source, damage, meansOfDeath, flags, angle);
    }

    bool atWeaponCapacity() {
        if (self.weaponCount == self.maxWeaponCount)
            return true;
        ++self.weaponCount;
        return false;
    }

    void enableWeaponPerks() {
        if (self) {
            let useFastReload = self.countInv('zmd_SpeedCola') == 1;
            let useDoubleFire = self.countInv('zmd_DoubleTap') == 1;

            foreach (heldWeapon : heldWeapons) {
                let heldWeapon = zmd_Weapon(self.findInventory(heldWeapon));
                if (heldWeapon) {
                    heldWeapon.useFastReload = useFastReload;
                    heldWeapon.useDoubleFire = useDoubleFire;
                }
            }
        }
    }

    void disableWeaponPerks() {
        foreach (heldWeapon : self.heldWeapons) {
            let heldWeapon = zmd_Weapon(self.findInventory(heldWeapon));
            if (heldWeapon) {
                heldWeapon.useFastReload = false;
                heldWeapon.useDoubleFire = false;
            }
        }
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

class zmd_HintHud : zmd_HudElement {
    const fadeDelay = 40;
    const fadeTicks = 5;

    String message;
    int ticksLeft;
    double alpha;

    override void tick() {
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

class zmd_AmmoHud : zmd_HudElement {
    override void draw(zmd_Hud hud, int state, double tickFrac) {
        let ammo = hud.getCurrentAmmo();
        let weapon = zmd_Weapon(hud.cplayer.readyWeapon);
        if (ammo && weapon) {
            if (weapon.clipCapacity > 0)
                hud.drawString(hud.defaultFont, weapon.clipSize..'/'..ammo.amount, (hud.right_margin, hud.bottom_margin), hud.di_screen_right_bottom | hud.di_text_align_right, Font.cr_green);
            else
                hud.drawString(hud.defaultFont, ''..ammo.amount, (hud.right_margin, hud.bottom_margin), hud.di_screen_right_bottom | hud.di_text_align_right, Font.cr_green);
        }
    }
}