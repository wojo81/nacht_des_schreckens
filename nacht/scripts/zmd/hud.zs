class zmd_HudItem : Inventory {
    Default {
        Inventory.maxAmount 1;
        +Inventory.undroppable
        +Inventory.untossable
        +Inventory.persistentPower
    }

    virtual ui void draw(zmd_Hud hud, int state, double tickFrac) {}
    virtual void update() {}

    override void tick() {
        super.tick();
        self.update();
    }
}

class zmd_HudElement {
    virtual ui void draw(zmd_Hud hud, int state, double tickFrac) {}
    virtual void update() {}
}

class zmd_Hud : BaseStatusBar {
    const margin = 7;
    const bottom_margin = -margin - 12;
    const right_margin = -margin - 3;

    HudFont screamFont;
    HudFont defaultFont;
    HudFont hintFont;

    zmd_InventoryManager inventoryManager;

    const flashDelay = 35 * 2;
    int ticksSinceGameOver;
    double alpha;

    override void init() {
        self.screamFont = HudFont.create(bigfont, spacing: 2);
        self.defaultFont = HudFont.create(bigfont, spacing: 1);
        self.hintFont = HudFont.create(confont);
    }

    override void tick() {
        if (self.inventoryManager != null && self.inventoryManager.gameOver) {
            self.alpha = abs((self.ticksSinceGameOver++ % (self.flashDelay * 2) - self.flashDelay) / double(self.flashDelay));
        }
    }

    override void draw(int state, double ticFrac) {
        super.draw(state, ticFrac);
        self.beginHud();

        if (self.inventoryManager == null) {
            zmd_Intro(self.cplayer.mo.findInventory('zmd_Intro')).draw(self, state, ticFrac);
        } else if (self.inventoryManager.gameOver) {
            self.drawString(self.screamFont, 'Game Over', (0, 0), self.di_screen_center | self.di_text_align_center, translation: Font.cr_red, alpha: self.alpha);
        } else if (!self.inventoryManager.spectating) {
            let player = self.cplayer.mo;
            if (player is 'zmd_DownedPlayer') {
                self.inventoryManager.ammoHud.draw(self, state, ticFrac);
                self.inventoryManager.powerupHud.draw(self, state, ticFrac);
                Screen.dim("red", 0.4, 0, 0, Screen.getWidth(), Screen.getHeight());
            } else {
                foreach (hudItem : self.inventoryManager.hudItems)
                    hudItem.draw(self, state, ticFrac);
            }
        }
    }
}