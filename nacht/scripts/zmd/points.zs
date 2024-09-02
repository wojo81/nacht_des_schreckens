class zmd_Points : Inventory {
    zmd_PointsHud hud;

    Default {
        Inventory.maxAmount 999999;
        +Inventory.undroppable;
    }

    static bool takeFrom(PlayerPawn player, int cost) {
        if (player.countInv('zmd_Points') >= cost) {
            player.takeInventory('zmd_Points', cost);
            zmd_PointsHud(player.findInventory('zmd_PointsHud')).addDecrease(cost);
            return true;
        }
        return false;
    }

    override void attachToOwner(Actor owner) {
        super.attachToOwner(owner);
        self.hud = zmd_PointsHud(owner.findInventory('zmd_PointsHud'));
    }

    override void setGiveAmount(Actor receiver, int amount, bool giveCheat) {
        if (!giveCheat)
            amount <<= receiver.countInv('zmd_DoublePointsPower');
        else if (amount == 1)
            amount = 10000;

        zmd_PointsHud(receiver.findInventory('zmd_PointsHud')).addIncrease(amount);
        super.setGiveAmount(receiver, amount, giveCheat);
    }
}

class zmd_PointsHandler : EventHandler {
    override void worldThingDamaged(WorldEvent e) {
        if (e.damageSource is 'PlayerPawn' && e.thing.bisMonster && e.damageType != 'None') {
            e.damageSource.giveInventory('zmd_Points', 10);

            if (e.thing.health <= 0 || e.damageSource.countInv('zmd_InstakillPower') != 0) {
                if (e.damageType == 'bottle')
                    e.damageSource.giveInventory('zmd_Points', 150);
                else if (e.damageType == 'kick')
                    e.damageSource.giveInventory('zmd_Points', 120);
                else if (e.damageType == 'zmd_headshot')
                    e.damageSource.giveInventory('zmd_points', 100);
                else
                    e.damageSource.giveInventory('zmd_points', 50);
            }
        }
    }
}

class zmd_PointsHud : zmd_HudItem {
    Array<zmd_PointDelta> pointDeltas;

    override void update() {
        while (self.pointDeltas.size() && self.pointDeltas[0].ticksLeft == 0)
            self.pointDeltas.delete(0);
        foreach (pointDelta : self.pointDeltas)
            pointDelta.update();
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
    int color;
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

    override void update() {
        self.position += self.velocity;
        --self.ticksLeft;
        self.alpha = self.ticksLeft / 15.0;
    }
}

class zmd_PointIncrease : zmd_PointDelta {
    override void init(int value) {
        super.init(value);
        if (value < 50)
            self.color = Font.cr_gold;
        else if (value < 100)
            self.color = Font.cr_orange;
        else if (value < 120)
            self.color = Font.cr_red;
        else
            self.color = Font.cr_purple;
        self.velocity = (frandom[pointIncrease](0.4, 1.4), frandom[pointIncrease](-0.4, 0.2));
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        hud.drawString(hud.defaultFont, '+'..self.value, self.position, hud.di_screen_left_bottom, self.color, alpha, scale: (0.5, 0.5));
    }
}

class zmd_PointDecrease : zmd_PointDelta {
    override void init(int value) {
        super.init(value);
        self.color = Font.cr_darkRed;
        self.velocity = (0, 0.1);
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        hud.drawString(hud.defaultFont, '-'..self.value, self.position, hud.di_screen_left_bottom, self.color, alpha, scale: (0.5, 0.5));
    }
}