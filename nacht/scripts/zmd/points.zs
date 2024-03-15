class zmd_Points : Inventory {
    Default {
        Inventory.maxAmount 999999;
    }

    override void setGiveAmount(Actor receiver, int amount, bool giveCheat) {
        let givenAmount = amount << receiver.countInv('zmd_DoublePointsPowerup');
        let player = zmd_Player(receiver);
        if (player)
            player.pointsHud.addIncrease(givenAmount);
        super.setGiveAmount(receiver, givenAmount, giveCheat);
    }
}

class zmd_PointsHud : zmd_HudElement {
    Array<zmd_PointDelta> pointDeltas;

    override void tick() {
        while (self.pointDeltas.size() && self.pointDeltas[0].ticksLeft == 0)
            self.pointDeltas.delete(0);
        foreach (pointDelta : self.pointDeltas)
            pointDelta.tick();
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        hud.drawString(hud.defaultFont, ''..hud.cplayer.mo.countInv('zmd_Points'), (hud.margin, hud.bottom_margin), hud.di_screen_left_bottom, Font.cr_sapphire);
        foreach (pointDelta : self.pointDeltas)
            pointDelta.draw(hud, state, tickFrac);
    }

    void addIncrease(int value) {
        let pointIncrease = new('zmd_PointIncrease');
        pointIncrease.init(value);
        self.pointDeltas.push(pointIncrease);
    }

    void addDecrease(int value) {
        let pointDecrease = new('zmd_PointDecrease');
        pointDecrease.init(value);
        self.pointDeltas.push(pointDecrease);
    }
}

class zmd_PointDelta : zmd_HudElement {
    int value;
    vector2 position;
    vector2 velocity;
    int ticksLeft;
    double alpha;

    virtual void init(int value) {
        self.value = value;
        self.position = (45, -13);
        self.ticksLeft = 70;
        self.alpha = 1.0;
    }

    override void tick() {
        self.position += self.velocity;
        --self.ticksLeft;
        self.alpha = self.ticksLeft / 15.0;
    }
}

class zmd_PointIncrease : zmd_PointDelta {
    override void init(int value) {
        super.init(value);
        self.velocity = (frandom[pointIncrease](0.4, 1.4), frandom[pointIncrease](-0.4, 0.2));
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        hud.drawString(hud.defaultFont, '+'..self.value, self.position, hud.di_screen_left_bottom, Font.cr_gold, alpha, scale: (0.5, 0.5));
    }
}

class zmd_PointDecrease : zmd_PointDelta {
    override void init(int value) {
        super.init(value);
        self.velocity = (0, 0.1);
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        hud.drawString(hud.defaultFont, '-'..self.value, self.position, hud.di_screen_left_bottom, Font.cr_red, alpha, scale: (0.5, 0.5));
    }
}