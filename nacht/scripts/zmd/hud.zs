class zmd_HudItem : Inventory {
    virtual ui void draw(zmd_Hud hud, int state, double tickFrac) {}
    virtual void update() {}

    override void tick() {
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

    HudFont defaultFont;
    HudFont hintFont;

    override void init() {
        self.defaultFont = HudFont.create(bigfont);
        self.hintFont = HudFont.create(confont);
    }

    override void draw(int state, double ticFrac) {
        super.draw(state, ticFrac);
        self.beginHud();
        let player = zmd_Player(self.cplayer.mo);
        if (player)
            foreach (item : player.hudItems) {
                item.draw(self, state, ticFrac);
            }
        else {
            let player = zmd_DownedPlayer(self.cplayer.mo);
            if (player) {
                player.ammoHud.draw(self, state, ticFrac);
                player.powerupHud.draw(self, state, ticFrac);
                Screen.dim("red", 0.4, 0, 0, Screen.getWidth(), Screen.getHeight());
            }
        }
    }
}