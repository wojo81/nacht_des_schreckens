class zmd_Intro : zmd_HudItem {
    const skipKey = bt_user1;
    const flashDelay = 35 * 3;
    const blackScreenDelay = 35 * 18;
    const textDelay = 35 * 5;

    int ticksSinceStart;
    double alpha;
    Vector2 textOffset;

    override void attachToOwner(Actor owner) {
        super.attachToOwner(owner);
        owner.setCamera(Level.createActorIterator(13).next());
    }

    override void update() {
        if (self.owner == null)
            return;

        ++self.ticksSinceStart;

        if (self.owner.getPlayerInput(modInput_oldButtons) & self.skipKey)
            self.startMap();
        else if (self.ticksSinceStart < self.blackScreenDelay)
            self.alpha = abs((self.ticksSinceStart % (self.flashDelay * 2) - self.flashDelay) / double(self.flashDelay));
        else if (self.ticksSinceStart == self.blackScreenDelay) {
            self.changeTextOffset();
            self.alpha = 0.0;
        }
        else {
            if (self.ticksSinceStart % 3 == 0)
                self.changeTextOffset();
            self.alpha = (self.ticksSinceStart - self.blackScreenDelay) / double(self.textDelay);
        }
    }

    override void draw(zmd_Hud hud, int state, double ticFrac) {
        if (self.owner == null)
            return;

        if (self.ticksSinceStart < self.blackScreenDelay)
            Screen.dim("black", self.alpha, 0, 0, Screen.getWidth(), Screen.getHeight());
        else {
            Screen.dim("black", 1.0, 0, 0, Screen.getWidth(), Screen.getHeight());
            hud.drawString(hud.screamFont, String.format("Doomed"), self.textOffset + (5, -85), hud.di_screen_center | hud.di_text_align_center, translation: Font.cr_red, alpha: (self.alpha - 0.1) * (self.alpha - 0.1), scale: (3, 6));
            hud.drawString(hud.screamFont, String.format("Zombies"), self.textOffset + (0, 10), hud.di_screen_center | hud.di_text_align_center, translation: Font.cr_red, alpha: self.alpha, scale: (3, 6));
        }
    }

    override void detachFromOwner() {
        zmd_InventoryGiver.giveTo(PlayerPawn(self.owner));
        self.owner.setCamera(self.owner);
        super.detachFromOwner();
    }

    action void startMap() {
        Actor.spawn('Weather');
        Weather.setPrecipitationType('BloodRain');

        Level.createActorIterator(115).next().destroy();
        thing_destroy(25);
        zmd_Rounds.fetch().globalSound.cut(chan_5);
        foreach (player : players) {
            if (player.mo != null) {
                zmd_Spectate.setOriginToSpawn(player.mo);
                player.mo.takeInventory('zmd_Intro', 1);
            }
        }
        zmd_Rounds.fetch().nextRound();
    }

    void changeTextOffset() {
        let limit = 1;
        self.textOffset = (random[offset](-limit, limit), (random[offset](-limit, limit)));
    }

    States {
    Held:
        tnt1 a 2;
        tnt1 a 0 thing_activate(20);
        tnt1 a 1015;
        tnt1 a 0 startMap;
    }
}

class zmd_SwayTarget : Actor {
    const maxWidth = 10;
    const maxHeight = 10;
    const ticksTillChange = 120;

    Vector3 originalPosition;
    Vector3 lastPosition;
    Vector3 targetPosition;
    int ticksSinceChange;

    static Vector3 lerp(Vector3 start, Vector3 end, double percent) {
        return start + percent * (end - start);
    }

    static Vector3 smoothStep(Vector3 start, Vector3 end, double ticks) {
        let percent = ticks / zmd_SwayTarget.ticksTillChange;
        return zmd_SwayTarget.lerp(start, end, percent * percent * percent * (percent * (6 * percent - 15) + 10));
    }

    override void beginPlay() {
        super.beginPlay();
        self.originalPosition = self.pos;
        self.changeTargetPosition();
    }

    override void tick() {
        if (self.ticksSinceChange == self.ticksTillChange) {
            self.ticksSinceChange = 0;
            self.changeTargetPosition();
        } else {
            ++self.ticksSinceChange;
            self.setXYZ(self.smoothStep(self.lastPosition, self.targetPosition, self.ticksSinceChange));
        }
    }

    void changeTargetPosition() {
        self.lastPosition = self.pos;
        self.targetPosition = self.originalPosition + (random[offset](-self.maxWidth, self.maxWidth), 0, random[offset](0, self.maxHeight));
    }
}

class zmd_Spectate : Inventory {
    static void setOriginToSpawn(Actor player) {
        zmd_Spectate.setOrigin(player, Level.createActorIterator(100 + player.playerNumber()).next().pos);
    }

    static void setOrigin(Actor player, Vector3 newPos) {
        LinkContext ctx;
        player.unlinkFromWorld(ctx);
        player.setXYZ(newPos);
        player.linkToWorld(ctx);
        player.findFloorCeiling(ffcf_onlySpawnPos);
    }

    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        zmd_InventoryManager(other.findInventory('zmd_InventoryManager')).spectating = true;
        self.setOrigin(self.owner, (-2150, 2500, 0));
        self.owner.setCamera(self.choosePlayer());
    }

    override void detachFromOwner() {
        let manager = zmd_InventoryManager(owner.findInventory('zmd_InventoryManager'));
        if (!manager.gameOver) {
            manager.spectating = false;
            self.setOriginToSpawn(self.owner);
            self.owner.setCamera(self.owner);
        }
        super.detachFromOwner();
    }

    Actor choosePlayer() {
        foreach (player : players)
            if (player.mo != null && player.mo.playerNumber() != self.owner.playerNumber())
                return player.mo;
        return null;
    }
}

class zmd_GameOverSpectate : Inventory {
    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        zmd_InventoryManager(other.findInventory('zmd_InventoryManager')).gameOver = true;
        zmd_Spectate.setOrigin(self.owner, (-2150, 2500, 0));
        self.owner.setCamera(Level.createActorIterator(11).next());
        thing_activate(11);
    }
}