class zmd_Player : DoomPlayer {
    const liveTid = 15;
    const regularHealthMin = 150;
    const juggHealthMin = 0;

    bool fastReload;
    bool doubleFire;

    Default {
        Player.displayName 'Marine (ZMD)';
        Player.StartItem 'zmd_Colt';
        Player.StartItem 'zmd_ColtAmmo', 32;
        Player.StartItem 'NTM_QuickMelee';

        Player.WeaponSlot 1, 'zmd_Raygun', 'zmd_Colt', 'zmd_Ppsh', 'zmdM1Garand', 
			'zmd_DoubleBarrelShotgun', 'zmd_Magnum', 'zmd_Thompson', 'zmd_Kar98', 
			'zmd_Carbine', 'zmd_Type100';
    }
}

class zmd_HintHud : zmd_HudItem {
    const fadeDelay = 40;
    const fadeTicks = 5;

    String message;
    int ticksLeft;
    int alpha;

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

    action void setMessage(String message) {
        invoker.message = message;
        invoker.ticksLeft = invoker.fadeDelay;
        invoker.alpha = 1.0;
    }

    void clearMessage() {
        self.ticksLeft = self.fadeTicks;
    }
}

class zmd_AmmoHud : zmd_HudItem {
    override void draw(zmd_Hud hud, int state, double tickFrac) {
        let ammo = hud.getCurrentAmmo();
        let weapon = hud.cplayer.readyWeapon;
        let zweapon = zmd_Weapon(weapon);
        if (ammo != null) {
            if (zweapon && zweapon.Default.activeAmmo > 0)
                hud.drawString(hud.defaultFont, zweapon.activeAmmo..'/'..ammo.amount, (hud.right_margin, hud.bottom_margin), hud.di_screen_right_bottom | hud.di_text_align_right, Font.cr_green);
            else
                hud.drawString(hud.defaultFont, ''..ammo.amount, (hud.right_margin, hud.bottom_margin), hud.di_screen_right_bottom | hud.di_text_align_right, Font.cr_green);
        }
    }
}