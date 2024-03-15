class zmd_DropPool : EventHandler {
    const dropsPerRound = 4;
    const dropChance = 7;

    Array<class<zmd_Drop> > fullPool;
    Array<class<zmd_Drop> > pool;
    int dropsLeft;

    static zmd_DropPool fetch() {
        return zmd_DropPool(EventHandler.find('zmd_DropPool'));
    }

    override void worldLoaded(WorldEvent e) {
        self.add('zmd_Instakill');
        self.add('zmd_DoublePoints');
        self.add('zmd_MaxAmmo');
        self.add('zmd_Kaboom');
        // self.add('zmd_FireSale');
        self.fill();
    }

    void add(class<zmd_Drop> drop) {
        self.fullPool.push(drop);
    }

    void fill() {
        self.pool.copy(self.fullPool);
    }

    void handleRoundChange() {
        self.dropsLeft = 4;
    }

    class<zmd_Drop> choose() {
        if (self.dropsLeft != 0 && random[randomSpawning](1, self.dropChance) == 1) {
            --self.dropsLeft;
            let index = random[randomSpawning](0, self.pool.size() - 1);
            let drop = self.pool[index];
            self.pool.delete(index);
            if (self.pool.size() == 0)
                self.fill();
            return drop;
        }
        return null;
    }
}

class zmd_Powerup : Powerup {
    Default {
        Powerup.duration -30;
        +Inventory.alwaysPickup
    }

    override TextureId getPowerupIcon() {
        return self.altHudIcon;
    }

    override bool tryPickup(in out Actor toucher) {
        let player = zmd_Player(toucher);
        if (player)
            player.powerupHud.add(self, self.effectTics);
        return super.tryPickup(toucher);
    }
}

class zmd_Drop : CustomInventory {
    Default {
        Inventory.pickupMessage '';
        Inventory.pickupSound 'game/powerup_grab';
        -floatBob
        +noGravity
    }

    action void giveAll(class<Inventory> item, int amount = 1) {
        foreach (player : players)
            if (player.mo != null)
                player.mo.giveInventory(item, amount);
    }
}

class zmd_PowerupHud : zmd_HudElement {
    const offsetDelta = 13;

    Array<zmd_PowerupIcon> icons;

    override void tick() {
        for (let i = 0; i != icons.size(); ++i) {
            let icon = icons[i];
            icon.tick();
            if (icon.ticksLeft == 0) {
                icons.delete(i);
                for (let j = 0; j != i; ++j)
                    icons[j].offset += self.offsetDelta;
                for (let j = i; j != icons.size(); ++j)
                    icons[j].offset -= self.offsetDelta;
                --i;
            }
        }
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        foreach (icon : self.icons)
            icon.draw(hud, state, tickFrac);
    }

    void add(Inventory powerup, int ticksLeft) {
        for (int i = 0; i != self.icons.size(); ++i) {
            let icon = self.icons[i];
            if (powerup.getClass() == icon.powerup.getClass()) {
                icon.reset(ticksLeft);
                for (int j = 0; j != i; ++j)
                    self.icons[j].offset += self.offsetDelta;
                return;
            }
            icon.offset -= self.offsetDelta;
        }
        if (self.icons.size() == 0)
            self.icons.push(zmd_PowerupIcon.create(powerup, 0, ticksLeft));
        else
            self.icons.push(zmd_PowerupIcon.create(powerup, self.icons[self.icons.size() - 1].offset + 2 * self.offsetDelta, ticksLeft));
    }
}

class zmd_PowerupIcon : zmd_HudElement {
    Inventory powerup;
    int offset;
    int ticksLeft;

    static zmd_PowerupIcon create(Inventory powerup, int offset, int ticksLeft) {
        let icon = new('zmd_PowerupIcon');
        icon.powerup = powerup;
        icon.offset = offset;
        icon.ticksLeft = ticksLeft;
        return icon;
    }

    override void tick() {
        --self.ticksLeft;
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        if (self.powerup && !Powerup(self.powerup).isBlinking())
            hud.drawInventoryIcon(self.powerup, (self.offset, -3), hud.di_screen_center_bottom | hud.di_item_center_bottom, scale: (0.5, 0.5));
    }

    void reset(int ticksLeft) {
        self.ticksLeft = ticksLeft;
    }
}